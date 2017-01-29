"""
`describe_time_to_x()`

Description
============

Provides discritive statistics on the time-to-event function. 
This function is used when a dataframe of values has alread been collected with **est_surv()**. 

Usage
======

	describe_time_to_x

Arguments
=========

- **`x`** : The data frame returned from est_surv

- **`probs`** : Probabilities at which to calculate quantiles.
The default option is a vector [.25, .5, .75] which calculates the 25th, 50th, and 75th
percentiles.

- **`tol`** : Tolerance. to add at a later date.

Returns
========

- **`quantile`**:   

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

	event_quantile()


TODO
====

- Add a function to find quantiles in a CDF curve. Once in a while the 
survival curve has a flat spot exactly at the requested quantile. Then we 
use the median of the flat line.

- Add tolerance argument to event_quantile function
"""

function event_quantile(probs = [.25 , .5, .75])
	# Check that values are valid probabilities (between 0 and 1) and not NA
	# throw error is probs are not valid

	# add variables for length of probability vector and the nth quantile
	nprobs = length(probs);
	pname = probs*100;

	# If prob = 0 report start time else 0
	# Todo
	
	nth_percentile = pname;
	quantile_estimate = zeros(nprobs);
	quantile_lower_conf = zeros(nprobs);
	quantile_upper_conf  = zeros(nprobs);

	# Output is a data frame
	quantileOutput = DataFrame(
		nth_percentile = nth_percentile,
		quantile_estimate = quantile_estimate,
		quantile_lower_conf = quantile_lower_conf,  
		quantile_upper_conf = quantile_upper_conf,  
							 )
end





