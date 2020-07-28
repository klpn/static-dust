using CSV, DataFrames, PGFPlotsX

regions = CSV.File("regioner.csv") |> DataFrame

function sosframe(csvraw)
    csvform = tempname()
    if !(ispath(csvform))
        run(pipeline(`./sos.awk`, stdin=csvraw, stdout=csvform))
    end
    sos = CSV.File(csvform) |> DataFrame
    sos[:Kön] = map(lowercasefirst, sos[:Kön])
    sos[:Incidens] = sos[:Incidens]./10^5
    join(sos, regions, on=:Region)
end

function sexplot(sos, sex)
    sos_sex_sub = sos[sos[:Kön].==sex, :]
    p = @pgf Axis(
        {"xticklabel style"=
            {"/pgf/number format/set thousands separator={}"},
        "yticklabel style"=
            {"/pgf/number format/set thousands separator={}"},
        title = "Vårdtillfällen/invånare influensa $(sex) Sverige 65–",
        xlabel = "År", ylabel = "Incidens",
        xmajorgrids, ymajorgrids, ymode="log"})
    for rk in regions[:Kod]
        sos_regsex_sub = sos_sex_sub[sos_sex_sub[:Kod].==rk, :]
        @pgf push!(p,
            PlotInc({"only marks", "mark=text", "text mark"="$(rk)",
                "text mark as node",
                "text mark style={font=\\tiny}", color="black"},
                Table([sos_regsex_sub[:År], sos_regsex_sub[:Incidens]])))
    end
    p
end
