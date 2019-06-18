#!/usr/bin/env julia
include("gbd17riskpred.jl")
ihd17sex(2) |> pafrate_ols |> poplot
savefig("../../images/ihd_2017_5069_gbdpaf_kv.svg")
ihd17sex(1) |> pafrate_ols |> poplot
savefig("../../images/ihd_2017_5069_gbdpaf_m.svg")