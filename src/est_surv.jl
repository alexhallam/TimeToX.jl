"""
`est_surv()`

Description
============

Estimates the Survival Function. Accepts survival data and outputs a data frame of survival function estimates. It uses `time`, `is_censored`, and `methood`.

Usage
======

	est_surv(time = whas[:time], is_censored = whas[:censored])

Arguments
=========

- **`time`** : The length of time to event

- **`is_censored`** : A vector of bools. 1 == censored and 0 == not censored

- **`method`** : Method used to estimate the survival function. Default is KM. Options are `km` for Kapan-Meirer, ...

Returns
========
- **`time`**: Sorted timepoints 

- **`nrisk`**: Number at risk at the given time 

- **`nevent`**: The cumulative number of events that have occurred since the last time listed

- **`ncensor`**: Number censored values. The cumulative number of subjects that have left without an event since the last time listed.  

- **`estimate`**: The estimate of the survival function at a given time. The probability of survival at that time point 

- **`stderror`**: The standard error of the estimate

- **`lower_conf`**: The upper confidence interval

- **`upper_conf`**: The lower confidence intercal

Example
========
	using DataFrames
	whas100 = readtable("datasets/whas100.csv");
	times = whas100[:lenfol];
	is_censored = whas100[:fstat];
	est_surv(times, is_censored);

"""

function est_surv(
	times,
	is_censored
		  )

	t = sort!(unique(times));
	nevent = [count(j ->(j .== i ),times) for i in t]
	nrisk = zeros(length(t));
	# Kaplan-Meier estimator is the cumulative product of (nrisk - ndeaths)/ndeaths
	nd = 1-(nevent./nrisk);
	km = cumprod(nd)
	
	ncensor = zeros(length(t));
	#nevent = zeros(length(t));
	nevent = [count(i->(i>=j),times) for j in t]
	stderror = zeros(length(t));
	lower_conf = zeros(length(t));
	upper_conf = zeros(length(t));

	survivalOutput = DataFrame(
		time = t, 
		nrisk = nrisk, 
		nevent = nevent,
		ncensor = ncensor, 
		estimate = km, 
		stderror = stderror,
		lower_conf = lower_conf,
		upper_conf = upper_conf);
	#survivalOutput

end
