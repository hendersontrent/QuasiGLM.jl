# QuasiGLM

Adjust Poisson and Binomial Generalised Linear Models to their quasi equivalents for dispersed data

## Installation

You can install `QuasiGLM.jl` from the Julia Registry once it has been accepted via:

```
using Pkg
Pkg.add("QuasiGLM")
```

## Motivation

`R` has an excellent interface for specifying [generalised linear models](https://en.wikipedia.org/wiki/Generalized_linear_model) (GLM) and its base functionality includes a wide variety of probability distributions and link functions. [`GLM.jl`](https://juliastats.org/GLM.jl/v0.11/) in `Julia` is also excellent, and boasts a similar (and also excellent!) interface. However, in `GLM.jl`, two key models are not readily available:

1. quasipoisson
2. quasibinomial

While neither defines an explicit probability distribution, these models are useful in a variety of contexts as they enable the modelling of overdispersion in data. If the data is indeed overdispersed, the estimated dispersion parameter will be >1. Failure to estimate and adjust for this dispersion may lead to inaccurate statistical inference.

`QuasiGLM.jl` is a simple package that provides intuitive one-line-of-code adjustments to existing Poisson and Binomial `GLM.jl` models. It achieves this through adjustments to standard errors which flows through to updated test statistics, *p*-values, and confidence intervals.

## Usage

Adjustments can be made to existing `GLM` models in `Julia` simply using `QuasiGLM.jl`:

```
using DataFrames, CategoricalArrays, GLM, QuasiGLM

dobson = DataFrame(Counts = [18,17,15,20,10,20,25,13,12], Outcome = categorical([1,2,3,1,2,3,1,2,3]), Treatment = categorical([1,1,1,2,2,2,3,3,3]))

gm = fit(GeneralizedLinearModel, @formula(Counts ~ Outcome + Treatment), dobson, Poisson())

testOutputs = AdjustQuasiGLM(gm, dobson; level=0.95)
```

## Citation instructions

If you use `QuasiGLM.jl` in your work, please cite it using the following (included as BibTeX file in the package folder):

```
@Manual{QuasiGLM.jl,
  title={{QuasiGLM.jl}},
  author={Henderson, Trent},
  year={2022},
  month={2},
  url={https://doi.org/10.5281/zenodo.5173723},
  doi={10.5281/zenodo.5173723}
}
```
