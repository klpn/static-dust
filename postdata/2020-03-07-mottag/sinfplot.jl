#!/usr/bin/env julia
using Colors, LaTeXStrings, PGFPlotsX
ss = map(x -> x/100, 1:100)
sinf(r0) = map(s -> r0*(s-1) - log(s), ss) 
p = @pgf Axis({"xticklabel style"={"/pgf/number format/use comma"},
   legend_pos="north east",
   title=*(L"S_\infty", " för varierande ", L"\mathcal{R}_0"), xlabel=L"S",
   ylabel=L"\mathcal{R}_0(S-1)-\log(S)",
   xmajorgrids, ymajorgrids})
rs = [1.3, 1.8, 2, 2.5, 3]
plotcolors = distinguishable_colors(length(rs)+1, [RGB(1,1,1)])[2:end]
for (i, r) in enumerate(rs)
   rlab = latexstring(replace("\\mathcal{R}_0=$r", "."=>"{,}"))
   @pgf push!(p, PlotInc({no_markers, color = plotcolors[i]},
      Table([ss, sinf(r)])),
      LegendEntry(rlab))
end
pgfsave("../../images/sinfty.svg", p)
