# Allocation tests using @allocated from Base
# No external packages required
using SciMLPublic
using Test

@testset "Allocation Tests" begin
    @testset "_is_valid_macro_expr non-allocating fast paths" begin
        # Test cases that should not allocate (early return false cases)
        # These are the "hot paths" that return early without allocating

        # Non-macrocall expressions should not allocate
        non_macrocall = Meta.parse("foo()")
        # Warmup
        SciMLPublic._is_valid_macro_expr(non_macrocall)
        @test (@allocated SciMLPublic._is_valid_macro_expr(non_macrocall)) == 0

        # Macrocall with wrong number of args should not allocate
        wrong_args = Meta.parse("@foo bar")
        # Warmup
        SciMLPublic._is_valid_macro_expr(wrong_args)
        @test (@allocated SciMLPublic._is_valid_macro_expr(wrong_args)) == 0

        # Note: The true path (valid macro expressions) does allocate due to
        # the string() call, but this is acceptable since macro validation
        # only happens at compile time, not runtime.
    end

    @testset "_get_symbols expected allocations" begin
        # Test that _get_symbols has minimal allocations after warmup
        # Julia's compiler can often optimize away small allocations

        sym = :foo
        # Warmup
        SciMLPublic._get_symbols(sym)
        SciMLPublic._get_symbols(sym)

        # After warmup, allocations should be minimal or zero
        alloc = @allocated SciMLPublic._get_symbols(sym)
        @test alloc <= 128  # Allocations should be small (at most a 1-element vector)
    end
end
