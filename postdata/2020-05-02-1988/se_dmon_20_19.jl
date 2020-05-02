#!/usr/bin/env julia
include("se_dmon.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
flumonths = ["oktober", "november", "december", "januari",
   "februari", "mars", "april"]
pgfsave("../../images/se_dmon_20_19_kv.svg",
   plotmonths("kvinnor", flumonths, 1920, 2019))
pgfsave("../../images/se_dmon_20_19_m.svg",
   plotmonths("män", flumonths, 1920, 2019))
