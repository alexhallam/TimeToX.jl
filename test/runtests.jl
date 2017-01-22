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

@testset "km method" begin
	
	# Is data output as DataFrame
	@test typeof(esf) == DataFrames.DataFrame 

	# Is data the correct size
	@test size(esf) == (95,8)
	
	# is time sorted
	@test first(esf[:time]) == 6
	@test last(esf[:time]) == 2719
	
	# are the values at first time correct
	@test first(esf[:time]) == 6
	@test first(esf[:nrisk]) == 100
	@test first(esf[:nevent]) == 2 
	@test first(esf[:ncensor]) == 0
	@test isapprox(first(esf[:estimate]), .98, rtol = .1)
	@test isapprox(first(esf[:stderror]), .014, rtol = .1)
	@test isapprox(first(esf[:upper_conf]), 1.00, rtol = .1)
	@test isapprox(first(esf[:lower_conf]), .952, rtol = .1)

	# are the values at last time correct
	@test last(esf[:time]) == 2719 
	@test last(esf[:nrisk]) == 1
	@test last(esf[:nevent]) == 0
	@test last(esf[:ncensor]) == 1
	@test isapprox(last(esf[:estimate]), .18, rtol = .1)
	@test isapprox(last(esf[:stderror]), .746, rtol = .1)
	@test isapprox(first(esf[:upper_conf]), .778, rtol = .1)
	@test isapprox(first(esf[:lower_conf]), .042, rtol = .1)

end
# Test KM estimator
#
