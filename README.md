TimeToX
===========

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/concept.svg)](http://www.repostatus.org/#concept)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

Time-to-event analysis in Julia.

Installation
------------

```julia
Pkg.clone("https://github.com/alexhallam/TimeToX.jl")
```

Getting Started
----------------

This package has the following actions.

* Estimates the survival function `est_surv`

* Describes the survival function `describe_surv`

* Compares two or more survival functions `compare_surv`


Estimating The Event (Surival) Function
---

To estimate the survival function use the general form `est_surv(times, is_censored, method)`

* `times` is a vector of total times such as length of follow up.

* `is_censored` is a vector of ones and zeros. `1` indicates that the event is censored and `0` indicates that it is not censored.

* `method` is the desired method to estimate the survival function. The default is the Kaplan-Meier estimator. Other options are ... TBD.

Describing The Survival Function
----------------------------------

Quantiles are a common discriptive statistic of the survival fucntion.

Comparing Survival Functions
-----------------------------


Examples
---

###Standard Kaplan-Meier estimates:

Functions of this type of the following form

```julia
est_surv(times, is_censored, method = "km")
```

Lets run through an example with the `whas100` dataset which is included in
this package.

```julia
julia> whas100 = readtable("../datasets/whas100.csv")
julia> times = whas100[:lenfol]
julia> is_censored = whas100[:fstat]
julia> fit = est_surv(times, is_censored, method = "km")
95×5 DataFrames.DataFrame
│ Row │ time │ nrisk │ nevent │ ncensor │ estimate │
├─────┼──────┼───────┼────────┼─────────┼──────────┤
│ 1   │ 6    │ 100   │ 2      │ 0       │ 0.98     │
│ 2   │ 14   │ 98    │ 1      │ 0       │ 0.97     │
│ 3   │ 44   │ 97    │ 1      │ 0       │ 0.96     │
│ 4   │ 62   │ 96    │ 1      │ 0       │ 0.95     │
│ 5   │ 89   │ 95    │ 1      │ 0       │ 0.94     │
│ 6   │ 98   │ 94    │ 1      │ 0       │ 0.93     │
│ 7   │ 104  │ 93    │ 1      │ 0       │ 0.92     │
│ 8   │ 107  │ 92    │ 1      │ 0       │ 0.91     │
⋮
│ 87  │ 2595 │ 9     │ 0      │ 1       │ 0.432674 │
│ 88  │ 2610 │ 8     │ 0      │ 1       │ 0.432674 │
│ 89  │ 2613 │ 7     │ 0      │ 1       │ 0.432674 │
│ 90  │ 2624 │ 6     │ 1      │ 0       │ 0.360561 │
│ 91  │ 2631 │ 5     │ 0      │ 1       │ 0.360561 │
│ 92  │ 2638 │ 4     │ 0      │ 1       │ 0.360561 │
│ 93  │ 2641 │ 3     │ 0      │ 1       │ 0.360561 │
│ 94  │ 2710 │ 2     │ 1      │ 0       │ 0.180281 │
│ 95  │ 2719 │ 1     │ 0      │ 1       │ 0.180281 │

julia> Pkg.add("Gadfly")
julia> using Gadfly
# Blow I divide time by 7 to show weeks instead of days
julia> plot(y=fit[:estimate], x=fit[:time]/7, Geom.step)
```
![image](km_img.png)

###Quantiles


What this does
--------------

**Event Functions as Verbs**: Describes time-to-event functions as verbs to make it clear what
 is being done to your event data.

**Outputs [Tidy Data](http://vita.had.co.nz/papers/tidy-data.pdf)**: Ouputs calculations as tidy data.
Tidy data is language agnostic and an efficient way to work with data.

**Act as Part of the Julia Statistics Eco System**: This package is not ambitious. It is not
trying to do everything. It simply takes event data in returns values that are specific to
time-to-event analysis. As a result plotting is not part of this package, as
[Gadfly](http://gadflyjl.org/stable/) and [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
are good plotting libraries. Also, the survival function can be estimated with many methods,
Some of those methods are parametric. It should be possible to use the
[Distributions.jl](https://github.com/JuliaPlots/Plots.jl) package to do this kind of analysis.


What this does not do
----------------------

**Name functions according to statistical test**: This may turn out to be a bad idea. I am not sure.

**Ouput data in various formats**: A huge amount of time is spent cleaning data to get ready
for analysis. One solution to this problem is to have packages involved in the data pipline
to ouput data as tidy data whenever possible.

**Act independent**: It would be a waste of users resources to make a user learn
how to plot in in this package, or how to estimate parametric distributions in this
package. This work has already been done by talented developers. This package
provides neccesary time-to-event related calculations/summaries/comparisons
and tries to do nothing more.
