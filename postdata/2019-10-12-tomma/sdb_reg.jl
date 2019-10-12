using Colors, CSV, DataFrames, Loess, PGFPlotsX
sdbout = tempname()
regs = CSV.File("regioner.csv", delim=';') |> DataFrame |>
	df -> zip(df[:reg], df[:text]) |> Dict
ages = CSV.File("aldrar.csv", delim=';') |> DataFrame |>
	df -> zip(df[:age], df[:text]) |> Dict
sexes = Dict(1 => "män", 2 => "kvinnor")
cas = Dict(:circ => Dict(:text => "cirkulation", :expr => "I00-I99|F01"),
	:tum => Dict(:text => "tumör", :expr => "C00-D48"))

function propyrs_allreg(age, ca1, ca2)
	run(pipeline(`./propyrs_allreg.sh "[12]" "$(age)" "$(cas[ca1][:expr])" "$(cas[ca2][:expr])"`,
		stdout=sdbout))
	df = CSV.File(sdbout, header=[:year, :reg, :sex, :ca1n, :ca2n, :rat],
		delim=';') |> DataFrame
	Dict(:meta => Dict(:age => age, :ca1 => ca1, :ca2 => ca2), 
		:df => df)
end

propyr_regs_sex_df(inframe, year, sex) =
	sort(inframe[(inframe[:year].==year) .& (inframe[:sex].==sex), [:reg, :ca1n, :ca2n, :rat]],
		:rat)

function propyrs_reg_sex(indict, reg, sex)
	meta = copy(indict[:meta])
	meta[:reg] = reg
	meta[:sex] = sex
	Dict(:meta => meta, :df => propyrs_reg_sex_df(indict[:df], reg, sex))
end

function propyrs_reg_sex_df(inframe, reg, sex)
	df = inframe[(inframe[:reg].==reg) .& (inframe[:sex].==sex), [:year, :ca1n, :ca2n, :rat]]
	yearvec = Vector{Float64}(df[:year])
	ratvec = Vector{Float64}(df[:rat])
	lo = loess(yearvec, ratvec)
	df[:rat_lo] = predict(lo, yearvec)
	df
end

function propyrs_regs_sex_plot(indict, regs, sex)
	ca1lab = cas[indict[:meta][:ca1]][:text]
	ca2lab = cas[indict[:meta][:ca2]][:text]
	agelab = ages[indict[:meta][:age]]
	sexlab = sexes[sex]
	sax = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
                       "xticklabel style"={"/pgf/number format/set thousands separator={}"},
                       "legend style"={"font=\\tiny"},
                       legend_pos="outer north east", ylabel="$(ca1lab)/$(ca2lab)",
                       "xtick distance"=5, "ytick distance"=.2,
                       title="Antal dödsfall $(ca1lab)/$(ca2lab) $(sexlab) $(agelab) Sverige",
                       xmajorgrids, ymajorgrids})
	plotcolors = distinguishable_colors(length(regs)+1, [RGB(1,1,1)])[2:end]
	for (i, reg) in enumerate(regs)
		rd = propyrs_reg_sex(indict, reg, sex)
		propyrs_reg_plot(rd, sax, plotcolors[i])
	end
	sax
end

function propyrs_reg_plot(indict, p, plotcolor)
	inframe = indict[:df]
	@pgf push!(p, PlotInc({"only marks", mark_options = "solid", color = plotcolor},
		Table([inframe[:year], inframe[:rat]])),
		LegendEntry("$(regs[indict[:meta][:reg]])"),
		PlotInc({no_markers, color = plotcolor},
		Table([inframe[:year], inframe[:rat_lo]])),
		LegendEntry("loess"))
end