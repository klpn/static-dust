#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
it_covid19_pop = CSV.File("data/it_covid19_pop.csv") |> DataFrame
plotdicts = [
    Dict(:num => :CasesFemale, :den => :PopFemale, :lab => "incidens kvinnor"),
    Dict(:num => :CasesMale, :den => :PopMale, :lab => "incidens män"),
    Dict(:num => :DeathsFemale, :den => :PopFemale, :lab => "mortalitet kvinnor"),
    Dict(:num => :DeathsMale, :den => :PopMale, :lab => "mortalitet män")
]
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
p = @pgf Axis({ymode="log", xlabel="Ålder", title="COVID-19 Italien till 2020-03-19",
        legend_pos="outer north east", xmajorgrids, ymajorgrids, yminorgrids})
ages = it_covid19_pop[:AgeGrp10Start]
for pd in plotdicts
    rate = it_covid19_pop[pd[:num]] ./ it_covid19_pop[pd[:den]]
    @pgf push!(p, PlotInc(Table([ages, rate])), LegendEntry(pd[:lab]))
end
pgfsave("../../images/it_covid19.svg", p)

