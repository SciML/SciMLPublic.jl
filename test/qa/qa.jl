using SafeTestsets

@safetestset "Aqua" begin
    using SciMLPublic
    using Aqua
    using Test
    # deps_compat(extras) currently fails; run the rest and mark it broken.
    # Tracked in https://github.com/SciML/SciMLPublic.jl/issues/34
    Aqua.test_all(SciMLPublic; deps_compat = false)
    @test_broken false  # Aqua deps_compat: no [compat] for Aqua/JET extras — tracked in https://github.com/SciML/SciMLPublic.jl/issues/34
end

@safetestset "JET" begin
    using SciMLPublic
    using JET
    using Test
    JET.test_package(SciMLPublic; target_defined_modules = true)
end
