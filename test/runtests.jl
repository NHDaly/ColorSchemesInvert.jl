using ColorSchemesInvert
using Base.Test
using Colors

@testset "invert tests" begin
cs = linspace(RGB(0,0,0), RGB(1,1,1),5);
@test invert(cs, cs[3]) == 0.5

# Note that invert() takes the first closest match.
cs = [RGB(0,0,0), RGB(1,1,1),
      RGB(0,0,0),
      RGB(0,0,0), RGB(1,1,1)];
@test invert(cs, cs[3]) == 0

# Note that invert() takes the left index when two are identical.
cs = [RGB(1,1,1), RGB(0,0,0), RGB(0,0,0), RGB(0,1,1), RGB(1,1,0)];
@test invert(cs, cs[2]) == 0.25
cs = [RGB(0,0,0), RGB(0,0,0)];
@test invert(cs, cs[1]) == 0

cs = [RGB(0,0,0)];
@test_throws InexactError invert(cs, cs[1])
# (The above line throws for the same reason the below line does.
#  If this behavior ever changes, so should `invert`.)
@test_throws InexactError get(cs, 1.0, (1,1))
end
