include("est_surv.jl")
using DataFrames
whas100 = readtable("../datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
whas = est_surv(times, is_censored);


