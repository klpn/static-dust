using CSV, DataFrames
ushead = ["Resstatus","Edu89","Edu03","Edurep","Dmon","Sex","Agetype","Age",
	"Agesubst","AgeRe52","AgeRe27","AgeRe12","InfAgeRe22","Dplace","Mart",
	"Dweek","Datayear","Injwork","Dmanner","Disp","Autopsy","Actcode","Injplace",
	"UcIcd","UcRe358","UcRe113","UcReInf130","UcRe39","EntNr","Ent",
	"RecNr","Rec1","Rec2","Rec3","Rec4","Rec5","Rec6","Rec7","Rec8","Rec9","Rec10",
	"Rec11","Rec12","Rec13","Rec14","Rec15","Rec16","Rec17","Rec18","Rec19","Rec20",
	"Race","Bridged","Impute","RaceRe3","RaceRe5","Hisp","HispRaceRe"]
us201401 = CSV.File("data/us201401.csv", header = ushead) |> DataFrame
caexps = [r"I([0-3]|4[^6]|[5-9])", r"C|D[0-4]", r"F0|[GH]", r"E",
	r"[AB]|J[0-2]", r"J([3-8]|9[^6])", r"[V-Y]", r"K", r"N", r"D[5-9]",
	r"F[1-9]", r"L", r"M", r"O", r"P", r"Q"]
cano(entstr) = BitArray(map((c)->occursin(c, entstr), caexps)).chunks[1]
us201401[:cano] = map(cano, us201401[:Ent])

function propf(inframe)
	pf = sort(by(inframe, :cano, N=:cano=>length), (:N), rev=(true))
	pf[:prop] = pf[:N] ./ sum(pf[:N])
	pf
end

propfsa(inframe, sex, sage, eage) = propf(inframe[(inframe.Sex .== sex) .&
	(inframe.Age .>= sage) .& (inframe.Age .<= eage), :])

propall(pf, n) = sum(pf[(pf[:cano] .& n) .== n, :][:prop])
propsome(pf, n) = sum(pf[(pf[:cano] .& n) .> 0, :][:prop])

ncaexps(n) = filter((e)->(Int(2^(e[1]-1)) | n) == n, collect(enumerate(caexps)))