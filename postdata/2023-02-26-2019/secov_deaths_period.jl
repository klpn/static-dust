using Colors, CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}", raw"\usepackage{unicode-math}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}", raw"\setmathfont{Asana-Math}")
secov_deaths_period = CSV.File("data/secov_deaths_period_230223.tsv") |> DataFrame
mpop = CSV.File("data/mpop22.tsv") |> DataFrame
startages = union(secov_deaths_period[!,:startage])
mpop[!,:startage] = map(a -> maximum(filter(sa -> sa<=a, startages)), mpop[!, :age])
mpop_g = combine(groupby(mpop, [:sex, :startage]), :mpop => sum => :mpop)
secov_dp_p = innerjoin(secov_deaths_period, mpop_g, on = [:sex, :startage])
secov_dp_p[!, :rate] = secov_dp_p[!, :deaths] ./ secov_dp_p[!, :mpop]

function agelab(i)
    if i < size(startages)[1]
        return "$(startages[i])–$(startages[i+1]-1)"
    else
        return "$(startages[i])–ω"
    end
end

sexlabs = Dict("f" => "kvinnor", "m" => "män")

function periodsexplot(s)
    sexf = secov_dp_p[secov_dp_p[!,:sex].==s, :]
    p = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
       "xticklabel style"={"/pgf/number format/set thousands separator={}"},
       legend_pos="outer north east",
       title="Dödstal covid-19 $(sexlabs[s]) Sverige",
       xlabel = "period", ylabel="döda/folkmängd", ymode = "log",
       xmajorgrids, ymajorgrids})
    plotcolors = distinguishable_colors(size(startages)[1]+1, [RGB(1,1,1)])[2:end]
    for (i, c) in enumerate(startages)
        sexagef = sexf[sexf[!,:startage].==startages[i], :]
        @pgf push!(p, PlotInc({no_markers, color = plotcolors[i]},
                              Table([sexagef[!, :period], sexagef[!, :rate]])),
                   LegendEntry(agelab(i)))
    end
    p
end
