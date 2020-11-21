#!/usr/bin/env julia
include("sedor20.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
cas = [Dict(:label => "tumör", :caexpr => "C00-D48"),
    Dict(:label => "COVID-19", :caexpr => "U07-U07"),
    Dict(:label => "cirkulation", :caexpr=>"I00-I99|F01")]
allca = Dict(:caexpr => "A00-Y98", :label => "alla orsaker")
popca = Dict(:caexpr => "pop", :label => "folkmängd")
pgfsave("../../images/se_cirk_cov_tum_prop_2020h1.svg",
    cas_sexes_prop_plot(cas, allca))
pgfsave("../../images/se_cirk_cov_tum_rate_2020h1.svg",
    cas_sexes_prop_plot(cas, popca, "log"))
