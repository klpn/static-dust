using PyPlot, DataFrames, Query
pygui(true)

function sosagg(csvraw, agglabel)
	csvform = tempname()
	if !(ispath(csvform))
		run(pipeline(`./sos.awk`, stdin=csvraw, stdout=csvform))
	end
	sosmeta = split(readlines(open(csvraw))[1], [','; '/'])
	measure = lowercase(strip(sosmeta[2]))
	reg = strip(sosmeta[end-1])
	if reg == "Riket"
		reg = "Sverige"
	end

	sos = readtable(csvform)
	sosa = @from i in sos begin
			@group i by @NT(Ålder=i.Ålder, Kön=i.Kön) into g
			@select {Ålder=g.key.Ålder,
				Kön=g.key.Kön,
				Incidens=mean(g..Incidens)}
			@collect DataFrame
		end
	return Dict(:sosa => sosa,
		:agglabel=>agglabel,
		:minyr=>minimum(sos[:År]),
		:maxyr=>maximum(sos[:År]),
		:measure=>measure,
		:reg => reg)
end

function sexplot(sosad)
	sosa = sosad[:sosa]
	lab = sosad[:agglabel]
	minyr = sosad[:minyr]
	maxyr = sosad[:maxyr]
	measure = sosad[:measure]
	reg = sosad[:reg]
	for sex in ["Kvinnor"; "Män"]
		sosas = sosa[sosa[:Kön].==sex, :]
		plot(sosas[:Ålder], log(sosas[:Incidens]./10^5),
			"-o", label = "$sex")
	end
	grid(1)
	xlabel("Ålder")
	ylabel("log(incidens, $measure)")
	title("Sjukhusvårdade $lab $reg $minyr\u2013$maxyr")
	legend()
end
