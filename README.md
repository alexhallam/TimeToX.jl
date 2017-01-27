A package for survival anlysis, reliability, and other time-to-event modeling. 

The purpose of this package is to take tidy data as an input and return calculations as a fit and as tidy data. No ploting is done in this package. Outstanding plotting packages are already available in julia such as Plot.jl and Gadfly.jl. Tutorials will be made available on how to plot time-to-event.

Installation
---

```julia
Pkg.clone("https://github.com/alexhallam/TimeToX.jl")
```

Will install the package in dependencies.

Estimating The Surival Function
---

To estimate the survival function use the general form `est_surv(times, is_censored, method)`

* `times` is a vector of total times such as length of follow up.

* `is_censored` is a vector of ones and zeros. `1` indicates that the event is censored and `0` indicates that it is not censored. 

* `method` is the desired method to estimate the survival function. The default is the Kaplan-Meier estimator. Other options are ... TBD.

Examples
---

![](https://github.com/alexhallam/TimeToX.jl/blob/master/readme_assets/est_surv.gif)
