#!/usr/bin/env julia
include("seir_var.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
pgfsave("../../images/seir_var_susp.svg",
    seir_var_susp(2.5, .2, .1, .25, 1e-5, 365, false) |> seirplot)
pgfsave("../../images/seir_var_k_r730.svg",
    seirset(2.5, .2, .1, -5:7, 1e-5, 730) |> seirset_rendsplot)

