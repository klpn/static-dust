using Colors, CSV, DataFrames, Dates, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usetikzlibrary{plotmarks}")
inf_eur_8108_se = CSV.File("data/inf_eur_8108_se.csv") |> DataFrame
sexes = Dict("women"=>"kvinnor", "men"=>"män")
seasontypes = ["H1", "H3", "H1+H3", "B", "H1+B", "H3+B", "H1+H3+B"]

function fluseason(m, y)
    if ((m=="Unknown") || month(Date(m, dateformat"U")) > 6)
       return y
    else
       return y-1
    end
end

function se_dmon_df(path)
    df = CSV.File(path, delim="\t") |> DataFrame
    df[:season] = map(fluseason, df[:month], df[:year])
    join(df, inf_eur_8108_se, on = :season)
end

se_dmon = se_dmon_df("data/se_dmon1851_2019_en.tsv")

function plot_seasontypes(sex, syr, eyr)
    sax = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
              "xticklabel style"={"/pgf/number format/set thousands separator={}"},
              "yticklabel style"={"/pgf/number format/set thousands separator={}"},
              "legend style"={"font=\\tiny"},
              legend_pos="outer north east", xlabel="Säsong", ylabel="Döda månad",
              title = "Antal dödsfall per månad $(sexes[sex]) Sverige",
              xmajorgrids, ymajorgrids})
    plotcolors = distinguishable_colors(length(seasontypes)+1, [RGB(1,1,1)])[2:end]
    for i in 1:length(seasontypes)
        @pgf push!(sax, "\\definecolor{col$(i)}{HTML}{$(hex(plotcolors[i]))}",
            "\\addlegendimage{only marks,col$(i),mark=x}")
    end
    for i in 1:length(seasontypes)
        plot_seasontype(sex, i, syr, eyr, sax, plotcolors[i])
    end
    sax                       
end

function plot_seasontype(sex, seasontype, syr, eyr, p, plotcolor)
    @pgf push!(p, LegendEntry(seasontypes[seasontype]))
    for m in 1:12
        se_dmon_sub = se_dmon[((se_dmon[:sex].==sex) .& (se_dmon[:month].==monthname(m)) 
            .& (se_dmon[:seasontype].==seasontype)
            .& (se_dmon[:season].>=syr) .& (se_dmon[:season].<=eyr)), :]
        @pgf push!(p, PlotInc({"only marks", "mark=text", "text mark"="$(m)", "text mark as node",
            "text mark style={font=\\tiny}", color=plotcolor},
            Table([se_dmon_sub[:season], se_dmon_sub[:Deaths]])))       
    end
end
