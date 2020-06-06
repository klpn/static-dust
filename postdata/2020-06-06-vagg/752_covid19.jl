#!/usr/bin/env julia
using Covid19Inc, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
p0531 = Covid19Inc.covid_pop(752, :i40i10o90, "2020-05-31") |> Covid19Inc.covidpl
p0601 = Covid19Inc.covid_pop(752, :i50i10i70i5o90, "2020-06-01") |> Covid19Inc.covidpl
pgfsave("../../images/752_covid19_2020-05-31.svg", p0531)
pgfsave("../../images/752_covid19_2020-06-01.svg", p0601)
