#!/usr/bin/env julia

VERSION >= v"0.4" && __precompile__()

module ColorSchemesInvert

using ColorTypes, ColorSchemes


"""
    invert(cscheme, c)

Compute the percentage value of the colors in cscheme.

# Examples
```julia-repl
    julia> invert(ColorSchemes.leonardo, RGB(1,0,0))
    0.625…
    julia> invert([RGB(0,0,0), RGB(1,1,1)], RGB(.5,.5,.5))
    0.543…
    julia> cs = linspace(RGB(0,0,0), RGB(1,1,1),5)
    julia> invert(cs, cs[3])
    0.500
```
"""
function invert(cscheme::Vector{C}, c, rangescale :: Tuple{Number, Number}=(0.0, 1.0)) where {C<:Colorant}
    cdiffs = map(c_i->colordiff(promote(c,c_i)...), cscheme)
    closest = indmin(cdiffs)
    left = right = 0;
    if closest == 1 ; left = closest; right = closest + 1;
    elseif closest == length(cscheme) ; left = closest - 1; right = closest;
    else
        next_closest = cdiffs[closest-1] < cdiffs[closest+1] ? closest-1 : closest+1
        left = min(closest, next_closest)
        right = max(closest, next_closest)
    end

    left
    right
    v = left + ( cdiffs[left] / (cdiffs[left] + cdiffs[right]))
    return ColorSchemes.remap(v, 1, length(cscheme), rangescale...)
end


"""
    convertToScheme(cscheme, img)

Converts img from its current color values to use only the colors defined in cscheme.

```julia
image = nonTransparentImg
convertToScheme(ColorSchemes.leonardo, image)
convertToScheme(ColorSchemes.Paired_12, image)
```
"""
convertToScheme(cscheme::Vector{C},img) where {C<:Colorant} =
    map(c->get(cscheme, invert(cscheme, c)), img)

end
