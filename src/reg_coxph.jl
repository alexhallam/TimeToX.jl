"""
`reg_coxph()`

Description
============


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
=======

The following data is from Kalbfleisch and Prentice 1980. 
using JuMP, Ipopt
times = [6,7,10,15,19,25];
is_censored = 1-[1,0,1,1,0,1];
is_control = 1-[1,1,0,1,0,0];
julia> reg_coxph(times,is_control, is_censored)
times = [6, 7, 10, 15, 19, 25]
is_censored = [0, 0, 1, 0, 1, 1]
is_control = [0, 1, 0, 0, 1, 0]
β = -0.0988607452890646
"""
function reg_coxph(times::Array{Float64,1}, 
		   is_censored::Array{Int64,1}, 
		   is_control::Array{Int64,1})
	
	# where the is_censored vector is equal to 0
	uncensored = find(is_censored .== 0)
	#println("times = $times")
	#println("is_censored = $is_censored")
	#println("is_control = $is_control")

	# Define model with IpoptSolver for nonlinear model
	m = Model(solver=IpoptSolver(print_level=0))

	# Start beta to start at 0.0
	@variable(m, β, start = 0.0)

	# Optimize the score function of the cox proportional hazard
	@NLobjective(m, Max, sum(log(1+(-1)^is_control[uncensored[i]]*
	sum((-1)^is_control[j]*exp(is_control[j]*β) for j=uncensored[i]:length(times))/
	sum( exp(is_control[j]*β) for j=uncensored[i]:length(times))) for i=1:length(uncensored)))

	solve(m)
	println("β = ", getvalue(β))
end

