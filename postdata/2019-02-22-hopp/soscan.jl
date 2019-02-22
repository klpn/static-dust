using CSV, DataFrames, PyCall, PyPlot

PyDict(matplotlib["rcParams"])["axes.formatter.use_locale"] = true

function sosread(csvraw)
	csvform = tempname()
	if !(ispath(csvform))
		run(pipeline(`./soscan.awk`, stdin=csvraw, stdout=csvform))
	end
	df = CSV.read(csvform, delim=';')
	df[:Kohort] = df[:År] .- (df[:Ålder] .+ 2)
	return df
end

function agelab(age)
	if age == 85
		return "85\u2013"
	else
		return "$(age)\u2013$(age+4)"
	end
end

function caplot(frame, sex, age)
	subframe = frame[frame[:Ålder].==age, :]
	salab = "$sex $(agelab(age))"
	plot(subframe[:Kohort], log.(subframe[sex]./10^5), "-*", label=salab)
end
