---
tags: epidemiologi
title: Reserverna tar slut
author: Karl Pettersson
lang: sv
---

I förra inlägget skrev jag om aktuell forskning kring slumpmässiga mutationer
och cancer och berörde då hypotesen att cancer orsakas av en ackumulering av
mutationer över tid. Detta har åtminstone sedan 1950-talet anförts som
förklaring till att incidens och mortalitet i cancer ökar med stigande ålder
[@Nordling53]. Sambandet mellan ålder och cancer är dock komplext, genom att
incidensen planar ut i de högsta åldersgrupperna.

@Gavrilov01 presenterar en generell modell för åldrande, som kanske kan vara
relevant i detta sammanhang, även om den specifika kopplingen till cancer och
mutationer inte görs i artikeln. Modellen går ut på att åldrande, i bemärkelsen ökad
mortalitet (eller felfrekvens i allmänhet: modellen gäller även icke-levande
system, som tekniska apparater) med stigande ålder, kan förklaras av att system
är sammansatta av block med redundanta komponenter, där systemet fallerar först
när alla komponenter i ett block gjort det. De individuella komponenternas
felfrekvens (hazardtal) $k$ kan vara helt oberoende av ålder och följa en
exponentialfördelning, så att andelen komponenter som håller till åldern $x$
ges av
$S(x)=\exp(-kx)$. Sannolikheten att inte alla komponenter i ett block med $n$
komponenter kraschat före $x$, är då andelen block som överlever till $x$:
$$S_b(n,k,x)=1-(1-\exp(-kx))^n$$
Täthetsfunktionen för blockens livslängd ges
av motsvarande funktion för händelsen att den sista funktionella komponenten
fallerar: $$f_b(n,k,x)=nk\exp(-kx)(1-\exp(-kx))^{n-1}$$ 
Genom att denna normaliseras till överlevnadsfunktionen fås hazardfunktionen för block.
Systemets hazardtal är summan av hazardtalen för de individuella blocken.

Forskarparet visar sedan att om hazardfunktionen för block ser ut som
beskrivits ovan, kommer blockens felfrekvens först att öka enligt en
potensfunktion av åldern (alltså Weibullfunktionen), men sedan kommer ökningen
att plana ut och hazardtalet kommer att närma sig $k$. Det är en ganska
intuitiv idé: ju fler komponenter som fallerat i blocken, desto mer kommer
de att likna system utan redundans. Om detta överförs på mutationer och cancer 
skulle antalet komponenter kunna tänkas motsvara antalet mutationer nödvändiga
för att cancer skall uppstå. Först ökar incidensen och mortaliteten i cancer
med stigande ålder när mutationer ackumuleras. Vid en viss ålder har emellertid
en stor del av befolkningen så många mutationer att de bara har en mutation
kvar tills de drabbas av cancer, och då närmar sig cancerincidensen frekvensen
av enstaka mutationer, som kan vara oberoende av ålder. På så vis skulle det gå att
förklara utplaningen av cancerincidens vid hög ålder utan att anta att det har
att göra med snedvriden rapportering eller med selektiv överlevnad av personer
med skyddsfaktorer.

Hur passar deras funktion in på empiriska data över cancerincidens?
Nedanstående diagram visar incidens i alla cancerformer i Sverige i åldersintervall från
20--24 till 85-- år (baserat på data från @soscan) tillsammans med
förutsägelser 
som gjorts med icke-linjär regression där samma data passats mot den ovan
beskrivna hazardfunktionen. Jag har lagt till den i mitt
[LifeTable-paket](https://github.com/klpn/LifeTable.jl).

![Observerad cancerincidens Sverige 2015, tillsammans med förutsedd
cancerincidens utifrån hazardfunktionen för block hos @Gavrilov01. 
Kod i [gist](https://gist.github.com/klpn/d7c91ccbe64b0b937bdecf9c9661fe02#file-sexesplot-jl)
.](../images/Sv15IncAllcancObsvsPredGavr.svg)

Som synes passar funktionen ganska bra in på den observerade incidensen från 35
års ålder bland kvinnor och från 45 års ålder bland män. Den underskattar dock
incidens i yngre åldrar, men cancer bland unga vuxna utgörs till stor del av
sådant som sarkom och akut leukemi, som skiljer sig från de cancerformer som är
vanliga bland medelålders och äldre (och utgör den stora majoriteten av all
cancer).

@Gavrilov01 presenterar också mer komplicerade funktioner för fall där systemet
är sammansatt av block med initialt olika grad av redundans. Ett exempel på
detta, som de fokuserar på, är att system initialt har en rad defekter i olika
block, så att deras redundans följer en binomialfördelning. Om
så är fallet kommer systemets hazardtal först att öka exponentiellt med åldern
(Gompertzfunktionen) innan redundansen jämnar ut sig (de block som har hög redundans kan
göra större förluster av fungerande element) och funktionen övergår i en
Weibullfunktion, för att till slut plana ut när redundansen är uttömd, som
beskrivits ovan. De tänker sig att detta kan förklara att Gompertzfunktionen är
bättre på att beskriva sambandet mellan total mortalitet och mortalitet i
breda grupper av dödsorsaker och ålder, samtidigt som Weibullfunktionen är
bättre på att beskriva avgränsade dödsorsaker, något som observerats av
@Juckett19931. Weibullfunktionen är också bättre på att beskriva mortalitet hos
tekniska system, vilket de tänker sig skulle kunna förklaras av
att dessa inte på samma sätt som levande organismer innehåller en massa
felaktiga element från början.

Cirkulationsmortalitet är ett exempel på sådan mortalitet vars
ålderskurva inte passar bra in på en Weibullfunktion, som jag visade på [den 2
september 2015](http://klpn.se/2015/09/02/passar-sig-inte/). Som framgår av diagrammet
nedan, för Sverige 2014, baserat på data från @whomort, passar den dock ganska
bra (om än inte perfekt) in på Gompertzfunktionen.

![Observerad cirkulationsmortalitet (ICD-10 I00--I99 och F01) Sverige 2014, 
tillsammans med förutsedd mortaliet utifrån Gompertzfunktionen.
Kod i [gist](https://gist.github.com/klpn/d7c91ccbe64b0b937bdecf9c9661fe02#file-sexesplot-jl)
.](../images/Sv14MortCirkObssvsPredGomp.svg)

Utifrån den ovan beskrivna modellen skulle denna obrutna exponentiella ökning
alltså kunna förklaras av att sjukdomar i cirkulationsorgan är mer diffusa än
cancer i de meningen att de är sammansatta av en rad olika komponenter med
olika grad av redundans, som inte hinner jämnas ut under normal mänsklig
livslängd.

## Referenser
