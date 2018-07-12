#!/usr/bin/env julia
include("rf_cfchange.jl")
imgdir = joinpath("..", "..", "images")
function pltse8015(age, sex, indyr=1980)
	close()
	plotsex(age, 93, sex, 1980, 2015, indyr)
	savefig(joinpath(imgdir, "Sv8015_$(sex)$(age)RfInd$(indyr).svg"))
	close()
end
pltse8015(:a55_64, 2)
pltse8015(:a55_64, 1)
pltse8015(:a55_64, 2, 2015)
pltse8015(:a75_84, 2)
pltse8015(:a75_84, 1)
