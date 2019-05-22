---
tags: epidemiologi
title: Fler ingredienser
author: Karl Pettersson
lang: sv
---

I förra inlägget skrev jag om nya uppskattningar, enligt vilka ca 7
procent av alla dödsfall i Sverige skulle förklaras av kostvanor i
strid med gällande näringsrekommendationer [@ijerph16050890]. Det är
förstås inte de enda beräkningar av den typen som gjorts. I Global
burden of disease (GBD) ingår också uppskattningar av olika riskfaktors
bidrag till dödligheten: de senaste resultaten, som omfattar perioden
1990--2017, och metodologin för dessa finns redovisade i
@gbd2017risk195 och är också tillgängliga via @gbdresults. De är också
litet mer ambitiösa: det sägs att 18,35 procent av all dödlighet i
Sverige 2017 kan tillskrivas dietära risker. Det finns flera skäl till
att det uppstår ens sådan diskrepans, trots att det är färska studier
som utgår från till stor del likartade källor.

* GBD räknar med fler kategorier av dietära risker, som låg konsumtion
av baljväxter, nötter och omega-3 från marina källor och hög konsumtion
av processat kött och sötade drycker.

* Det ideala kostmönstret enligt @ijerph16050890 bestäms, som sagt, av
näringsrekommendationerna, men GBD utgår från en "theoretical minimum
risk-exposure level" (TMREL), som kan vara lägre. TMREL för olika
riskfaktorer är ofta satta till nivåer som @gbd2017risk195 själva medger
inte är realistiska med metoder tillgängliga idag, som ett blodtryck på
110--115 mm genom hela livet.^[En artificiell intelligens som fick till
uppgift att minimera vår risk för sjuklighet och dödlighet kanske skulle
betrakta hela kroppen som en uppsättning riskfaktorer att eliminera och
ge oss en tillvaro som huvudfiguren i @Jersild1980, eller försöka överföra
oss till digital form snarast möjligt.]

* En stor del av den dödlighet som tillskrivs kosten i båda studierna
beror på kranskärlssjukdom. Men den faktiska dödligheten i denna orsak har
uppskattats på litet olika sätt. @ijerph16050890 har utgått från antalet
dödsfall i officiell statistik med kranskärlssjukdom (ICD-10 I20--I25) som
underliggande dödsorsak. GBD ägnar sig åt omfördelning av "skräpkoder"
(exempelvis för hjärtsvikt) till väldefinierade orsaker, som
kranskärlssjukdom, vilket gör att andelen dödsfall som tillskrivs dessa
blir högre. Det finns en risk att detta leder till överskattning av
effekterna av riskfaktorer på kranskärlssjukdom, speciellt i högre
åldersgrupper, där det redan från början finns problem med validiteten
hos underliggande dödsorsaker och olika riskfaktorers betydelse ofta är
dåligt studerad.

Jag har skrivit tidigare, t.ex.\ [den 12 juli](2018-07-12-ominte.html)
och [21 juli 2018](2018-07-21-enkel.html), om problem med att
tillskriva minskade dödstal i kranskärlssjukdom förändringar i
riskfaktorer, där jag använt mig av GBD-data över riskfaktornivåer. Nu
finns som sagt GBD-uppskattningar av de andelar av exempelvis
dödligheten i kranskärlssjukdom som kan tillskrivas olika riskfaktorer
tillgängliga för åren 1990--2017, och de kan i sig användas för att
göra sådana uppskattningar.

Låt $\paf_{c,r,p}$ vara den andel dödsfall i en orsak $c$ som
tillskrivs en riskfaktor eller ett kluster av riskfaktorer, $r$, i en
befolkning $p$. I så fall ger $1-\paf_{c,r,p}$ ett relativt dödstal i
$c$ (med dödstalet i $c$ i $p$ som baslinje) för en befolkning $p_{r0}$ som är
ideal (enligt definierad TMREL) när det gäller exponeringen för $r$
(det vill säga, $\paf_{c,r,p_{r0}}=0$). Detta kan generaliseras så att
relativa dödstal mellan två befolkningar, $p_1$ och $p_2$, kan beräknas enligt:
$$\rr_{c,p1,p2}=\frac{1-\paf_{c,r,p_1}}{1-\paf_{c,r,p_2}}$$

Denna metod kan användas för att beräkna exempelvis de förändringar i
dödstal i kranskärlssjukdom som skulle förväntas från ett år till
annat i Sverige givet de förändringar i olika riskfaktorer som ägt rum
och jämföra dessa med de faktiska förändringarna. Beräkningarna i GBD
innehåller uppskattningar av hur de olika riskfaktorerna samverkar,
som att kostfaktorer påverkar kranskärlssjukdom via olika metabola
faktorer som blodsocker och blodtryck, och är därmed tänkta att
kunna användas för att uppskatta $\paf$ för vilka som helst
kombinationer av riskfaktorer.

Enligt GBD förklarar totala summan av riskfaktorer 97,97 procent av all
dödlighet i kranskärlssjukdom i åldersgruppen 50--69 år i Sverige
1990. Motsvarande andel för 2017 är 97,12 procent. Därmed ges den
den förväntade förändringen i dödstal från 1990 till 2017 av:

$$\frac{1-0{,}9797}{1-0{,}9712}\approx 0{,}7049$$

Förändringen i riskfaktorer förutsäger alltså en minskning av
dödstalen med knappt 30 procent, förutsatt att de relativa effekterna
av riskfaktorer på kranskärlsdödlighet hålls konstanta.^[Motsvarande
antagande skulle inte vara giltigt om vi exempelvis studerade effekten
av kostförändringar på total dödlighet. Andelen dödsfall som tillskrivs
kosten i åldersgruppen 50--69 år har minskat från 30,26 procent 1990
till 17,98 procent 2017. Men det beror till stor del på att den relativa
effekten av kosten minskat genom att andelen dödsfall i orsaker som antas
vara starkt kostrelarerade (som kranskärlssjukdom) minskat, till största
delen som sagt beroende på annat än kosten.] Den faktiska
minskningen av kranskärlsdödlighet under perioden är ca 70 procent, så
drygt 40 procent av den kan sägas förklaras av minskningar av kända
riskfaktorer. Men här finns den tvetydighet som jag diskuterade i
inläggen förra sommaren. Om vi byter plats på täljaren och nämnaren,
förutsäger en återgång till 1990 års nivåer en ökning av dödstalen på
drygt 40 procent, vilket bara är drygt en sjättedel av den faktiska
överdödligheten 1990, relativt 2017.

Vilka riskfaktorer är det som drivit förändringarna? Minskad rökning,
inklusive passiv rökning, förutsäger en minskning på 18 procent i
åldersgruppen 50--69 år. Den effekten är större bland män (19 procent)
än bland kvinnor (14 procent). Förändringar i kosten förutsäger en
minskning på 9 procent. Här finns både positiva förändringar (mer
frukt, grönt och omega-3) och negativa (mer sötade drycker och
processat kött). Förändringar i balansen av fleromättade fetter
(mättat fett ingår inte som oberoende faktor) och salt verkar ha haft
marginella effekter. Inte heller förändringar av fysisk inaktivitet
har haft några större effekter. Effekterna av sådant som kost och
fysisk aktivitet på kranskärlssjukdom förmedlas i modellerna till stor
del genom metabola faktorer, som BMI, blodsocker, blodtryck och
LDL-kolesterol. Förändringar i denna grupp som helhet förutsäger
minskningar av dödligheten på 10 procent, och det finns både
gynnsamma förändringar (LDL, blodtryck) och ogynnsamma
(BMI, blodsocker).

## Referenser
