using SciMLPublic
using Aqua
using JET
using Test

@testset "Aqua" begin
    Aqua.test_all(SciMLPublic)
end

@testset "JET" begin
    JET.test_package(SciMLPublic; target_defined_modules = true)
end
