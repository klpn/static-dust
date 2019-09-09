#!/usr/bin/env julia
import Mortchartgen
using PGFPlotsX
frames = Mortchartgen.load_frames()
cts4564 = Mortchartgen.propplot_sexesyrs("circ", "tum", [2;1], 4290, 15, 18,
	1951:2016, false, frames, "sv", "", false)
cts6574 = Mortchartgen.propplot_sexesyrs("circ", "tum", [2;1], 4290, 19, 20,
	1951:2016, false, frames, "sv", "", false)

pf2pgftable(pf, sex) =
	Table([pf[sex][:propframe][:Year], pf[sex][:propframe][:value]])

p = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
		"xticklabel style"={"/pgf/number format/set thousands separator={}"},
		"legend style"={"font=\\tiny"},
		legend_pos="north east", ylabel="cirkulation/tumör",
		"xtick distance"=10, "ytick distance"=.5,
		title="Antal dödsfall cirkulation/tumör Sverige",
		xmajorgrids, ymajorgrids},
	PlotInc(pf2pgftable(cts4564, 2)), LegendEntry("kvinnor 45–64"),
	PlotInc(pf2pgftable(cts4564, 1)), LegendEntry("män 45–64"),
	PlotInc(pf2pgftable(cts6574, 2)), LegendEntry("kvinnor 65–74"),
	PlotInc(pf2pgftable(cts6574, 1)), LegendEntry("män 65–74"))

pgfsave("../../images/secirctum5116_4574.svg", p)