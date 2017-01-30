# Est Surv set up
include("est_surv.jl")
using DataFrames
whas100 = readtable("../datasets/whas100.csv");
times = whas100[:lenfol];
is_censored = whas100[:fstat];
whas = est_surv(times, is_censored);

# iai
# include("describe_surv.jl")
using DataFramesMeta
ia = readtable("../datasets/iai.txt", separator = '\t')
times = ia[:days];
is_censored = ia[:delcensor];

# Subset data
ia_inf5_1 = @where(ia, :inf5 .== 1)
ia_inf5_2 = @where(ia, :inf5 .== 2)

# fit a km survival function
ia_surv = est_surv(times, is_censored)

