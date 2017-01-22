"""
`est_survf()`

Description
============

Estimates the Survival Function. Accepts tidy survival data and outputs a data frame of survival function estimates. It uses `time`, `is_censored`, and `methood`.

Usage
======

	est_survf(time = whas[:time], is_censored = whas[:censored])

Arguments
=========

- **`time`** : The length of time to event

- **`is_censored`** : A vector of bools. 1 == censored and 0 == not censored

- **`method`** : Method used to estimate the survival function. Default is KM. Options are `km` for Kapan-Meirer, ...

Returns
========
- **`time`**: sorted times

- **`nrisk`**: Number at risk at 

- **`nevent`**: Number of events

- **`ncensor`**: Number censored values 

- **`estimate`**: The estimate of the survival function. The probability of survival at that time point 

- **`stderror`**: The standard error of the estimate

- **`lower_conf`**: The upper confidence interval

- **`upper_conf`**: The lower confidence intercal

Example
========
	using DataFrames
	whas100 = readtable("datasets/whas100.csv");
	times = whas100[:lenfol];
	is_censored = whas100[:fstat];
	est_survf(times, is_censored);

"""

function est_survf(
	times,
	is_censored
		  )

	SurvivalData = DataFrame(time = times,is_censored = is_censored);
	SurvivalData = sort!(SurvivalData, cols = [:time]); 
	SurvivalData[:ncensor] = cumsum(SurvivalData[:is_censored]);
	SurvivalData 
end
