"""
    AdjustQuasiGLM(model, ϕ; level)

Estimates dispersion parameter, adjusts original GLM to reflect the dispersion and returns results in a pretty DataFrame.

Usage:
```julia-repl
AdjustQuasiGLM(model, ϕ; level)
```
Arguments:
- `model` : The `GLM` model.
- `data` : The `DataFrame` containing data that was used as input to the model.
- `level` : The desired degree of confidence.
"""

function AdjustQuasiGLM(model::StatsModels.TableRegressionModel, data::DataFrame; level::Real=0.95)
    
    # Calculate Pearson residuals

    resids = PearsonResiduals(model, data)

    # Estimate dispersion parameter ϕ and take √ to convert to multiplier

    ϕ = √EstimateDispersionParameter(resids, model)

    # Correct standard errors and calculate updated test statistics, p-values, and confidence intervals

    CorrectedOutputs = coefarray(model, ϕ; level)
    levstr = isinteger(level * 100) ? string(Integer(level * 100)) : string(level * 100)
    header = (["Parameter", "Estimate", "Std. Error", "t value", "Pr(>|t|)", "Lower $levstr%", "Upper $levstr%"])

    #--------------------------------------------
    # Organise results in a neat coeftable format
    #--------------------------------------------

    # Table formatting

    ctf = TextFormat(
    up_right_corner = ' ',
    up_left_corner = ' ',
    bottom_left_corner = ' ',
    bottom_right_corner = ' ',
    up_intersection = '─',
    left_intersection = ' ',
    right_intersection = ' ',
    middle_intersection = '─',
    bottom_intersection = '─',
    column = ' ',
    hlines = [ :begin, :header, :end]
    )

    # Render table

    println("\nCoefficients:")
    CorrectedOutputsPretty = PrettyTables.pretty_table(CorrectedOutputs; header = header, tf = ctf)

    # Return results in a DataFrame for further use

    CorrectedOutputs = DataFrame(CorrectedOutputs, :auto)

    CorrectedOutputs = rename!(CorrectedOutputs, [:x1, :x2, :x3, :x4, :x5, :x6, :x7] .=>  [Symbol(header[1]), Symbol(header[2]), Symbol(header[3]), Symbol(header[4]), Symbol(header[5]), Symbol(header[6]), Symbol(header[7])])

    # Recode column types from `Any` to `String` for parameter names and `Float64` for values columns

    for i in 2:size(header, 1)
        CorrectedOutputs[!, i] = convert(Array{Float64, 1}, CorrectedOutputs[!, i])
    end

    CorrectedOutputs[!, 1] = convert(Array{String, 1}, CorrectedOutputs[!, 1])
    return CorrectedOutputs
end
