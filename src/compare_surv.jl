"""
`compare_surv()`

Description
============

Compares two Survival Functions. Accepts survival data and outputs significance.
It uses `time`, `is_censored`, and `group`. The method used to compare survivals
is the log-rank function.

Usage
======

	compare_surv(time = whas[:time], is_censored = whas[:censored], group = some_group)

Arguments
=========

- **`time`** : The length of time to event

- **`is_censored`** : A vector of bools. 1 == censored and 0 == not censored

- **`group`** : A vector of integers such as 0/1 or 1/2 to identify the two groups
being compared


Returns
========

values

Example
========

using DataFrames
whas100 = readtable("datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
est_surv(times, is_censored);

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

function compare_surv(
	times,
	is_consored,
	group
	)
 t = sort!(unique(times))

 # sum the number of times an event happens. if the event was censored it does not count as an event.

 #nrisk = [count(i->(i>=j),times) for j in t]

 # for each unique time count the censored events
 #ncensor = [count(i->(i==0), is_censored[findin(times, j)]) for j in t]

 # calculate the complement of the events over risk aka conditional probability of survival
 #event_proportion = 1-(nevent./nrisk)

#1. output time correctly
#2. find a way to do the log rank test
#3. Is this appropriate for a dataframe or should significance be output
 compare_output = DataFrame(
	 time = time,
	 #d1i = d1i,
	# n1i = n1i,
	 #di = ncensor,
	 #ni = km,
	 #e1i = low,
	 #v1i = high,
	# L = log_rank,
	# P = Peto-Prentice
		);
end
