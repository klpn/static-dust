#!/usr/bin/env julia
using Covid19Inc, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
p = Covid19Inc.covid_pop(752, :i10o90, "2020-04-25") |> Covid19Inc.covidpl
pgfsave("../../images/752_covid19_2020-04-25.svg", p)
