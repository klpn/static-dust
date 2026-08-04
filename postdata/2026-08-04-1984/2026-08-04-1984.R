#!/usr/bin/env Rscript
library(morr)
hmd <- hmdltfs()
ndegse <- ctry_caf("4290", "neurdeg", "all")
ndegse_f84 <- ndegse |> filter(sex==2 & yr==1984)
ndegse_f24 <- ndegse |> filter(sex==2 & yr==2024)
ndegse_f84h <- cahmdltf(ndegse_f84, hmd |> filter(PopName=="SWE"))
ndegse_f24h <- cahmdltf(ndegse_f24, hmd |> filter(PopName=="SWE"))
ndegse_f84p <- ndegse_f84h |>
    mutate(camx_m = ndegse_f24h$camx,
           camx_c = case_when(Age<60 ~ camx, Age<90 ~ camx_m * 3,
                              Age<95 ~ camx_m * 2, Age>=95 ~camx_m * 1.5),
           rat = camx_c/mx)
ndegse_m84 <- ndegse |> filter(sex==1 & yr==1984)
ndegse_m24 <- ndegse |> filter(sex==1 & yr==2024)
ndegse_m84h <- cahmdltf(ndegse_m84, hmd |> filter(PopName=="SWE"))
ndegse_m24h <- cahmdltf(ndegse_m24, hmd |> filter(PopName=="SWE"))
ndegse_m84p <- ndegse_m84h |>
    mutate(camx_m = ndegse_m24h$camx,
           camx_c = case_when(Age<60 ~ camx, Age<90 ~ camx_m * 3,
                              Age<95 ~ camx_m * 2, Age>=95 ~camx_m * 1.5),
           rat = camx_c/mx)
