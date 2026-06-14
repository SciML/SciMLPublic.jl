using SciMLPublic
using Test

module TestModule1

    using SciMLPublic: @public

    export f
    @public g

    function f end
    function g end
    function h end

end # module TestModule1

function _public_names(mod::Module)
    result = Base.names(
        mod;
        all = false,
        imported = false
    )
    return result
end

@testset "Tests for TestModule1" begin
    @test Base.isexported(TestModule1, :f)
    @test !Base.isexported(TestModule1, :g)
    @test !Base.isexported(TestModule1, :h)

    # `Base.ispublic` was added in Julia 1.11
    @static if Base.VERSION >= v"1.11.0-DEV.469"
        @test Base.ispublic(TestModule1, :f)
        @test Base.ispublic(TestModule1, :g)
        @test !Base.ispublic(TestModule1, :h)
    end

    @static if Base.VERSION >= v"1.11.0-DEV.469"
        @test :f ∈ _public_names(TestModule1)
        @test :g ∈ _public_names(TestModule1)
        @test :h ∉ _public_names(TestModule1)
    else
        @test :f ∈ _public_names(TestModule1)
        @test :g ∉ _public_names(TestModule1)
        @test :h ∉ _public_names(TestModule1)
    end
end
