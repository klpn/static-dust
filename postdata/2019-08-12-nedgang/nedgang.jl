#!/usr/bin/env julia
include("secirc9717eurshort.jl")
sc9717plall(sc9717sex(2))
savefig("../../images/secirc9717eurshort_kv.svg")
close()
sc9717plall(sc9717sex(1))
savefig("../../images/secirc9717eurshort_m.svg")