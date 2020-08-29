#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
csvform = tempname()
run(pipeline(`./yyg_se_0804.sh`, stdout=csvform))
yyg_se_0804 = CSV.File(csvform) |> DataFrame
pds = [
    Dict(:c => :predicted_deaths_mean, :lab => "Medel",),
    Dict(:c => :predicted_deaths_lower, :lab => "2,5 percentil",),
    Dict(:c => :predicted_deaths_upper, :lab => "97,5 percentil",)]
p = @pgf Axis({title = "Döda Sverige 2020-08-04 YYG",
    date_coordinates_in = "x",
    x_tick_label_style = "{rotate=90}",
    y_tick_label_style = {"/pgf/number format/use comma"},
    xlabel = "Prediktionsdatum", ylabel = "Kumulativt antal döda",
    xmajorgrids, ymajorgrids})
for pd in pds
    @pgf push!(p, PlotInc({no_markers}, Table([yyg_se_0804[:date], yyg_se_0804[pd[:c]]])),
        LegendEntry(pd[:lab]))
end
pgfsave("../../images/yyg_se_0804.svg", p)
