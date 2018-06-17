using PyPlot, DataFrames, Query
pygui(true)
csvraw = joinpath("data", "Statistikdatabasen_2017-12-23 16_43_51.csv")
csvform = joinpath("data", "influi0916.csv")

if !(ispath(csvform))
	run(pipeline(`./sos.awk`, stdin=csvraw, stdout=csvform))
end

influi0916 = readtable(csvform)
influi0916a = @from i in influi0916 begin
		@group i by @NT(Ålder=i.Ålder, Kön=i.Kön) into g
		@select {Ålder=g.key.Ålder,
			Kön=g.key.Kön,
			Incidens=mean(g..Incidens)}
		@collect DataFrame
	end

for sex in ["Kvinnor"; "Män"]
	influi0916as = influi0916a[influi0916a[:Kön].==sex, :]
	plot(influi0916as[:Ålder], log(influi0916as[:Incidens]./10^5),
		"-o", label = "$sex")
end
grid(1)
xlabel("Ålder")
ylabel("log(incidens)")
title("Sjukhusvårdade influensa/lunginflammation Sverige 2009\u201316")
legend()
