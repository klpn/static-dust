using Colors, DifferentialEquations, LaTeXStrings, PGFPlotsX

function sir!(du, u, p, t)
    du[1] = -(p[1]/p[2] * u[2] * u[1])
    du[2] = (p[1]/p[2] * u[2] * u[1]) - u[2]/p[2]
    du[3] = u[2] / p[2]
end

function sirplot(r0, d, t)
    u0 = [1-1e-6, 1e-6, 0.0]
    solv = solve(ODEProblem(sir!, u0, t, [r0, d]), saveat=1)
    r0lab = latexstring(replace("\\mathcal{R}_0=$(r0)", "."=>"{,}"))
    dlab = latexstring("D=$d")
    p = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
       legend_pos="outer north east",
       title="SIR för $(r0lab), $(dlab)", xlabel=L"t",
       ylabel=L"p",
       xmajorgrids, ymajorgrids})
    cs = ["S","I","R"]
    plotcolors = distinguishable_colors(length(cs)+1, [RGB(1,1,1)])[2:end]
    for (i, c) in enumerate(cs)
       @pgf push!(p, PlotInc({no_markers, color = plotcolors[i]},
           Table([solv.t, map(r -> r[i], solv.u)])),
           LegendEntry(latexstring(c)))
    end
    @pgf push!(p, PlotInc({no_markers, style = {"dashed"}, color = plotcolors[1]},
       Coordinates([(t[1], 1/r0), (t[2], 1/r0)])),
       LegendEntry(L"1/\mathcal{R}_0"))
    p
end
