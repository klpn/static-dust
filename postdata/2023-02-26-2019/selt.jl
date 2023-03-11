using CSV, DataFrames, LifeTable
pop21 = CSV.File("data/mpop21.tsv") |> DataFrame
dths21 = CSV.File("data/dths21.tsv") |> DataFrame
pop22 = CSV.File("data/mpop22.tsv") |> DataFrame
dths22 = CSV.File("data/dths22.tsv") |> DataFrame
sexes = ["m", "f"]
pdths(pop, dths, sex) = DataFrame(age = pop[pop[:sex].==sexes[sex], :age],
                       mpop = pop[pop[:sex].==sexes[sex], :mpop],
                       dths = dths[dths[:sex].==sexes[sex], :deaths])
periodlifetable(pdths(pop21, dths21, 2), 2) |> CSV.write("data/ltf21.tsv", delim='\t')
periodlifetable(pdths(pop21, dths21, 1), 1) |> CSV.write("data/ltm21.tsv", delim='\t')
periodlifetable(pdths(pop22, dths22, 2), 2) |> CSV.write("data/ltf22.tsv", delim='\t')
periodlifetable(pdths(pop22, dths22, 1), 1) |> CSV.write("data/ltm22.tsv", delim='\t')
