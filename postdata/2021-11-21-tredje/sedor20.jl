using Colors, CSV, DataFrames, PGFPlotsX
deaths_raws = [normpath("data", "2020-11-7034-4A.csv"),
    normpath("data", "2021-3-7289-4A.csv"),
    normpath("data", "2021-11-7640-4A.csv")]
pop_raw = normpath("data", "BE0101A6_20201118-131030.txt")
pop_form = tempname()
run(pipeline(`iconv -f iso-8859-1 -t utf-8`, stdin=pop_raw,
    stdout=pipeline(`./sepop.awk`, pop_form)))

function load_deaths_frames(raws)
    dfs = []
    for f in raws
        deaths_form = tempname()
        run(pipeline(`./sedor20.awk`, stdin=f, stdout=deaths_form))
        df = CSV.File(deaths_form) |> DataFrame
        dfs = vcat(dfs, df)
    end
    dfs
end

deaths_frames = load_deaths_frames(deaths_raws)

df_dates = ["2020-01-01–2020-06-30", "2020-07-01–2020-12-31", "2021-01-01–2021-06-30"]

ages = DataFrame(age = collect(0:21),
    agest = [0;0;1;collect(5:5:95)],
    age2 =[0;1;fill(2,3);fill(3,6);fill(4,4);fill(5,2);fill(6,5)])
ages2 = combine(groupby(ages, :age2), df -> DataFrame(agest=minimum(df[:, :agest])))

pop = DataFrame()
pop1 = CSV.File(pop_form) |> DataFrame
ages1 = DataFrame(age1 = collect(0:101),
    age = [0;1;fill(2,4);map((x)->fld(x,5)+2, collect(5:94));fill(21,6)])
pop1_age = innerjoin(pop1, ages1, on = :age1)

function popsexadd(sex)
    pop1_sex = pop1_age[pop1_age[:, :sex].==sex, [:n, :age]]
    pop_sex = combine(groupby(pop1_sex, :age), df -> DataFrame(sex = sex, n = sum(df[:, :n])))
end

pop = vcat(popsexadd("Kv"), popsexadd("M"))

function regsub(regexpr, df)
    infile = tempname()
    CSV.write(infile, df)
    outfile = tempname()
    run(pipeline(`awk -v reg=$regexpr -f regsub.awk`, stdin=infile, stdout=outfile))
    CSV.File(outfile) |> DataFrame
end

function df_reg(sex, caexpr, ageaggr, deaths_frame)
    deaths = deaths_frames[deaths_frame]
    if caexpr == "pop"
        df_sub = pop[pop[:, :sex].==sex, [:age, :n]]
        sort!(df_sub, (:age))
    else
        df_sub = regsub(caexpr, deaths[deaths[:, :sex].==sex, [:icd10, :age, :n]])
    end
    df_aggr = combine(groupby(df_sub, :age), df -> DataFrame(n=sum(df[:, :n])))
    df_aggr_age = innerjoin(df_aggr, ages, on = :age)
    if ageaggr
	df_aggr_age2 = combine(groupby(df_aggr_age[:, [:n, :age2]], :age2), df -> DataFrame(n=sum(df[:, :n])))
        return innerjoin(df_aggr_age2, ages2, on = :age2)
    else
        return df_aggr_age
    end
end

function propframe(sex, ca1; ca2 = "A00-Y98", cax = "U07-U07", ageaggr = false, deaths_frame = 1)
    ca1frame = df_reg(sex, ca1, ageaggr, deaths_frame)
    ca2frame = df_reg(sex, ca2, ageaggr, deaths_frame)
    propframe = DataFrame(age = ca1frame[:, 1], agest = ca1frame[:, :agest],
        ca1n = ca1frame[:, :n],
        ca2n = ca2frame[:, :n],
        prop = ca1frame[:, :n] ./ ca2frame[:, :n],
    )
    if cax != ""
        caxframe = df_reg(sex, cax, ageaggr, deaths_frame)
        propframe[!, :caxn] = caxframe[:, :n] 
        propframe[!, :xprop] = ca1frame[:, :n] ./ (ca2frame[:, :n] .- caxframe[:, :n])
    end
    return Dict(:sex => sex, :ca1 => ca1, :ca2 => ca2, :cax => cax, :frame => propframe)
end

function cas_sexes_prop_plot(cas, denomca, cax = "", deaths_frame = 1, ymode = "linear")
    if cax == ""
        ylab = "döda/$(denomca[:label])"
    else
        ylab = "döda/($(denomca[:label])−$(cax[:label]))"
    end
    sax = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
        ymode = ymode, legend_pos="outer north east",
        title="Döda Sverige $(df_dates[deaths_frame])",
        xlabel="ålder", ylabel=ylab, xmajorgrids, ymajorgrids, yminorgrids, "minor tick num"=1})
    plotcolors = distinguishable_colors(length(cas)*2 + 1, [RGB(1,1,1)])[2:end]
    for (i, sex) in enumerate(["Kv", "M"])
        for (j, ca) in enumerate(cas)
            ca_sex_prop_plot(sax, ca, denomca, cax, sex, deaths_frame, plotcolors[i*j])
        end
    end
    sax
end

function ca_sex_prop_plot(sax, ca, denomca, cax, sex, deaths_frame, col)
    if cax == ""
        caxpr = ""
        plotcol = :prop
    else
        caxpr = cax[:caexpr]
        plotcol = :xprop
    end
    df = propframe(sex, ca[:caexpr], ca2 = denomca[:caexpr], cax = caxpr,
                   deaths_frame = deaths_frame)[:frame]
    @pgf push!(sax, PlotInc({color = col},
        Table([df[:, :agest][2:end], df[:, plotcol][2:end]])),
        LegendEntry("$(ca[:label]) $(lowercase(sex))"))
end
