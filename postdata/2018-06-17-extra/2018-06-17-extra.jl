#!/usr/bin/env julia
include("amp_mgen.jl")
using Mustache
postpath = joinpath("..", "..", "posts")
csvraw = joinpath("data", "BE0101AW.csv")
csvform = joinpath("data", "popdths15.csv")
run(pipeline(`iconv -f ISO_8859-1 -t UTF8`, stdin=csvraw
	, stdout=pipeline(`./scbpopdths.sed`, csvform)
	))
popdths15 = readtable(csvform)
popdthssplit(sex) = @from i in popdths15 begin
	@where i.sex==sex
        @select {i.age,i.pop,i.dths}
	@collect DataFrame
end
agesum(df) = DataFrame(age=df[:age][1:106]
	, pop = [df[:pop][1:105]; sum(df[:pop][106:end])]
	, dths = [df[:dths][1:105]; sum(df[:dths][106:end])]
	)
chfs = Dict(
	:circ => Dict(:noconv => 0.75
		, :conv => [fill(0.75, 80); (0.75*100:100)./100])
	, :noncirc => Dict(:noconv => 0.8 
		, :conv => [fill(0.8, 80); (0.8*100:100)./100; fill(1,5)])
	)
popdths_se15 = map(s -> popdthssplit(s)|>agesum, [1;2])
ch_sexes_se15(ca, chf_ca, chf_nonca, pwr) =
	map(s -> chfac(4290, s, ca, 2015, chf_ca.^pwr, chf_nonca.^pwr, popdths_se15[s]), [1;2])

circse15_conv_noconv(p) =
	map(c -> (c, ch_sexes_se15("circ", chfs[:circ][c], chfs[:noncirc][c], p)), 
		[:noconv; :conv]) |> Dict

if !(isdefined(:se3))
	se3 = circse15_conv_noconv(3)
end

percround(v) = replace("$(round(v, 2))", ".", ",")

se3vs = Dict(
	:e50_m => se3[:noconv][1][:lt][:e][51]
	, :e50_m_rc_nc => se3[:noconv][1][:lt_rc][:e][51]
	, :e50_m_rc_c => se3[:conv][1][:lt_rc][:e][51]
	, :e50_f => se3[:noconv][2][:lt][:e][51]
	, :e50_f_rc_nc => se3[:noconv][2][:lt_rc][:e][51]
	, :e50_f_rc_c => se3[:conv][2][:lt_rc][:e][51]
	, :circp_m => se3[:noconv][1][:changes][:ptoages2][end]*100
	, :circp_m_rc_nc => se3[:noconv][1][:changes][:ptoages1][end]*100
	, :circp_m_rc_c => se3[:conv][1][:changes][:ptoages1][end]*100
	, :circp_f => se3[:noconv][2][:changes][:ptoages2][end]*100
	, :circp_f_rc_nc => se3[:noconv][2][:changes][:ptoages1][end]*100
	, :circp_f_rc_c => se3[:conv][2][:changes][:ptoages1][end]*100
	)
se3vs_f = Dict(zip(keys(se3vs), map(percround, values(se3vs))))

tpl = readstring("2018-06-17-extra.mustache")
write(joinpath(postpath, "2018-06-17-extra.md"), render(tpl, se3vs_f))
