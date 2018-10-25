using CSV, DataFrames
deaths = CSV.read(normpath("data", "2018-10-17-4Amod.csv"))
ages = DataFrame(age = collect(0:20), 
	agest = [0;0;1;collect(5:5:90)],
	age2 =[0;1;fill(2,3);fill(3,6);fill(4,4);fill(5,2);fill(6,4)])
ages2 = by(ages[:,[:agest, :age2]], :age2, 
df -> DataFrame(agest=minimum(df[:agest])))

pop = DataFrame()
pop1 = CSV.read(normpath("data", "mfsv17.csv"))
ages1 = DataFrame(age1 = collect(0:101),
	age = [0;1;fill(2,4);map((x)->fld(x,5)+2, collect(5:89));fill(20,11)])
pop1_age = join(pop1, ages1, on = :age1)

function popsexadd(sex)
	pop1_sex = pop1_age[pop1_age[:sex].==sex, [:n, :age]]
	pop_sex = by(pop1_sex, :age, df -> DataFrame(sex = sex, n = sum(df[:n])))
end

pop = vcat(popsexadd("Kv"), popsexadd("M"))

function df_reg(sex, caexpr, ageaggr = false)
	if caexpr == "pop"
		df_sub = pop[pop[:sex].==sex, [:age, :n]]
		sort!(df_sub, (:age))
	else
		df_sub = deaths[((map((x)->occursin(Regex(caexpr), x), 
		convert(Vector{String}, deaths[:icd10]))) .& (deaths[:sex].==sex)), 
		[:age, :n]]
	end
	df_aggr = by(df_sub, :age, df -> DataFrame(n=sum(df[:n])))
	df_aggr_age = join(df_aggr, ages, on = :age)
	if ageaggr
		df_aggr_age2 = by(df_aggr_age[:, [:n, :age2]], :age2,
		df -> DataFrame(n=sum(df[:n])))
		return join(df_aggr_age2, ages2, on = :age2)
	else
		return df_aggr_age
	end
end

function propframe(sex, ca1, ca2 = "A00-Y98", ageaggr = false)
	ca1frame = df_reg(sex, ca1, ageaggr)
	ca2frame = df_reg(sex, ca2, ageaggr)
	propframe = DataFrame(age = ca1frame[1], agest = ca1frame[:agest],
			      ca1n = ca1frame[:n],
			      ca2n = ca2frame[:n],
			      prop = ca1frame[:n]./ca2frame[:n])
	return Dict(:sex => sex, :ca1 => ca1, :ca2 => ca2, :frame => propframe)
end
