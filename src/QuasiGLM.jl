module QuasiGLM

using DataFrames, Distributions, GLM, PrettyTables

include("PeripheralFunctions.jl")
include("AdjustGLMToQuasi.jl")

# Exports

export PearsonResiduals
export EstimateDispersionParameter
export coefarray
export AdjustGLMToQuasi

end
