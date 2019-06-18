using GLM, CSV, DataFrames, PyCall, PyPlot
PyDict(matplotlib."rcParams")["axes.formatter.use_locale"] = true
ihd17r = CSV.File("data/IHME-GBD_2017_DATA-f3f91654-1.csv") |> DataFrame
ihd17paf = CSV.File("data/IHME-GBD_2017_DATA-cba77f73-1.csv") |> DataFrame
gbd17iso3166_ctries = CSV.File("data/gbd17iso3166_ctries.csv") |> DataFrame
ihd17r[:lrate] = log.(ihd17r[:val] ./ 10^5)
ihd17paf[:lnegpaf] = log.(1 .- ihd17paf[:val])
sexes = ["män", "kvinnor"]

function ihd17sex(s)
	r_sex = ihd17r[ihd17r[:sex].==s, :]
	paf_sex = ihd17paf[ihd17paf[:sex].==s, :]
	r_sex_sub = DataFrame(location = r_sex[:location], lrate = r_sex[:lrate])
	paf_sex_sub = DataFrame(location = paf_sex[:location], lnegpaf = paf_sex[:lnegpaf])
    rpaf = join(r_sex_sub, paf_sex_sub, on = :location)
	Dict(:sex => s, :df => join(rpaf, gbd17iso3166_ctries, on = :location))
end

function pafrate_ols(sdict)
	ols = lm(@formula(lrate~lnegpaf), sdict[:df])
	Dict(:ols => ols, :sdict => sdict)
end

function poplot(podict)
	close("all")
	df = podict[:sdict][:df]
	ols = podict[:ols]
	co1lab = round(coef(ols)[1], digits=3)
	co2lab = round(coef(ols)[2]*-1, digits=3)
	reglab = latexstring(replace("$co1lab-$co2lab x", "."=>"{,}"))
	plot(df[:lnegpaf], df[:lrate], ".")
	plot(df[:lnegpaf], predict(ols), "-", label = reglab)
	for(i, iso3166) in enumerate(df[:iso3166])
		annotate(iso3166, (df[:lnegpaf][i], df[:lrate][i]))
	end
	grid(1)
	legend(loc=3)
	title("Ischemisk hjärtsjukdom 2017 50\u201369 $(sexes[podict[:sdict][:sex]])")
	xlabel("log(1\u2212PAF)")
	ylabel("log(dödstal)")
end