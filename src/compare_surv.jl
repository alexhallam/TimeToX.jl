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
=======

goodness of fit?

Example
========

using DataFrames
whas100 = readtable("datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
est_surv(times, is_censored);

"""

function compare_surv(
	times,
	is_consored,
	group
	)	
end
