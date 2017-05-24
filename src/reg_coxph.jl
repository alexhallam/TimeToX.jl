"""
`reg_coxph()`

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

	reg_coxph(formula = event ~ age + bmi, dataset = whas100 )

Arguments
=========

- **`formula`** : The formula being used for regression 
- **`dataset`** : The dataset being used for regression 

Returns
=======

Example
========
