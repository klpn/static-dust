#!/usr/bin/env julia
include("secov_deaths_period.jl")
pgfsave("../../images/secov_dp_230223_f.svg", periodsexplot("f"))
pgfsave("../../images/secov_dp_230223_m.svg", periodsexplot("m"))
