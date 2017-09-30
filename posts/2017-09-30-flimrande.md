---
tags: epidemiologi
title: Flimrande månad
author: Karl Pettersson
lang: sv
---

För några dagar sedan publicerade en bloggande amerikansk kardiolog ett inlägg
om hur han fått e-post om att september tydligen är "atrial fibrillation
awareness month" med informationsgrafik, som han kunde få använda om han brydde
sig om folk med förmaksflimmer [@pearson170928]. Han säger sig bry sig om folk
som lever med nästan vilken hjärtsjukdom som helst, möjligen med undantag av
Schuckenbuss syndrom^[I kommentarsfältet förklarar han att han googlat
"Schuckenbuss syndrome" innan han skrev inlägget utan att få några träffar,
även om det nu ger träffar som pekar på just hans inlägg.], varefter han
redovisar den aktuella grafiken. Den innehåller siffror om att antalet med
förmaksflimmer i USA är lika med Chicagos befolkning, att det kostar 6
miljarder dollar per år (är det inklusive immateriella kostnader för QALY?),
att det bidrar till 130\ 000 dödsfall per år, att livstidsrisken är en
fjärdedel, att fler kvinnor än män drabbas till följd av högre livslängd och så
vidare, och den slutar med reklam för diverse hälsoappar från företaget där
meddelandets avsändare är anställd.

I grafiken förekommer formuleringar som "battling atrial fibrillation in the
USA" på ett blad prytt med vimplar med stjärnor och ränder. Det har
diskuterats hur retoriken med "kamp" mot sjukdomar framför allt har förekommit 
i sambnad med cancer, som jag skrev om [den 7 oktober
2015](http://klpn.se/2015/10/07/sjuk-kultur/), men här föreligger alltså ett
exempel på hur den utvidgats till andra sjukdomar. 

När det gäller valet av månad hade den amerikanska senaten utnämnt september
2009 till "National Atrial Fibrillation Awareness Month", vilket tolkats som
att september för alltid är förmaksflimrets månad. Om september är
förmaksflimrets månad innebär det också att den föregår bröstcancerns månad.
Vore det passande att anamma även i Sverige? Enligt den svenska statistiken för
2016, tillgänglig via @sosdorstat16, var förmaksflimmer underliggande dödsorsak
bland 3,5 procent av kvinnorna och 2,6 procent av männen. Det innebär att
förmaksflimmer är 18 procent vanligare än bröstcancer som underliggande
dödsorsak bland kvinnor.

De senaste åren har förmaksflimmer blivit vanligare som underliggande dödsorsak
i exempelvis Sverige. Sannolikt beror det till stor del på ökad benägenhet att
rapportera förmaksflimmer som orsak till slaganfall. Det är ett exempel på
svårigheten att avgränsa sjukdomar som inlett ett sjukdomsförloppp, och då
skall rapporteras som underliggande dödsorsaker, från riskfaktorer. Normalt
rapporteras inte sådant som rökning, högt blodtryck eller stress som
underliggande dödsorsaker om någon dör av kranskärlssjukdom eller slaganfall,
även om det finns ICD-koder för dessa faktorer. Diabetes är ett tillstånd som i
detta avseende behandlats olika i olika befolkningar och tidsperioder, vilket
försvårar jämförelser av statistik över sjukdomsgrupperna. Så är det
förmodligen också med förmaksflimmer.

När förmaksflimmer oftare rapporteras som orsak till slaganfall får det till
följd att andelen dödsfall med slaganfall som underliggande dödsorsak minskar.
Som visas av
[Mortalitetsdiagram](http://mortchart.klpn.se/charts/strall4290s1e1meanfalse.html)
var denna andel ganska stabil i Sverige från slutet av 1960-talet fram till
början av 2000-talet, varefter den minskat. Förutom varierande benägenhet att
rapportera riskfaktorer, som diabetes eller förmaksflimmer, som underliggande
orsak, finns fler komplikationer vid rapportering av tidstrender i slaganfall.
Om slaganfall och demens rapporteras tillsammans, kan det hända att vaskulär
demens (ICD-10 F01) blir underliggande dödsorsak, så att dödsfallet alltså
hamnar i kapitlet för psykiska störningar, i stället för sjukdomar i
cirkulationsorganen. Därför har jag inkluderat denna kod i de definitioner av
slaganfall och cirkulationssjukdom som används för Mortalitetsdiagram (se
[dokumentationen](http://mortchart.klpn.se/mortchartdoc.html#cirkulation)),
även om det innebär en svag artificiell ökning vid övergången till ICD-10 (för
tidigare ICD-versioner finns inte statistik på en sådan detaljnivå tillgänglig
via @whomort). Jag testade att skapa en utvidgad sjukdomsgrupp, som för ICD-10
inkluderar förmaksflimmer (ICD-10 I48) förutom koderna för slaganfall, vilket
inte heller är möjligt för tillgängliga data med äldre ICD-versioner. Ett
diagram för utvecklingen av andelen dödsfall för denna orsaksgrupp i Sverige
kan skapas med följande kod:

``` {.julia .numberLines}
import Mortchartgen
frames = Mortchartgen.load_frames()
Mortchartgen.propplot_sexesyrs("straf", "all", [2;1], 4290, 1, 1,
1951:2015, false, frames, "sv", Mortchartgen.tmpoutpath, false)
```

Som väntat visar det skapade diagrammet ett större hopp vid övergången till
ICD-10 1997, jämfört med diagrammet baserat på den snävare definitionen av
slaganfall, men mindre förändringar för åren efter 2000.

![Andelen dödsfall i slaganfall och förmaksflimmer Sverige
1951--2015.](../images/Sv5115AndelStrAf.svg){width="100%" height="100%"}

## Referenser
