using PyPlot, PyCall
include("amplt.jl")
PyDict(matplotlib["rcParams"])["axes.formatter.use_locale"] = true
sexframes = Dict(1=>readtable(joinpath("data", "mse14.csv")),
	2=>readtable(joinpath("data", "fse14.csv")))
sexlabels = ["män"; "kvinnor"]
cdicts = vcat(map(sex -> map(ncd -> amplt(ratechange(sexframes[sex], 4/5, 1, ncd), sex, "mort") |>
	f->changes(f, amplt(sexframes[sex], sex, "mort")) |>
	c -> Dict(:sex => sex, :ncd => ncd, :cframe => c),
	[1;4/5;3/5]), [2;1])...)
map(cd -> plot(cd[:cframe][:age], cd[:cframe][:relchange],
	label = "$(sexlabels[cd[:sex]]), ncd=$(cd[:ncd])", "-o"), cdicts)
xlabel("Ålder")
ylabel("RR")
grid(1)
title("Relativ risk upp till ålder för cd=0,8, Sverige 2014")
legend()
