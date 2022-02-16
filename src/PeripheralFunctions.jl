"""
    PearsonResiduals(model, data)

Calculates Pearson residuals between model predicted values and the actual response variable values.

Usage:
```julia-repl
PearsonResiduals(model, data)
```
Arguments:
- `model` : The `GLM` model.
- `data` : The `DataFrame` containing data that was used as input to the model.
"""

function PearsonResiduals(model::StatsModels.TableRegressionModel, data::DataFrame)

    # Generate predictions

    f_hat = predict(model)

    # Parse response vector

    y_name = string(formula(model).lhs)
    y = Array(data[!, names(data, y_name)])

    # Calculate residuals as per https://www.datascienceblog.net/post/machine-learning/interpreting_generalized_linear_models/

    r = (y .- f_hat) ./ .√(f_hat)
    r = sum(r .^ 2)
    return r
end

"""
    EstimateDispersionParameter(residuals, model)

Estimates the dispersion parameter ϕ by standardising the sum of squared Pearson residuals against the residual degrees of freedom.

Usage:
```julia-repl
EstimateDispersionParameter(residuals, model)
```
Arguments:
- `residuals` : The sum of squared Pearson residuals.
- `model` : The `GLM` model.
"""

function EstimateDispersionParameter(residuals::Float64, model::StatsModels.TableRegressionModel)

    # Calculate dispersion/scale parameter estimate by dividing Pearson residuals by residual degrees of freedom

    ϕ = residuals / (dof_residual(model) - 1) # This aligns calculation with R's df.residuals function
    println("\nDispersion parameter (ϕ) for model taken to be " * string(round(ϕ, digits = 5)))
    println("Standard errors are multiplied by " * string(round(sqrt(ϕ), digits = 5)) * " to adjust for dispersion parameter (ϕ)")
    return ϕ
end

"""
    coefarray(model, ϕ; level)

Calculates relevant statistics for inference based of estimates and dispersion-adjusted standard errors and returns results in a concatenated array.

Usage:
```julia-repl
coefarray(model, ϕ; level)
```
Arguments:
- `model` : The `GLM` model.
- `ϕ` : The estimated dispersion parameter.
- `level` : The desired degree of confidence.
"""

function coefarray(model::StatsModels.TableRegressionModel, ϕ::Real; level::Real=0.95)
    cc = coef(model)
    se = stderror(model) * ϕ
    tt = cc ./ se
    p = ccdf.(Ref(FDist(1, dof_residual(model))), abs2.(tt))
    ci = se * quantile(TDist(dof_residual(model)), (1 - level) / 2)
    ct = hcat(coefnames(model), cc, se, tt, p, cc + ci, cc - ci)
    return ct
end
