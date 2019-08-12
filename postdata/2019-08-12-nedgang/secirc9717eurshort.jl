using CSV, DataFrames, Loess, PyCall, PyPlot
import DataStructures
PyDict(matplotlib."rcParams")["axes.formatter.use_locale"] = true
sexes = ["män", "kvinnor"]
sc9717 = CSV.File("data/secirc9717eurshort.csv") |> DataFrame
eshort = DataStructures.OrderedDict(:ami => "akut hjärtinfarkt", :othihd => "annan IHD",
	:othhd => "annan hjärtsjukdom", :str => "slaganfall",
	:othcirc => "annan cirkulation")

function lpred(yrs, col)
	yrs_f = Vector{Float64}(yrs)
	col_f = Vector{Float64}(col)
	lmod = loess(yrs_f, col_f)
	predict(lmod, yrs_f)
end

function sc9717sex(s)
	df_0 = sc9717[sc9717[:sex].==s, :]
	yrs = df_0[:year]
	df = df_0[:, 3:end]
	df_l = DataFrame()
	for es in keys(eshort)
		df_l[es] = lpred(yrs, df[es])
	end
	Dict(:sex => s, :yrs => yrs, :df => df, :df_l => df_l)
end

function sc9717plot(scdict, col)
	df = scdict[:df]
	df_l = scdict[:df_l]
	yrs = scdict[:yrs]
	pl = plot(yrs, log.(df[col]./10^5), "*", label = eshort[col])
	plot(yrs, log.(df_l[col]./10^5), "-", color = pl[1].get_color())
	grid(1)
	xticks(yrs, rotation = 45)
	legend()
	title("Åldersstandardiserade dödstal $(sexes[scdict[:sex]]) Sverige")
	ylabel("log(dödstal)")
end

sc9717plall(scdict) = map(c -> sc9717plot(scdict, c), collect(keys(eshort)))