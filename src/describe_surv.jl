"""

`describe_surv`

Description
============

Provides quantile discritive statistics on the time-to-event function.
This function is used when a dataframe of values has alread been collected with **est_surv()**.
quantiles also need to be supplied.

Usage
======

	describe_surv(dataframe; prob = [.5])

Arguments
=========

- **`dataframe`** : The data frame returned from est_surv

- **`probs`** : Probabilities at which to calculate quantiles.
The default option is a vector [.25, .5, .75] which calculates the 25th, 50th, and 75th
percentiles.

- **`tol`** : Tolerance. to add at a later date.

Returns
========

The values returned are a data frame of the following values.

- **`nth_quantile`** : 25th, 50th, 75th quantile.

- **`quantile_estimate`**: The calculated quantile. Since the function
used to calculate quantiles is a step function some technical details
make this function slightly different from the `quantile` function
in Base Julia.

- **`quantile_upper_conf`**: The upper 95% confidence interval

- **`quantile_lower_conf`**: The lower 95% confidence interval

Details on quantiles of the time-to-event step function
--------------------------------------------------------

The kth quantile for a survival curve S(t) is the location at which
a horizontal line at height percentile = 1-k intersects the plot of S(t),
the event function.

Since S(t) is a step function, it is possible for the curve to have a
horizontal segment at exactly 1-k, in which case the midpoint of the
horizontal segment is returned.  This mirrors the standard behavior of
the median when data is uncensored.  If the survival curve does not
fall to 1-k, then that quantile is undefined. In practice this may be
seen when, for example, the first 25th percentile or last 75th percentile
values are all censored.

In order to be consistent with other quantile functions, the argument
of this function applies to the cumulative distribution
function F(t) = 1-S(t).

Confidence limits for the values are based on the intersection of the
horizontal line at 1-k with the upper and lower limits for the
survival curve.  Hence confidence limits use the same
p-value as was in effect when the curve was created, and will differ
depending on the confidence interval type option of est_surv.
If the survival curves have no confidence bands, confidence limits for
the quantiles are not available.

Since the survival curve is computed as a series
of products, however, there may be round off error.
Assume for instance a sample of size 20 with no tied times and no
censoring.  The survival curve after the 10th death is
(19/20)(18/19)(17/18) ... (10/11) = 10/20, but the computed result will
not be exactly 0.5. Any horizontal segment whose absolute difference
with a requested percentile is less than *tolerance* is
considered to be an exact match.


Example
========

	using DataFrames
	whas100 = readtable("../datasets/whas100.csv");
	times = whas100[:lenfol];
	is_censored = whas100[:fstat];
	whas_surv = est_surv(times, is_censored);
	describe_surv(whas_surv)


TODO
====

- Add a function to find quantiles in a CDF curve. Once in a while the
survival curve has a flat spot exactly at the requested quantile. Then we
use the median of the flat line.

- Add tolerance argument to event_quantile function

- Add midpoint to break ties.
"""

function describe_surv(dataframe, probs = [.25, .5, .75])
	# Check that values are valid probabilities (between 0 and 1) and not NA
	# throw error is probs are not valid
	estimate = dataframe[:estimate]
	time = dataframe[:time]

	# add variables for length of probability vector and the nth quantile
  #	nprobs = length(probs);
	pname = trunc(Int, probs*100);

	# If prob = 0 report start time else 0
	# Todo

#	nth_percentile = pname;

	# get first time that is equal to or less than each probability
	quantile_survival = [estimate[findfirst(survival -> survival <= i, estimate)] for i in probs]
	quantile_time = [time[findfirst(survival -> survival <= i, estimate)] for i in probs]

	# does estimate[quantile_estimate_first[i][1]] = estimate[quantile_estimate_first[i][2]]
	#estimate[quantile_estimate_first[1][1]] == estimate[quantile_estimate_first[1][2]]

#	quantile_lower_conf = zeros(nprobs);
#	quantile_upper_conf  = zeros(nprobs);

	# Output is a data frame
	quantileOutput = DataFrame(
		nth_quantile = pname,
		quantile_survival = quantile_survival,
		quantile_time = quantile_time,
		#quantile_estimate_first = quantile_estimate_first,
		#quantile_estimate_last = quantile_estimate_last,
					 )

end
