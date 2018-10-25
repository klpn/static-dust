---
tags: epidemiologi
title: Cirkulera runt igen
author: Karl Pettersson
lang: sv
---

[Den 31 augusti förra året](2017-08-31-gubbarna.html) skrev jag om hur
könsskillnader i andelen dödsfall med olika delmängder av cirkulationssjukdomar
som underliggande dödsorsak förändrats över tid i USA. I mitten av 1900-talet
var andelarna relativt lika mellan könen för hela gruppen, och större för män
för vissa undergrupper, som kranskärlssjukdom. Senare minskade kvoterna mellan
mäns och kvinnors andelar och blev under 1 för flera grupper. Från mitten av
1990-talet har dock pendeln svängt tillbaka i andra riktningen. Jag tänkte mig
att den sistnämnde trenden kunde förklaras av att benägenheten att rapportera
cirkulationssjukdom som dödsorsak bland äldre minskat framför allt till förmån
för demens, vilket fått störst genomslag bland kvinnor.

I Sverige har det också under lång tid varit så att andelen dödsfall som
tillskrivits någon form av cirkulationssjukdom varit något större bland kvinnor
än bland män (ett sådant mönster fanns redan i den första rikstäckande
statistiken, för 1911 [@scbdor11]), även om andelen för kranskärlssjukdom varit
större bland män. Nu har statistik över dödsorsakerna i Sverige 2017
offentliggjorts [@sosdorstat]. Socialstyrelsen har API och CSV-tabeller för sin
statistikdatabas, men som för tidigare år gäller att statistiken med koder på
fjärdepositionsnivå i ICD-10 och 90-- år (i stället för bara 85-- år) som
översta åldersintervall bara är tillgänglig i ett Excelark (innan den
publiceras via @whomort). Genom att klona [denna bloggs
Githubförråd](https://github.com/klpn/static-dust/) och köra skriptet
`sedor.sh` i underkatalogen `postdata/2018-10-25-cirkulera` kan detta ark och
en fil med medelfolkmängden i Sverige 2017 från @scbmf omvandlas till en form
som går att läsa in och bearbeta i Julia för beräkningar av andelen dödsfall
och dödstal för valfria dödsorsaksgrupper med `sedor.jl` (lätt modifierad form
av det jag beskrev [den 8 september förra året](2017-09-08-forbi.html)).
Exempelvis kan en tabell med andel kvinnor med akut hjärtinfarkt (ICD-10
I21) som dödsorsak tas fram genom att köra följande.

``` {.julia .numberLines}
include("sedor.jl")
miframe_allkv = propframe("Kv", "I21")
miframe_allkv[:frame]
```

Av denna statistik framgår att andelen för kapitlet för cirkulationssjukdom
(ICD-10 I00--I99) inte längre är högre för kvinnor: den är 33,7 procent såväl
bland kvinnor som bland män. Även här kan det sättas i relation till en ökad
tendens att rapportera demens och neurodegenerativa sjukdomar som dödsorsak.
Med den definition som jag använder i
[Mortalitetsdiagram](https://mortchart.klpn.se) (ICD-10 F01--F09, G10--G37)
stod dessa tillstånd för 14,5 procent av dödsfallen bland kvinnor och 8,9
procent bland män. Här finns en tydlig svårighet med avgränsningen mot
cirkulationssjukdom: de flesta svenskar som dör efter att ha fått en
demensdiagnos har också cirkulationssjukdom rapporterad åtminstone som
bidragande orsak [@JGS:JGS14421]. En undergrupp av demenstillstånden utgörs av
vaskulär demens (ICD-10 F01), som i definitionen explicit hänvisar till
kärlsjukdom som orsak till kognitiv försämring. I Mortalitetsdiagram har jag
räknat in denna kod i cirkulationssjukdomarna. Om cirkulationssjukdom
definieras på det sättet (ICD-10 I00-I99+F01) blir det åter en marginellt
vanligare dödsorsak bland kvinnor (35,5 procent av alla dödsfall) än bland män
(35,0 procent).

[Den 30 april
2013](http://diversepedanteri.blogspot.com/2013/04/forkalkningens-atertag.html)
om att det framför allt är diagnoser relaterade till åderförkalkning som blivit
mindre populära att rapportera som dödsorsaker bland äldre. För vissa sådana
diagnoser framträder trenden med en ökning av kvoten mellan mäns och kvinnors
andelar speciellt tydligt. Ett exempel är det som kallas "aterosklerotisk
hjärtsjukdom" (ICD-10 I25.1). År 1997 (det första året med ICD-10) var detta
underliggande dödsorsak för 5,9 procent av kvinnorna och 6,0 procent av männen
(data tillgängliga via @whomort). År 2017 hade dessa andelar minskat till 1,3
och 2,4 procent. Utöver denna minskning har åldersfördelningen bland de döda
med den diagnosen förändrats: 1997 var 61,0 procent av kvinnorna och 30,2
procent av männen 85 år eller äldre, men 2017 hade dessa andelar minskat till
51,3 och 21,9 procent. Det är en ovanlig förändring när dödligheten generellt
förskjuts högre upp i åldrarna. En rimlig förklaring kan vara att diagnosen
allt mindre ofta kommit att fungera som standardval för äldre personer utan
någon uppenbar entydig dödsorsak och i stället använts för något yngre personer
med tydlig evidens för komplikationer till ateroskleros i kranskärlen, bland
vilka det finns en manlig överrepresentation.

## Referenser
