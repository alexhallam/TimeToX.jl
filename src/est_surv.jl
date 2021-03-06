"""
`est_surv()`

Description
============

Estimates the Survival Function. Accepts survival data and outputs a data frame
of survival function estimates. It uses `time`, `is_censored`, and `methood`.

Usage
======

	est_surv(time = whas[:time], is_censored = whas[:censored])

Arguments
=========

- **`time`** : The length of time to event

- **`is_censored`** : A vector of bools. 1 == censored and 0 == not censored

Returns
========
- **`time`**: Sorted timepoints

- **`nrisk`**: Number at risk at the given time

- **`nevent`**: The cumulative number of events that have occurred since the
last time listed

- **`ncensor`**: Number censored values. The cumulative number of subjects that
have left without an event since the last time listed.

- **`estimate`**: The estimate of the survival function at a given time. The
probability of survival at that time point

- **`stderror`**: The standard error of the estimate

- **`lower_conf`**: The upper confidence interval

- **`upper_conf`**: The lower confidence intercal

Example
========

	using DataFrames
	whas100 = readtable("datasets/whas100.csv");
	times = whas100[:lenfol];
	is_censored = whas100[:fstat];
	est_surv(times, is_censored)

"""

function est_surv(
	times,
	is_censored
		  )

	#convert dataframes cols to vectors for speed
	times = convert(Vector, times)
	is_censored = convert(Vector, is_censored)

	# sort unique times
	t = sort!(unique(times))

	# sum the number of times an event happens. if the event was censored it does not count as an event.
	nevent::Array{Int64,1} = [sum(is_censored[findin(times, i)]) for i in t]

	# as events happen the number at risk decreases. as j iterates through t all i greater than j are counted.
	nrisk::Array{Int64,1} = [count(i->(i>=j),times) for j in t]

	# for each unique time count the censored events
	ncensor::Array{Int64,1} = [count(i->(i==0), is_censored[findin(times, j)]) for j in t]

	# calculate the complement of the events over risk aka conditional probability of survival
	event_proportion::Array{Float64,1} = 1-(nevent./nrisk)

	# Kaplan-Meier estimator is the cumulative product of complement of the events over risk

	# Calculate the survival estimate `Kaplan`
	km::Array{Float64,1} = cumprod(event_proportion)

	# Greenwood estimate is ...
	delta::Array{Float64,1} = [nrisk[i]!=nevent[i]?nevent[i]/(nrisk[i]*(nrisk[i]-nevent[i])):0 for i = 1:length(nrisk)]

	# take cumsum of delta
	cumsum_delta::Array{Float64,1} = [sum(delta[1:i]) for i = 1:length(nrisk)]

	# log-log CI
	log_log_var::Array{Float64,1} = [1/(log(km[i])^2)*cumsum_delta[i] for i = 1:length(km)]
	log_log_sqrt::Array{Float64,1} = sqrt.(log_log_var)
	c_low::Array{Float64,1} = log.(-log.(km))-1.96*log_log_sqrt
	c_high::Array{Float64,1} = log.(-log.(km))+1.96*log_log_sqrt
	high::Array{Float64,1} = exp.(-exp.(c_low))
	low::Array{Float64,1} = exp.(-exp.(c_high))

	# Output DataFrame
	survivalOutput = DataFrame(
		time = t,
		nrisk = nrisk,
		nevent = nevent,
		ncensor = ncensor,
		estimate = km,
		lower_conf = low,
		upper_conf = high,
	   );

end
