#!/usr/bin/env julia
include("se_dseason.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
pgfsave("../../images/se_dseason_81_19_kv.svg", plot_seasontypes("women", 1981, 2019))
pgfsave("../../images/se_dseason_81_19_m.svg", plot_seasontypes("men", 1981, 2019))
