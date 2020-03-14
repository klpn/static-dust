#!/usr/bin/env julia
include("sirpgf.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
pgfsave("../../images/sir_r2_d5.svg", sirplot(2, 5, (0.0, 200.0)))
pgfsave("../../images/sir_r3_d7.svg", sirplot(3, 7, (0.0, 200.0)))
