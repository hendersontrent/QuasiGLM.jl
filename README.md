# QuasiGLM

Adjust Poisson and Binomial Generalised Linear Models to their quasi equivalents for dispersed data

## Installation

You can install `QuasiGLM.jl` from the Julia Registry once it has been accepted via:

```
using Pkg
Pkg.add("QuasiGLM")
```

## Motivation

`R` has an excellent interface for specifying [generalised linear models](https://en.wikipedia.org/wiki/Generalized_linear_model) (GLM) and its base functionality includes a wide variety of probability distributions and link functions. [`GLM.jl`](https://juliastats.org/GLM.jl/v0.11/) in `Julia` is also excellent, and boasts a similar interface to its `R` counterpart. However, in `GLM.jl`, two key model types are not readily available:

1. quasipoisson
2. quasibinomial

While neither defines an explicit probability distribution, these models are useful in a variety of contexts as they enable the modelling of overdispersion in data. If the data is indeed overdispersed, the estimated dispersion parameter will be >1. Failure to estimate and adjust for this dispersion may lead to inappropriate statistical inference.

`QuasiGLM.jl` is a simple package that provides intuitive one-line-of-code adjustments to existing Poisson and Binomial `GLM.jl` models to convert them to their quasi equivalents. It achieves this through estimating the dispersion parameter and using this to make adjustments to standard errors. These adjustments then flow through to updated test statistics, *p*-values, and confidence intervals.

## Usage

Here's a Poisson to quasipoisson conversion using the Dobson (1990) Page 93: Randomized Controlled Trial dataset (as presented in the [`GLM.jl` documentation](https://juliastats.org/GLM.jl/v0.11/#Fitting-GLM-models-1)).

```
using DataFrames, CategoricalArrays, GLM, QuasiGLM

dobson = DataFrame(Counts = [18,17,15,20,10,20,25,13,12], Outcome = categorical([1,2,3,1,2,3,1,2,3]), Treatment = categorical([1,1,1,2,2,2,3,3,3]))

gm = fit(GeneralizedLinearModel, @formula(Counts ~ Outcome + Treatment), dobson, Poisson())
testOutputs = AdjustQuasiGLM(gm, dobson; level=0.95)
```

And here's a binomial to quasibinomial example using the leaf blotch dataset (McCullagh and Nelder (1989, Ch. 9.2.4)) as seen in multiple textbooks and the [SAS documentation](https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_glimmix_sect016.htm):

```
using DataFrames, CategoricalArrays, GLM, QuasiGLM
    
blotchData = DataFrame(blotch = [0.05,0.00,1.25,2.50,5.50,1.00,5.00,5.00,17.50,0.00,0.05,1.25,0.50,1.00,5.00,0.10,10.00,25.00,0.00,0.05,2.50,0.01,6.00,5.00,5.00,5.00,42.50,0.10,0.30,16.60,3.00,1.10,5.00,5.00,5.00,50.00,0.25,0.75,2.50,2.50,2.50,5.00,50.00,25.00,37.50,0.05,0.30,2.50,0.01,8.00,5.00,10.00,75.00,95.00,0.50,3.00,0.00,25.00,16.50,10.00,50.00,50.00,62.50,1.30,7.50,20.00,55.00,29.50,5.00,25.00,75.00,95.00,1.50,1.00,37.50,5.00,20.00,50.00,50.00,75.00,95.00,1.50,12.70,26.25,40.00,43.50,75.00,75.00,75.00,95.00], variety = categorical(repeat([1,2,3,4,5,6,7,8,9], inner=1, outer=10)), site = categorical(repeat([1,2,3,4,5,6,7,8,9,10], inner=9, outer=1)))
    
blotchData.blotch = blotchData.blotch ./ 100
gm2 = fit(GeneralizedLinearModel, @formula(blotch ~ variety + site), blotchData, Binomial())
testOutputs2 = AdjustQuasiGLM(gm2, blotchData; level=0.95)
```

### Comparison to R results

Note that results do not exactly equal the `R` equivalent of GLMs fit with `quasibinomial` or `quasipoisson` families. While explorations are continuing, the discrepancy is believed to be the result of differences in optimisation methods in the GLM machinery and floating point calculations.

For example, in the quasipoisson example presented above, the dispersion parameter returned by `QuasiGLM.jl` and `R`'s `glm` function with quasipoisson family are equivalent, and the numerical values for the `Intercept` and `Outcome` in the summary coefficient table are also equivalent. However, the `Treatment` variable exhibits different coefficient estimates despite exhibiting the same standard error and *p*-values.

Here is the `R` code to test it:

```
dobson <- data.frame(Counts = c(18,17,15,20,10,20,25,13,12), Outcome = as.factor(c(1,2,3,1,2,3,1,2,3)), Treatment = as.factor(c(1,1,1,2,2,2,3,3,3)))

mod <- glm(Counts ~ Outcome + Treatment, dobson, family = quasipoisson)
summary(mod)
```

## Citation instructions

If you use `QuasiGLM.jl` in your work, please cite it using the following (included as BibTeX file in the package folder):

```
@Manual{QuasiGLM.jl,
  title={{QuasiGLM.jl}},
  author={Henderson, Trent},
  year={2022},
  month={2},
  url={https://github.com/hendersontrent/QuasiGLM.jl}
}
```
