module QuasiGLM

using DataFrames, Distributions, GLM, PrettyTables

include("PeripheralFunctions.jl")
include("AdjustQuasiGLM.jl")

# Exports

export PearsonResiduals
export EstimateDispersionParameter
export coefarray
export AdjustQuasiGLM

end
