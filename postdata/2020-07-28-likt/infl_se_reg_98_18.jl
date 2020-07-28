#!/usr/bin/env julia
include("sossltv.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
s = sosframe("Statistikdatabasen_2020-07-28 11 46 15.csv")
pgfsave("../../images/infl_se_reg_kv65_98_18.svg",
    sexplot(s, "kvinnor"))
pgfsave("../../images/infl_se_reg_m65_98_18.svg",
    sexplot(s, "män"))
