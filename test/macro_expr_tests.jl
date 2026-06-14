using SciMLPublic
using Test

@testset "_is_valid_macro_expr" begin
    good_exprs = [
        :(@hello),
        Meta.parse("@hello"),
        Meta.parse("@hello()"), # Is this correct?
    ]
    bad_exprs = [
        Meta.parse("@foo bar"),
        Meta.parse("@foo(bar)"),
        Meta.parse("foo()"),
        Meta.parse("foo(@bar)"),
        Meta.parse("@foo @bar"),
        Meta.parse("@foo(@bar)"),
    ]
    for expr in good_exprs
        @test SciMLPublic._is_valid_macro_expr(expr)
    end
    for expr in bad_exprs
        @test !SciMLPublic._is_valid_macro_expr(expr)
    end
end
