A package for survival anlysis, reliability, and other time-to-event modeling. kkk

The purpose of this package is to take tidy data as an input and return calculations as a fit and as tidy data. No ploting is done in this package. Outstanding plotting packages are already available in julia such as Plot.jl and Gadfly.jl. Tutorials will be made available on how to plot time-to-event.

Time-to-Event
---

Time-to-event analysis investigates the length of time until an even occurs. The even can be death, failure, outcome, ect. Time to event data is a general umbrella that includes topics such as [survival analysis](https://en.wikipedia.org/wiki/Survival_analysis), [reliability engineering](https://en.wikipedia.org/wiki/Reliability_engineering), and many others. It has applications in the modeling patient survival in the medical field, modeling customer subscription length, and [HR](https://www.quora.com/What-are-common-applications-of-survival-analysis-in-current-online-services).

Definitions
---

**Censoring**: Occurs when an event time is not completely observed. For examples a 5 year study observes the time until a fracture in men over 75. Of 50 subjects 45 had a fracture while 5 did not have a fractures withing the five year window of the study. Since these five patients never had a fracture we can not give them a "Time-to-Fracture" value. We call this *censoring*. Handling censoring corrctly is important as alternatives - such as thorwing out censored observations, or treating censored observations as exact will introduce serious bias.


Right Censor: observation begins at t=0 and terminates before even of interest occurs. This may be the most common type of censoring. 

Left Censor: The event of interest already occured before observations began. For example, while preparing a study to collected data on the survival of patients given a new drug a handful of patients die befor observations start. 

Interval censoring: Censoring happens whithin an interval, but the exact time of the censor is unknown. For example, a company collects data on the reliability of its power generators every year. Though the exact time of the failure may not be known an interval of one year can be given.  

**Truncation**: Truncation is different from censoring. Truncation gives incomplete observations due to a selection process inherent in the design. 

Dataset
---

**WHAS100**: Worcester Heart Attack Study - Hosmer and Lemeshow. Observational cohort study of over 11,000 participants designed to investigate factors and time trends associated with long term survival following acute myocardial infarction among residents of Worcester, Massachusetts. 100 patients were sampled for this dataset. 

**aml**: Preliminary results from a clinical trial in 1977. Evaluated the efficacy of maintained cheomotherapy for acute myelogenous leukemia (AML). The first group rereceived maintenance chemo and the second group (control) did not. The goal was to see if maintainance of chemo prolonged the time until relapse.

Time-to-Event Modeling - A Review
---

The cumulative density function is F(t) = P(T <= t). The survival function is S(t) = P(T>t) which can also be stated as S(t) = 1 - F(t). It is this survival function this is the main interest in time-to-event analysis. 

Estimating the Survival Function:

###Non-Parametric

The **Kaplan-Meier Estimator** (aka product-limit estimator) is the most common way to estimate the survival function. It computes the conditional probability of confirmed survival at every time point t. Then it multiplies conditional probabilities from all time points T<t. The result, when ploted, looks like a step function.

**Life Tables**

###Parametric

The Weibull distribution. This is a parametric way to estimate the survival function, but it is less common. 


