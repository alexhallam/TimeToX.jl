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
=======

The following data is from Kalbfleisch and Prentice 1980. 
using DataFrames, DataFramesMeta, JuMP, Ipopt
#time to event
times = [143,164,188,189,190,192,206,209,213,216,220,227,230,234,246,265,304,216,244,
142,156,163,198,205,232,232,233,233,233,233,239,240,261,280,280,296,296,232,204,344];

#make censored data
is_censored = zeros(Int32, 40);
is_censored[18]=1
is_censored[19]=1
is_censored[39]=1
is_censored[40]=1

#treatment vs control
x1=ones(Int32,19)
x2=zeros(Int32,21)
x=append!(x1,x2)

#build DataFrame
times = [6,7,10,15,19,25]
is_censored = [1,0,1,1,0,1]
x= is_control = [1,1,0,1,0,0]

m = Model(solver=IpoptSolver(print_level=0))
using DataFrames

df = DataFrame();
df[:times]=times;
df[:is_censored]= is_censored;
df[:x]=x;
df

#sort df
df_sorted = sort!(df, cols = [order(:times)])

#make df_risk and df_uncensored
df_uncensored = @where(df_sorted, :is_censored .== 0)
df_risk = df_sorted

#cox partial likelihood



#use JuMP

##convert df to array

uncensored = convert(Array,df_uncensored[:x])
risk_set = convert(Array,df_risk[:x])
risk_index = convert(Array,find(is_censored .== 0))
x = convert(Array, x)
@variable(m, β, start = 0.0)

# log-likelihood
@NLobjective(m, Max, sum(uncensored[i]*β-log(sum(exp(risk_set[j]*β) for j=risk_index[i]:length(risk_set))) for i=1:length(uncensored)))

# score
@NLobjective(m, Max, sum(uncensored[i] - ((sum(exp(risk_set[j]*β)*x[j]))/(sum(exp(risk_set[j]*β)*x[j]))) for j=risk_index[i]:length(risk_set)) for i = 1:length(uncensored)))


solve(m)

println("β = ", getvalue(β))




