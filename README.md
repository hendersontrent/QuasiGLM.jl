# QuasiGLM

Adjust Poisson and Binomial Generalised Linear Models to their quasi equivalents for dispersed data

## Installation

You can install `QuasiGLM.jl` from the Julia Registry via:

```
using Pkg
Pkg.add("QuasiGLM")
```

## Motivation

`R` has an excellent interface for specifying [generalised linear models](https://en.wikipedia.org/wiki/Generalized_linear_model) (GLM) and its base functionality includes a wide variety of probability distributions and link functions. [`GLM.jl`](https://juliastats.org/GLM.jl/v0.11/) in `Julia` is also excellent with a very similar interface, however, two key GLMs are not readily available:

1. quasipoisson
2. quasibinomial

While not explicit probability distributions, these models are useful in a variety of contexts as they enable the modelling of overdispersion in the data. If the data is indeed overdispersed, the estimated dispersion parameter will be >1. Failure to estimate this dispersion may lead to inaccurate statistical inference.

`QuasiGLM.jl` provides a simple interface for adjusting existing Poisson and Binomial `GLM.jl` models to enable better statistical inference through adjustments to standard errors which flows through to updated test statistics, *p*-values, and confidence intervals.

## Usage

Adjustments can be made to existing `GLM` models in `Julia` simply using `QuasiGLM.jl`:

```
using DataFrames, CategoricalArrays, GLM, QuasiGLM

dobson = DataFrame(Counts = [18,17,15,20,10,20,25,13,12], Outcome = categorical([1,2,3,1,2,3,1,2,3]), Treatment = categorical([1,1,1,2,2,2,3,3,3]))

gm = fit(GeneralizedLinearModel, @formula(Counts ~ Outcome + Treatment), dobson, Poisson())

testOutputs = AdjustGLMToQuasi(gm, dobson; level=0.95)
```
