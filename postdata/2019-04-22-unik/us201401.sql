select
Resstatus,Edu89,Edu03,Edurep,Dmon,Sex,
Agetype,Age,Agesubst,AgeRe52,AgeRe27,AgeRe12,
InfAgeRe22,Dplace,Mart,Dweek,Datayear,Injwork,
Dmanner,Disp,Autopsy,Actcode,Injplace,UcIcd,UcRe358,
UcRe113,UcReInf130,UcRe39,EntNr,
concat(Ent1,Ent2,Ent3,Ent4,Ent5,Ent6,Ent7,Ent8,Ent9,
Ent10,Ent11,Ent12,Ent13,Ent14,Ent15,Ent16,Ent17,
Ent18,Ent19,Ent20) as Ent,
RecNr,Rec1,Rec2,Rec3,Rec4,Rec5,Rec6,Rec7,Rec8,Rec9,
Rec10,Rec11,Rec12,Rec13,Rec14,Rec15,Rec16,Rec17,
Rec18,Rec19,Rec20,Race,Bridged,Impute,RaceRe3,RaceRe5,
Hisp,HispRaceRe
into outfile 'us201401.csv' fields terminated by ','
lines terminated by '\n' from Usdeaths
where Datayear=2014 and Dmon=1;
