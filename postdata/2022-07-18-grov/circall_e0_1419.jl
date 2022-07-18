#!/usr/bin/env julia
using MortIntl, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}", raw"\usepackage{unicode-math}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}", raw"\setmathfont{Asana-Math}")
ctries = [2090, 2120, 2450,
    3090, 3160, 3325,
    4010, 4018, 4020, 4038, 4055, 4070, 4085, 4140, 4150, 4170,
    4180, 4186, 4188, 4210, 4220, 4230, 4240, 4272, 4274, 4276,
    4280, 4290, 4300, 4310, 4320, 4330,
    5020, 5150]
pgfsave("../../images/circall_e0_f_1419.svg",
    MortIntl.caprop_eplot(ctries, 2, "circ", "all", 1, 0, "sv",
        MortIntl.datapath, MortIntl.datapath, 2014:2019, false))
pgfsave("../../images/circall_e0_m_1419.svg",
    MortIntl.caprop_eplot(ctries, 1, "circ", "all", 1, 0, "sv",
        MortIntl.datapath, MortIntl.datapath, 2014:2019, false))
