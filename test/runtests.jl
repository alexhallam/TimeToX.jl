# include("runtests.jl")
using Base.Test, DataFrames
include("../src/est_surv.jl")

# using whas100 dataset
whas100 = readtable("../datasets/whas100.csv")
times = whas100[:lenfol]
is_censored = whas100[:fstat]

# Is data read in correctly for tests
@test typeof(whas100) == DataFrames.DataFrame

# Is est_surv working
esf = est_surv(times,is_censored)

@testset "est_surv" begin
	
	# Is data output as DataFrame
	@test typeof(esf) == DataFrames.DataFrame 
	
	# is time sorted
	@test first(esf[:time]) == 6
	@test last(esf[:time]) == 2719
	
	# are the values at time 6 correct

	# are the values at time 98 correct

	# are the values at time 2719 correct
end
# Test KM estimator
#
