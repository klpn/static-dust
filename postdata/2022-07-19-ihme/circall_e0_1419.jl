#!/usr/bin/env julia
include("../2022-07-18-grov/circall_e0_1419_head.jl")
pgfsave("../../images/circall_e0_f_1419_en.svg",
    MortIntl.caprop_eplot(ctries, 2, "circ", "all", 1, 0, "en",
        MortIntl.datapath, MortIntl.datapath, 2014:2019, false))
pgfsave("../../images/circall_e0_m_1419_en.svg",
    MortIntl.caprop_eplot(ctries, 1, "circ", "all", 1, 0, "en",
        MortIntl.datapath, MortIntl.datapath, 2014:2019, false))
