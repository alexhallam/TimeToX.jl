"""
`compare_surv()`

Description
============

Compares two Survival Functions. Given two events, A and B, determines whether
the data generating processes are statistically different. The test-statistic
is chi-squared under the null hypothesis.

H_0: both time-to-event series are from the same generating processes
H_A: the time-to-event series are from different generating processes.

The method used to compare the time-to-event series is the log-rank test.


Usage
======

	compare_surv(time = whas[:time], is_censored = whas[:censored], group = some_group)

Arguments
=========

- **`time_A`** : The time to event 'A'.

- **`time_B`** : The time to event 'B'.

- **`is_censored_A`** : A vector of bools. 1 == censored and 0 == not censored

- **`is_censored_B`** : A vector of bools. 1 == censored and 0 == not censored

- **`alpha`** : The level of significance. Default is 0.95

- **`group`** : A vector of integers such as [0,1] or [1,2] to identify the two
groups being compared


Returns
=======

<<<<<<< HEAD
goodness of fit?
=======
The the result prints 'p_value', 'summary', 'test_statistic', 'test_result'
>>>>>>> c80a5cce65ca6c7149dc5eaa949c43c5386f16fc

Example
========

using DataFrames
whas100 = readtable("datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
compare_surv(times, is_censored, gender)

#small dataset
times = [6,7,10,15,19,25]
is_censored = [0,1,0,0,1,0,]
group = [1,1,0,1,0,0]
est = est_surv(times,is_censored)
compare_surv(times, is_censored, group)

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
#requres DataFrames and DataFramesMeta
# https://web.stanford.edu/~lutian/coursepdf/unitweek3.pdf
#event = [3.1,6.8,9,9,11.3,16.2,8.7,9,10.1,12.1,18.7,23.1]
#is_censored = [0,1,0,0,1,0,0,0,1,1,0,1]
#group = [0,0,0,0,0,0,1,1,1,1,1,1]
function compare_surv(
	times, is_censored, is_control
	)

	include("helpers/survival_table_from_events.jl")
	table = survival_table_from_events(times,is_censored,group)

	##log-rank test statistic
	#sum of control_failure - sum of expected_value
	U = sum(table[:control_failure]) - sum(table[:expected_value])
	#sum of varianec
	V = sum(table[:variance])
	#log-rank is a chi-squared distribution which is U^2/V
	log_rank = U^2/V

	if log_rank < 3.8416
		@printf "With a χ² value of %f the two group are not statistically significant at the α = 0.05 level" log_rank
	else
		@printf "With a χ² value of %f the two group are statistically significant at the α = 0.05 level" log_rank
	end

end
