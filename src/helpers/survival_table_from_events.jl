"""
`survival_table_from_events()`

Description
============

This is a helper function. It is used in `compare_surv` to help compute the
log-rank.

It retuns a data frame

Usage
======

Called in compare_surv.jl

  include("helpers/survival_table_from_events.jl")
  table = survival_table_from_events(times,is_censored,group)


Arguments
=========

- **`time`** : The unique times to event.

- **`is_censored`** : A vector of bools. 1 == censored and 0 == not censored

- **`is_control`** : A vector of bools. 1 == control group and 0 == treatment

Returns
========

Description of Variables Used In Code
======================================

		| Event/Group   | Control    | Treatment | Total    |
		| ------------- | ---------- | --------- | -------- |
		| Failure       | d1i        | d0i       | di       |
		| Non-Failure   | n1i - d1i  | n0i - d0i | ni-di    |
		| Total         | n1i        | n0i       | ni       |

		n0i = `control_total` = number at risk at time i in group 0
		n1i = `treatment_total` = number at risk at time i in group 1
		d0i = `control_failure` = number of failure at time i in group 0
		d1i = `treatment_failure` = number of deaths at time i in group 1
		ni = `table_total` = total number at risk at time i
		di = `failure_total` = total number of deaths at time i

"""

function survival_table_from_events(
	times,
	is_censored,
  is_control
  )

  # sort unique times
  t = sort!(unique(times))

  # sum the number of times an event happens. if the event was censored it does
  # not count as an event.
  #`findin`: find the index in `times` when the value of `times` is `i`
  nevent = [sum(is_censored[findin(times, i)]) for i in t]

  # as events happen the number at risk decreases. as j iterates through t all
  # i gerater than j is counted.
  nrisk = [count(i->(i>=j),times) for j in t]

  # for each unique time count the censored events
  ncensor = [count(i->(i==0), is_censored[findin(times, j)]) for j in t]

  # control_total: at time t how many are in the control arm. This is usually
  # decraseing value as time increases.
  len = length(is_control)
  control_total = [sum(is_control[i:len]) for i = 1:len]

  # control_failure: for each time is either one or zero. One if the event waste
  # in the control group zero otherwise.
  control_failure = [is_control[i] != 0 ? 1 : 0 for i = 1:len]

  # treatment_total
  is_treatment = [is_control[i] == 0 ? 1 : 0 for i = 1:len]
  treatment_total = [sum(is_treatment[i:len]) for i = 1:len]

  # treatment_failure
  treatment_failure = [is_treatment[i] != 0 ? 1 : 0 for i = 1:len]

  #Expected value: E[control_failure]
  table_total = nrisk
  failure_total = nevent
  expected_value = [(control_total[i]*failure_total[i])/table_total[i] for i = 1:len]

  #variance: VAR[control_failure]
  variance = [(control_total[i]*treatment_total[i]*failure_total[i]*(table_total[i]-failure_total[i]))/((table_total[i])^2*(table_total[i]-1)) for i = 1:len]
  #if variance is divided by 0 (i.e. if the last table_total is 1) we want 0 not NaN
  variance = [isnan(variance[i]) == true ? 0.0 : variance[i] for i = 1:len]

  # Output DataFrame
  survivalOutput = DataFrame(
  times = t,
  table_total = table_total,
  failure_total = failure_total,
  control_total = control_total,
  control_failure = control_failure,
  treatment_total = treatment_total,
  treatment_failure = treatment_failure,
  expected_value = expected_value,
  variance = variance
#  table_expected =
#  table_varience =
     );

table = @where(survivalOutput, :failure_total .!= 0)

return(table)

# The following code is in compare_surv

##log-rank test statistic
#sum of control_failure - sum of expected_value
#U = sum(table[:control_failure]) - sum(table[:expected_value])
#sum of varianec
#V = sum(table[:variance])
#log-rank is a chi-squared distribution which is U^2/V
#log_rank = U^2/V

#println(log_rank)


end
