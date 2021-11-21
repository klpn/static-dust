#!/usr/bin/env julia
include("sedor20.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
tum_cirk_cas = [Dict(:label => "tumör", :caexpr => "C00-D48"),
    Dict(:label => "cirkulation", :caexpr=>"I00-I99|F01")]
cov_ihd_cas =  [Dict(:label => "COVID-19", :caexpr => "U07-U07"),
    Dict(:label => "IHD", :caexpr=>"I20-I25")]
allca = Dict(:caexpr => "A00-Y98", :label => "alla orsaker")
covihdpl = "se_cov_ihd_prop_2021h1"
covihdpl_path = "../../images/$(covihdpl).svg"
covihd20pl = "se_cov_ihd_prop_2020h1"
covihd20pl_path = "../../images/$(covihd20pl).svg"
tumcirkxpl = "se_cov_tum_cirk_xprop_2021h1"
tumcirkxpl_path = "../../images/$(tumcirkxpl).svg"
pgfsave(covihdpl_path, cas_sexes_prop_plot(cov_ihd_cas, allca, "", 3))
print(*("![Andel dödsfall COVID-19 och IHD Sverige första halvåret 2021.]",
    "($(covihdpl_path)){#fig:$(covihdpl) width=100%}\n\n"))
pgfsave(covihd20pl_path, cas_sexes_prop_plot(cov_ihd_cas, allca, "", 1))
print(*("![Andel dödsfall COVID-19 och IHD Sverige första halvåret 2020.]",
    "($(covihd20pl_path)){#fig:$(covihd20pl) width=100%}\n\n"))
pgfsave(tumcirkxpl_path, cas_sexes_prop_plot(tum_cirk_cas, allca, cov_ihd_cas[1], 3))
print(*("![Andel icke COVID-19 dödsfall tumör och cirkulation Sverige första halvåret 2021.]",
    "($(tumcirkxpl_path)){#fig:$(tumcirkxpl) width=100%}\n\n"))
