# include("runtests.jl")
using Base.Test, DataFrames, DataFramesMeta
include("../src/est_surv.jl")
include("../src/describe_surv.jl")


@testset "functions " begin

	@testset "km_whas100" begin

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
#		@test size(esf) == (95,8)

		# is time sorted
		@test first(esf[:time]) == 6
		@test last(esf[:time]) == 2719

		# are the values at first time correct
		@test first(esf[:time]) == 6
		@test first(esf[:nrisk]) == 100
		@test first(esf[:nevent]) == 2
		@test first(esf[:ncensor]) == 0
		#Replace with log-log ranges
		@test isapprox(first(esf[:estimate]), .98, rtol = 1e-2)
		@test isapprox(first(esf[:low]), .922, rtol = 1e-2)
		@test isapprox(first(esf[:high]), .994, rtol = 1e-2)

		# are the values at last time correct
		@test last(esf[:time]) == 2719
		@test last(esf[:nrisk]) == 1
		@test last(esf[:nevent]) == 0
		@test last(esf[:ncensor]) == 1
		#log-log ranges
		@test isapprox(last(esf[:estimate]), 0.180, rtol = 1e-2)
		@test isapprox(last(esf[:low]), 0.199, rtol = 1e-2)
		@test isapprox(last(esf[:high]), 0.524, rtol = 1e-2)
	end

	@testset "km_iai" begin

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

		# Is data the correct size
#		@test size(esf) == (160,8)

		# is time sorted
		@test first(esf[:time]) == 0.0
		@test last(esf[:time]) == 114.0

		# are the values at first time correct
		@test first(esf[:time]) == 0.0
		@test first(esf[:nrisk]) == 305
		@test first(esf[:nevent]) == 1
		@test first(esf[:ncensor]) == 0
		@test isapprox(first(esf[:estimate]), 0.996, rtol = 1e-2)
		#log-log ranges
		@test isapprox(first(esf[:stderror]), 0.003, rtol = 1e-2)
		@test isapprox(first(esf[:upper_conf]), 0.999, rtol = 1e-2)
		@test isapprox(first(esf[:lower_conf]), 0.976, rtol = 1e-2)

		# are the values at last time correct
		@test last(esf[:time]) == 114.0
		@test last(esf[:nrisk]) == 1
		@test last(esf[:nevent]) == 1
		@test last(esf[:ncensor]) == 0
		@test isapprox(last(esf[:estimate]), 0.0, rtol = 1e-2)
		#log-log ranges
		@test isinf(last(esf[:stderror]))
		@test isnan(last(esf[:upper_conf]))
		@test isnan(last(esf[:lower_conf]))
	end

	@testset "quantiles" begin

		# Set up data
		whas100 = readtable("../datasets/whas100.csv")
		times = whas100[:lenfol]
		is_censored = whas100[:fstat]
		esf = est_surv(times,is_censored)
		quantile_df = event_quantile(esf)

		@test quantile_df[:quantile_estimate] == [2710, 2201, 656]
	end
end
