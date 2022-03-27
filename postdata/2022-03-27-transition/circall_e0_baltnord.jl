#!/usr/bin/env julia
using MortIntl, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
ctries = [4050,4055,4070,4186,4188,4220,4290]
pgfsave("../../images/circall_e0_f_baltnord.svg",
    MortIntl.caprop_eplot(ctries, 2, "circ", "all", 1, 0, "en",
        MortIntl.datapath, MortIntl.datapath))
pgfsave("../../images/circall_e0_m_baltnord.svg",
    MortIntl.caprop_eplot(ctries, 1, "circ", "all", 1, 0, "en",
        MortIntl.datapath, MortIntl.datapath))
