using DataFrames, CategoricalArrays, GLM, Distributions, PrettyTables, Test

#------------- Run package tests --------------

@testset "QuasiGLM.jl" begin

    #-------------
    # Quasipoisson
    #-------------
    
    # Define some data
    
    dobson = DataFrame(Counts = [18,17,15,20,10,20,25,13,12], Outcome = categorical([1,2,3,1,2,3,1,2,3]), Treatment = categorical([1,1,1,2,2,2,3,3,3]))
    
    # Fit Poisson model
    
    gm = fit(GeneralizedLinearModel, @formula(Counts ~ Outcome + Treatment), dobson, Poisson())
    
    # Correct standard errors using quasi correction
    
    testOutputs = AdjustQuasiGLM(gm, dobson; level=0.95)
    @test testOutputs isa DataFrames.DataFrame
end