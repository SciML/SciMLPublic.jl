using SciMLPublic
using Test

@testset "_get_symbols" begin
    @test SciMLPublic._get_symbols(:foo) == [:foo]
    @test SciMLPublic._get_symbols(:((a, b, c))) == [:a, :b, :c]
    @test SciMLPublic._get_symbols(:(@hello)) == [Symbol("@hello")]
    @test SciMLPublic._get_symbols(:((foo, bar, @hello))) == [:foo, :bar, Symbol("@hello")]
end
