using ColorSchemesInvert
using Base.Test

cs = linspace(RGB(0,0,0), RGB(1,1,1),5)
@test invert(cs, cs[3]) == 0.5
