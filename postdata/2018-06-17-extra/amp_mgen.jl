using Query
import Mortchartgen
include("amplt.jl")
if !(isdefined(:frames))
	frames = Mortchartgen.load_frames()
end
deaths = frames[:deaths]
pop = frames[:pop]
pop_csy(country, sex, year) = @from i in pop begin
         @where i.Sex==sex && i.Country==country && i.Year==year
         @select {i.variable,i.value}
         @collect DataFrame
       end
deaths_cscy(country, sex, cause, year) = @from i in deaths begin
         @where i.Sex==sex && i.Country==country && i.Cause==cause && i.Year==year
         @select {i.variable,i.value}
         @collect DataFrame
       end

function caframe(country, sex, cause, year)
	popf = pop_csy(country, sex, year)
	alldeathsf = deaths_cscy(country, sex, "all", year)
	deathsf = deaths_cscy(country, sex, cause, year)
	DataFrame(age=vcat(0:4,5:5:95)
		, pop=popf[:value][2:25]
		, acd=alldeathsf[:value][2:25]
		, cd=deathsf[:value][2:25]
		, cc=fill(0,24)
		)
end

function caframe_sm(caf, smf)
	caf[:aints] = collect(1:24)
	caf[:cd_prop] = zfrac.(caf[:cd], caf[:acd])
	smf[:aints] = [1:5;map(x->fld(x,5)+5, 5:99);fill(24,6)]
	caf_smf = join(caf, smf, on = :aints)
	cd_sm = caf_smf[:dths].*caf_smf[:cd_prop]
	DataFrame(age=smf[:age]
		, pop=smf[:pop]
		, acd=smf[:dths]
		, cd=cd_sm
		, cc=fill(0,106)
		)
end

function chfac(country, sex, cause, year, cf_cd, cf_nocd, smframe = NA)
	caf_0 = caframe(country, sex, cause, year)
	if !(isna(smframe))
		caf = caframe_sm(caf_0, smframe)
	else
		caf = caf_0
	end
	lt = periodlifetable(caf, sex)
	rc = ratechange(caf, cf_cd, 1, cf_nocd)
	lt_rc = periodlifetable(rc, sex)
	caf_amp = amplt(caf, sex, "mort")
	caf_amp_rc = amplt(rc, sex, "mort")
	Dict(:lt => lt, :lt_rc => lt_rc, :changes => changes(caf_amp_rc, caf_amp))
end
