using DataFrames, CategoricalArrays, GLM, Distributions, PrettyTables, QuasiGLM, Test

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

    #--------------
    # Quasibinomial
    #--------------
    
    # Set up data and divide percentage by 100 to get proportion
    
    blotchData = DataFrame(blotch = [0.05,0.00,1.25,2.50,5.50,1.00,5.00,5.00,17.50,0.00,0.05,1.25,0.50,1.00,5.00,0.10,10.00,25.00,0.00,0.05,2.50,0.01,6.00,5.00,5.00,5.00,42.50,0.10,0.30,16.60,3.00,1.10,5.00,5.00,5.00,50.00,0.25,0.75,2.50,2.50,2.50,5.00,50.00,25.00,37.50,0.05,0.30,2.50,0.01,8.00,5.00,10.00,75.00,95.00,0.50,3.00,0.00,25.00,16.50,10.00,50.00,50.00,62.50,1.30,7.50,20.00,55.00,29.50,5.00,25.00,75.00,95.00,1.50,1.00,37.50,5.00,20.00,50.00,50.00,75.00,95.00,1.50,12.70,26.25,40.00,43.50,75.00,75.00,75.00,95.00], variety = categorical(repeat([1,2,3,4,5,6,7,8,9], inner=1, outer=10)), site = categorical(repeat([1,2,3,4,5,6,7,8,9,10], inner=9, outer=1)))
    
    blotchData.blotch = blotchData.blotch ./ 100
    
    # Fit binomial model
    
    gm2 = fit(GeneralizedLinearModel, @formula(blotch ~ variety + site), blotchData, Binomial())

    # Correct standard errors using quasi correction
    
    testOutputs2 = AdjustQuasiGLM(gm2, blotchData; level=0.95)
    @test testOutputs2 isa DataFrames.DataFrame
end