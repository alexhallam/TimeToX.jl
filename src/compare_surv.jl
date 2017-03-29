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
========

The the result prints 'p_value', 'summary', 'test_statistic', 'test_result'

Example
========

using DataFrames
whas100 = readtable("datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
est_surv(times, is_censored);

#small dataset
times = [6,7,10,15,19,25]
is_censored = [0,1,0,0,1,0,]
group = [1,1,0,1,0,0]
est = est_surv(times,is_censored)
compare_surv = (times, is_censored, group)

Description of Variables Used In Code
======================================

		| Event/Group   | 1          | 0         | Total    |
		| ------------- | ---------- | --------- | -------- |
		| Die           | d1i        | d0i       | di       |
		| Not Die       | n1i - d1i  | n0i - d0i | ni-di    |
		| At Risk       | n1i        | n0i       | ni       |

		n0i = number at risk at time i in group 0
		n1i = number at risk at time i in group 1
		d0i = number of deaths at time i in group 0
		d1i = number of deaths at time i in group 1
		ni = total number at risk at time i
		di = total number of deaths at time i

"""

# https://web.stanford.edu/~lutian/coursepdf/unitweek3.pdf
event = [3.1,6.8,9,9,11.3,16.2,8.7,9,10.1,12.1,18.7,23.1]
is_censored = [0,1,0,0,1,0,0,0,1,1,0,1]
group = [0,0,0,0,0,0,1,1,1,1,1,1]
function compare_surv(
	event, is_censored, group
	)

	df = DataFrame(event = event, is_censored = is_censored, group = group)

end

df = compare_surv(event,is_censored,group)
