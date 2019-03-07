#!/usr/bin/env julia
using CSV, DataFrames, PyCall, PyPlot
PyDict(matplotlib."rcParams")["axes.formatter.use_locale"] = true
inf_se_0917 = CSV.read("data/inf_se_0917.csv")
subtypecols = [:h1pdm09; :aoth; :aunk; :b]
labels = ["A(H1N1)pdm09"; "A annan"; "B"]
inf_se_0917p = DataFrame()
for col in subtypecols
	inf_se_0917p[col] = inf_se_0917[col] ./ inf_se_0917[:samples]
end
h1n1subp = inf_se_0917p[:h1pdm09] ./ (inf_se_0917p[:h1pdm09].+inf_se_0917p[:aoth])
inf_se_0917p[:h1pdm09] = inf_se_0917p[:h1pdm09] .+ inf_se_0917p[:aunk] .* h1n1subp 
inf_se_0917p[:aoth] = inf_se_0917p[:aoth] .+ inf_se_0917p[:aunk] .* (1 .- h1n1subp)
stackplot(inf_se_0917[:season], PyReverseDims(convert(Matrix, inf_se_0917p[:, [1,2,4]])), labels = labels)
grid(1)
title("Labbprover positiva för influensasubtyper Sverige")
ylabel("Andel positiva")
legend()
savefig("../../images/inf_se_0917.svg")
