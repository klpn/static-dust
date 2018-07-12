using DataFrames, PyCall, PyPlot, Query
import Mortchartgen, CSV, Requests, ZipFile

rffiles = Dict(
	       :chol => "IHME_GBD_2015_COVARIATES_1980_2015_MEAN_CHOLESTEROL_Y2016M10D07",
	       :sbp => "IHME_GBD_2015_COVARIATES_1980_2015_MEAN_SBP_Y2016M10D07",
	       :smok => "IHME_GBD_2015_COVARIATES_1980_2015_SMOKING_PREV_Y2016M10D07"
	       )


function download_gbd(filename)
	mkpath("data")
	preurl = "https://cloud.ihme.washington.edu/index.php/s/SotC3shZAcGVFch/download?path=%2FGBD%202015%20Covariates&files="
	filefullname = "$filename.zip"
	fileurl = "$preurl$filefullname"
	dlpath = joinpath("data", filefullname)
	Requests.save(Requests.get(fileurl), dlpath)
	r = ZipFile.Reader(dlpath)
	for f in r.files
		write(joinpath("data", f.name), read(f))
	end
	rm(dlpath)
end

for fname in values(rffiles)
	if !(isfile(joinpath("data", "$fname.CSV")))
		download_gbd(fname)
	end
end

PyDict(matplotlib["rcParams"])["axes.formatter.use_locale"] = true

if !(isdefined(:frames))
	frames = Mortchartgen.load_frames()
end

gbdlid2who = Dict(67=>3160, 78=>4050, 79=>4070, 90=>4220, 93=>4290, 95=>4310, 102=>2450)

rfs = Dict(:chol=>:mean, :sbp=>:mean, :smok=>:prev)

## RRS from: 
#  - doi:10.1371/journal.pone.0065174 (chol, sbp)
#  - doi:10.1161/CIRCULATIONAHA.104.521708 (smok)
ages = Dict(
	:a35_44 => Dict(:sage=>13, :eage=>14, :gbd_ageid=>12,
			:chol=>2.20, :sbp=>1.68^(1/10), :smok=>Dict(1=>5.51, 2=>2.26)), 
	:a45_54 => Dict(:sage=>15, :eage=>16, :gbd_ageid=>14,
			:chol=>1.82, :sbp=>1.56^(1/10),:smok=>Dict(1=>3.04, 2=>3.78)), 
	:a55_64 => Dict(:sage=>17, :eage=>18, :gbd_ageid=>16,
			:chol=>1.44, :sbp=>1.45^(1/10),
			:smok=>Dict(1=>mean([3.04;1.88]), 2=>mean([3.78;2.53]))), 
	:a65_74 => Dict(:sage=>19, :eage=>20, :gbd_ageid=>18,
			:chol=>1.27, :sbp=>1.33^(1/10),
			:smok=>Dict(1=>mean([1.88;1.44]), 2=>mean([2.53;1.68]))),
	:a75_84 => Dict(:sage=>21, :eage=>22, :gbd_ageid=>20,
			:chol=>1.18, :sbp=>1.26^(1/10),
			:smok=>Dict(1=>mean([1.44;1.05]), 2=>mean([1.68;1.38])))
	)
agelabel(age) = replace("$age", "_", "\u2013")[2:end]
rfframes = Dict(
	:chol => CSV.read(joinpath("data", "$(rffiles[:chol]).CSV")),
	:sbp => CSV.read(joinpath("data", "$(rffiles[:sbp]).CSV")),
	:smok => CSV.read(joinpath("data", "$(rffiles[:smok]).CSV"), datarow=14330),
	)
rfalsy(rfframe, gbd_ageid, gbd_locid, sex, syr, eyr) = @from i in rfframe begin
	@where i.age_group_id==gbd_ageid && i.location_id==gbd_locid &&
		i.sex_id==sex && i.year_id>=syr && i.year_id<=eyr
	@select i
	@collect DataFrame
end

function rrs(rf, age, gbd_locid, sex, syr, eyr, indyr)
	if (rf==:chol || rf==:sbp)
		gbd_ageid=22
	else
		gbd_ageid=ages[age][:gbd_ageid]
	end
	frame = rfalsy(rfframes[rf], gbd_ageid, gbd_locid, sex, syr, eyr)
	agerr = ages[age][rf]
	ind = indyr-syr+1
	if typeof(agerr)<:Dict
		agesexrr = agerr[sex]
	else
		agesexrr = agerr
	end
	if rfs[rf]==:mean
		rfdiff = frame[:val][ind].-frame[:val]
		agesexrr.^rfdiff
	elseif rfs[rf]==:prev
		rfr1 = frame[:val][ind].*agesexrr
		rfr = frame[:val].*agesexrr
		(rfr1.+(1.-frame[:val][ind])) ./ (rfr.+(1.-frame[:val]))
	end
end

function plotsex(age, gbd_locid, sex, syr, eyr, indyr=syr)
	yrs = syr:eyr
	who_country = gbdlid2who[gbd_locid]
	clab = Mortchartgen.conf["countries"]["$who_country"]["alias"]["sv"]
	slab = Mortchartgen.conf["sexes"]["$sex"]["alias"]["sv"]
	ihd = Mortchartgen.propplot_sexesyrs("ihd", "pop", [sex], who_country,
		ages[age][:sage], ages[age][:eage], syr:eyr, true, frames, "sv",
		joinpath(tempdir(), "mout.html"), false)
	rates = ihd[sex][:propframe][:value]
	rates_sm = ihd[sex][:propsm]
	rrs_chol = rrs(:chol, age, gbd_locid, sex, syr, eyr, indyr)
	rrs_sbp = rrs(:sbp, age, gbd_locid, sex, syr, eyr, indyr)
	rrs_smok = rrs(:smok, age, gbd_locid, sex, syr, eyr, indyr)
	plot(yrs, log.(rates), "*", label=L"r", color="blue")
	plot(yrs, log.(rates_sm), "-", label=L"r_{sm}", color="blue")
	plot(yrs, log.(rates_sm.*rrs_chol), "-",
		label=latexstring("r_{sm} \\times RR_{TC($indyr)}"))
	plot(yrs, log.(rates_sm.*rrs_chol.*rrs_sbp), "-",
		label=latexstring("r_{sm} \\times RR_{TC($indyr)} \\times RR_{SBP($indyr)}"))
	plot(yrs, log.(rates_sm.*rrs_chol.*rrs_sbp.*rrs_smok), "-",
		label=latexstring("r_{sm} \\times RR_{TC($indyr)} \\times RR_{SBP($indyr)} \\times RR_{SMOK($indyr)}"))
	legend(loc=3)
	grid(1)
	xlabel("År")
	ylabel("log(dödstal)")
	title("Dödstal IHD vs kontrafaktiska riskfaktormönster, $slab $clab $(agelabel(age))")
end
