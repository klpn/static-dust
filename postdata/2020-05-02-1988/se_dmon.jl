using Colors, CSV, DataFrames, PGFPlotsX
se_dmon = CSV.File("data/se_dmon1851_2019.tsv", delim="\t") |> DataFrame

function plotmonths(sex, months, syr, eyr)
    sax = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
              "xticklabel style"={"/pgf/number format/set thousands separator={}"},
              "yticklabel style"={"/pgf/number format/set thousands separator={}"},
              "legend style"={"font=\\tiny"},
              legend_pos="outer north east", ylabel="Döda",
              title = "Antal dödsfall per månad $(sex) Sverige",
              xmajorgrids, ymajorgrids})
    plotcolors = distinguishable_colors(length(months)+1, [RGB(1,1,1)])[2:end]
    for (i, month) in enumerate(months)
        plotmonth(sex, month, syr, eyr, sax, plotcolors[i])
    end
    sax                       
end

function plotmonth(sex, month, syr, eyr, p, plotcolor)
    se_dmon_sub = se_dmon[((se_dmon[:kön].==sex) .& (se_dmon[:månad].==month)
        .& (se_dmon[:år].>=syr) .& (se_dmon[:år].<=eyr)), :]
    @pgf push!(p, PlotInc({no_markers, color = plotcolor},
        Table([se_dmon_sub[:år], se_dmon_sub[:Döda]])),
        LegendEntry(month))
end