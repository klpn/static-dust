#!/usr/bin/env julia
include("rf_cfchange.jl")
imgdir = joinpath("..", "..", "images")
 
se = map(s->map(a->agsrrs(a, 93, s, 1980, 2015), keys(ages)), [1;2])

function savesexplot(d, trans)
	close()
	plotsex(d, trans)
	savefig(joinpath(imgdir, "Sv8015_$(d[:sex])$(d[:age])RfInd$(ucfirst("$(trans)")).svg"))
	close()
end

function saverdiffplot(ds)
	close()
	plotrdiffps(keys(ages), ds, map(sds->sds[:rdiffs_cbs], ds))
	savefig(joinpath(imgdir, "Sv8015_$(ds[1][:sex])Rdiffs.svg"))
	close()
end

savesexplot(se[1][3], :log)
savesexplot(se[1][3], :lin)
saverdiffplot(se[1])
saverdiffplot(se[2])
