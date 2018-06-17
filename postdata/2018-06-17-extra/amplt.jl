using LifeTable, DataFrames

function zfrac(a, b)
	if b==0
		return 0
	else
		return a / b
	end
end

function amplt(inframe, sex, rate = "inc")
	age = inframe[1]
	pop = inframe[2]
	acd = inframe[3]
	cd = inframe[4]
	cc = inframe[5]
	if rate == "inc"
		ncol = cc
		dcol = acd .- cd .+ cc
	elseif rate == "mort"
		ncol = cd
		dcol = acd
	end
	df = DataFrame(age = age, pop = pop, dcol = dcol)
	cprop = zfrac.(ncol, dcol)
	lt = periodlifetable(df, sex)
	Dict(:sex=>sex, :cl_frame=>causelife(lt, cprop))
end

function ratechange(inframe, changefac_cd, changefac_cc, changefac_nocd)
	ncd = inframe[4] .* changefac_cd
	ncc = inframe[5] .* changefac_cc
	nacd = (inframe[3].-inframe[4]).*changefac_nocd .+ ncd
	DataFrame(age = inframe[1], pop = inframe[2],
		acd = nacd, cd = ncd, cc = ncc)
end

ptoage(cl_frame, plt_frame) = [cl_frame[:f][1] .* (1-plt_frame[:l]); cl_frame[:f][1]]

function changes(ifdict1, ifdict2)
	if1 = ifdict1[:cl_frame]
	if2 = ifdict2[:cl_frame]
	lts = map(i->periodlifetable(i, ifdict1[:sex], true, "rate"), [if1, if2])
	ptoages1 = ptoage(if1, lts[1])[2:end]
	ptoages2 = ptoage(if2, lts[2])[2:end]
	DataFrame(age = [if1[:age][2:end]; Inf],
		ptoages1 = ptoages1, ptoages2 = ptoages2,
		relchange = ptoages1./ptoages2, abschange = ptoages1.-ptoages2)	
end
