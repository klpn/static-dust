#!/usr/bin/env julia
include("eur_dmon.jl")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
nord = ["DK", "FI", "NO", "SE"]
months = [12, 1, 2, 3, 4]

for month in months
    swe_month = swe_months[month]
    monthstr = "M$(lpad("$(month)", 2, '0'))"
    pgfsave("../../images/nord_mort_6018_$(monthstr).svg", plot_geos_month(nord, monthstr))
    print(*("![Dödstal nordiska länder $(swe_month) 1960–2018.]",
        "(../../images/nord_mort_6018_$(monthstr).svg)",
        "{#fig:nord_mort_6018_$(monthstr) width=100%}\n\n"))
end
