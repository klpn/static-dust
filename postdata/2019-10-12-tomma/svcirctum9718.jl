#!/usr/bin/env julia
include("sdb_reg.jl")
sv9718circtum = propyrs_allreg(99, :circ, :tum)

for sex in [1, 2]
	sv97 = propyr_regs_sex_df(sv9718circtum[:df], 1997, sex)
	plregs = vcat(sv97[:reg][1:3], 0, sv97[:reg][end-2:end])
	p = propyrs_regs_sex_plot(sv9718circtum, plregs, sex)
	pgfsave("../../images/sv9718circtum_regs_$(sex).svg", p)
end