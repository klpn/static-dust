#!/usr/bin/env julia
include("soscan.jl")
selc7017 = sosread("data/Statistikdatabasen_2019-02-21 18_39_26.csv")
caplot(selc7017, :Kvinnor, 45)
caplot(selc7017, :Män, 45)
caplot(selc7017, :Kvinnor, 65)
caplot(selc7017, :Män, 65)
grid(1)
legend(loc = 3)
xlabel("Kohort")
ylabel("log(incidens)")
title("Incidens lungcancer Sverige")
savefig("../../images/SvLc7017CohAge.svg")