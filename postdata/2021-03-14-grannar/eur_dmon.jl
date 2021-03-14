using Colors, CSV, DataFrames, PGFPlotsX
mmonth = CSV.File("data/estat_demo_mmonth.csv", missingstring=":") |> DataFrame
pop = CSV.File("data/estat_demo_pjan.csv", missingstring=":") |> DataFrame
pop = pop[(pop[:sex].=="T").&(pop[:age].=="TOTAL"), :]
pop_lo = stack(pop, 6:64)
mmonth_lo = stack(mmonth, 5:63)
mmonth_lo[:variable] = map(x->parse(Int, String(x)), mmonth_lo[:variable])
pop_lo[:variable] = map(x->parse(Int, String(x)), pop_lo[:variable])
pop_mmonth = join(pop_lo, mmonth_lo, on = [:geo, :variable], makeunique=true)
pop_mmonth[:rate] = pop_mmonth[:value_1]./pop_mmonth[:value]
swe_months = ["januari", "februari", "mars", "april", "maj", "juni", "juli",
    "augusti", "september", "oktober", "november", "december"]

function plot_geos_month(geos, month)
    monthlab = swe_months[parse(Int, month[2:end])]
    p = @pgf Axis({"yticklabel style"={}, ymin=0,
        "xticklabel style"={"font=\\tiny", "/pgf/number format/set thousands separator={}"},
        "yticklabel style"={"/pgf/number format/set thousands separator={}",
            "/pgf/number format/use comma"},
        "legend style"={"font=\\tiny"},
        legend_pos="south west", xlabel="år",  ylabel="döda/folkmängd",
        "xtick distance"=10,
        title="Döda $(monthlab)",
        xmajorgrids, ymajorgrids})
    plotcolors = distinguishable_colors(length(geos)+1, [RGB(1,1,1)])[2:end]
    for (i, geo) in enumerate(geos)
        plot_geo_month(geo, month, p, plotcolors[i])
    end
    p
end

function plot_geo_month(geo, month, p, plotcolor)
    pop_mmonth_sub = pop_mmonth[(pop_mmonth[:geo].==geo) .& (pop_mmonth[:month].==month), :]
    @pgf push!(p, PlotInc({"mark=x", color = plotcolor},
        Table([pop_mmonth_sub[:variable], pop_mmonth_sub[:rate]])),
        LegendEntry(geo))
end
