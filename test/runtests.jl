# include("runtests.jl")
using Base.Test, DataFrames, DataFramesMeta
include("../src/est_surv.jl")


@testset "km method" begin

	@testset "whas100" begin

		# Test km method with whas100 dataset
		whas100 = readtable("../datasets/whas100.csv")
		times = whas100[:lenfol]
		is_censored = whas100[:fstat]

		# Is data read in correctly for tests
		@test typeof(whas100) == DataFrames.DataFrame

		# Save esf variable to test est_surv 
		esf = est_surv(times,is_censored)

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

	@testset "iai" begin

		# Test km method with iai (Intra-Amniotic Inflammation) dataset
		ia = readtable("../datasets/iai.txt", separator = '\t')
		times = ia[:days]
		is_censored = ia[:delcensor]

		# Is data read in correctly for tests
		@test typeof(ia) == DataFrames.DataFrame

		# Save esf variable to test est_surv 
		esf = est_surv(times,is_censored)

		# Is data output as DataFrame
		@test typeof(esf) == DataFrames.DataFrame 
#####
		# Is data the correct size
		@test size(esf) == (305,5)
		
		# is time sorted
		@test first(esf[:time]) == 0.0
		@test last(esf[:time]) == 114.0
		
		# are the values at first time correct
		@test first(esf[:time]) == 0.0
		@test first(esf[:nrisk]) == 305
		@test first(esf[:nevent]) == 1
		@test first(esf[:ncensor]) == 0
		@test isapprox(first(esf[:estimate]), .996, rtol = .1)
		@test isapprox(first(esf[:stderror]), .003, rtol = .1)
		@test isapprox(first(esf[:upper_conf]), 1.00, rtol = .1)
		@test isapprox(first(esf[:lower_conf]), .990, rtol = .1)

		# are the values at last time correct
		@test last(esf[:time]) == 114.0
		@test last(esf[:nrisk]) == 1
		@test last(esf[:nevent]) == 1
		@test last(esf[:ncensor]) == 0
		@test isapprox(last(esf[:estimate]), 0.0, rtol = .1)
		@test isapprox(last(esf[:stderror]), Inf, rtol = .1)
		@test isapprox(first(esf[:upper_conf]), NaN, rtol = .1)
		@test isapprox(first(esf[:lower_conf]), NaN, rtol = .1)
	end
end
# Test KM estimator
#
