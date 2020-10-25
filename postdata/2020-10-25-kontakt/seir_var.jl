using Colors, Distributions, LaTeXStrings, PGFPlotsX

lprob(d, x) = cdf(d, x) - cdf(d, x-1/1000)
xs = map(x -> x/1000, 1:10000)

function seir_var_susp(r0, d, g, k, ep, days, conn)
    gamma_d = Gamma(k, 1/k)
    lprobs = map((x) -> lprob(gamma_d, x), xs[1:9999])
    push!(lprobs, 1 - sum(lprobs))
    st = [(1-ep) .* lprobs]
    et = [ep .* lprobs]
    it = [fill(0.0, 10000)]
    rt = [fill(0.0, 10000)]
    if conn
        b = r0/(1+1/k) * g
    else
        b = r0 * g
    end
    for t in 2:days
        if conn
            l = b * sum(xs .* it[t-1])
        else
            l = b * sum(it[t-1])
        end
        sred = xs .* l .* st[t-1]
        ered = d .* et[t-1]
        ired = g .* it[t-1]
        push!(st, st[t-1] .- sred)
        push!(et, et[t-1] .+ sred .- ered)
        push!(it, it[t-1] .+ ered .- ired)
        push!(rt, rt[t-1] .+ ired)
    end
    Dict(:st => st, :et => et, :it => it, :rt => rt,
        :r0 => r0, :d => d, :g => g, :k => k, 
        :ep => ep, :conn => conn)
end

sedec(x) = replace("$x", "."=>"{,}")

function seirset(r0, d, g, kexps, ep, days)
    seirs_s = map(kexp -> seir_var_susp(r0, d, g, 2.0^kexp, ep, days, false), kexps)
    seirs_c = map(kexp -> seir_var_susp(r0, d, g, 2.0^kexp, ep, days, true), kexps)
    Dict(:seirs_s => seirs_s, :seirs_c => seirs_c, :kexps => kexps)
end

seirset_cends(seirset, c) = map(r -> r[end], map(s -> map(sum, s[c]), seirset))

function seirplot(seir)
    r0lab = latexstring(*("\\mathcal{R}_0=", sedec(seir[:r0])))
    klab = latexstring(*("k=", sedec(seir[:k])))
    if seir[:conn]
        connlab = "kontakt"
    else
        connlab = "mottaglighet"
    end
    days = 1:length(seir[:st])
    p = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
        legend_pos="outer north east",
        title="SEIR för $(r0lab), $(klab), varierande $(connlab)", xlabel=L"t",
        ylabel=L"p",
        xmajorgrids, ymajorgrids})
    cs = [("S", seir[:st]), ("E", seir[:et]), ("I", seir[:it]), ("R", seir[:rt])]
    plotcolors = distinguishable_colors(length(cs)+1, [RGB(1,1,1)])[2:end]
    for (i, c) in enumerate(cs) 
        @pgf push!(p, PlotInc({no_markers, color = plotcolors[i]},
            Table([days, map(sum, c[2])])), LegendEntry(c[1]))
    end
    p
end

function seirset_rendsplot(seirset)
    seir = seirset[:seirs_s][1]
    r0lab = latexstring(*("\\mathcal{R}_0=", sedec(seir[:r0])))
    rendlab = latexstring("\\mathrm{R}($(length(seir[:st])))")
    p = @pgf Axis({"yticklabel style"={"/pgf/number format/use comma"},
        legend_pos="outer north east",
        title="SEIR för $(r0lab)", xlabel=L"\lg(k)",
        ylabel=rendlab,
        xmajorgrids, ymajorgrids})
    @pgf push!(p, PlotInc(Table([seirset[:kexps], seirset_cends(seirset[:seirs_s], :rt)])),
        LegendEntry("mottaglighet"))
    @pgf push!(p, PlotInc(Table([seirset[:kexps], seirset_cends(seirset[:seirs_c], :rt)])),
        LegendEntry("kontakt"))
    p
end
