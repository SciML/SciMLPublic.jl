import SciMLPublic
import Test

using Test: @testset
using SafeTestsets: @safetestset

const GROUP = get(ENV, "GROUP", "All")

if GROUP == "QA"
    include(joinpath(@__DIR__, "qa", "qa.jl"))
else
    @testset "SciMLPublic.jl package" begin
        @safetestset "_is_valid_macro_expr" begin
            include("macro_expr_tests.jl")
        end
        @safetestset "_get_symbols" begin
            include("get_symbols_tests.jl")
        end

        @safetestset "Tests for TestModule1" begin
            include("testmodule1_tests.jl")
        end

        # Allocation tests - run in the Core/All groups
        @safetestset "Allocation Tests" begin
            include("alloc_tests.jl")
        end
    end
end
