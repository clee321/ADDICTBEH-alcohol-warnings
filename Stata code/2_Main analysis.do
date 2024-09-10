use "$Data/2_Main_AlcoholPilot_long.dta", clear

cd "$Results"

**# PME Analysis: 

*1) LMER - pme for each topic x control
mixed pme ib21.topic || pid:

//doesn't export labels to Excel
quietly{
matrix a = r(table)'
matrix list a
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("1.1) PME-LMER") modify
putexcel A1 = "`e(cmdline)'"
putexcel A3 = matrix(a), names nformat(number_d2)
putexcel M1 = "1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
}

//Export to word doc with labels
asdoc mixed pme ib21.topic || pid:, replace label dec(3) save(1.1_Results LMER_PME with topic labels.doc)


*2) Rank *topics* on pme (estimated mean)
margins i.topic
//sort on excel

quietly{
matrix b = r(table)'
matrix list b
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("1.2) PME Topic-rank") modify
putexcel A1 = "PME) Margins by TOPIC_estimated mean"
putexcel A3= matrix(b), names nformat(number_d2)
putexcel M1 = "Topic #s: 1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
}

asdoc margins i.topic, replace label dec(3) save(1.2_Results LMER_Margins PME with topic labels.doc)


*3) Rank *messages* on pme (estimated mean)
mixed pme i.msg || pid:
margins i.msg
//sort on excel

quietly{
matrix c = r(table)'
matrix list c
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("1.3) PME Msg-rank") modify
putexcel A1 = "PME) Margins by MSG_estimated mean"
putexcel A3= matrix(c), names nformat(number_d2)
putexcel M1 = "Msg #s: 1 mouth cancer1 | 2 mouth cancer2 | 3 liver cancer1 | 4 liver cancer2 | 5 hypertension1 | 6 hypertension2 | 7 road injuries1 | 8 road injuries2 | 9 sleep1 | 10 sleep2 | 11 throat cancer1 | 12 throat cancer2 | 13 colorectal cancer1 | 14 colorectal cancer2 | 15 generic cancer1 | 16 generic cancer2 | 17 fetal harms1 | 18 fetal harms2 | 19 sleep3 | 20 sleep4 | 21 larynx cancer1 | 22 larynx cancer2 | 23 breast cancer1 | 24 breast cancer2 | 25 dementia1 | 26 dementia2 | 27 liver disease1 | 28 liver disease2 | 29 guidelines1 | 30 guidelines2 | 31 esophageal cancer1 | 32 esophageal cancer2 | 33 generic cancer3 | 34 generic cancer4 | 35 hypertension3 | 36 hypertension4 | 37 liver disease3 | 38 liver disease4 | 39 addiction1 | 40 addiction2 | 41 control1 | 42 control2"
}

asdoc margins i.msg, replace label dec(3) save(1.3_Results LMER_Margins PME with MSG labels.doc)


****************

**# Reactance Analysis:

*1) LMER - react for each topic x control
mixed react ib21.topic || pid:

//doesn't export labels
quietly{
matrix a = r(table)'
matrix list a
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("2.1) React-LMER") modify
putexcel A1 = "`e(cmdline)'"
putexcel A3 = matrix(a), names nformat(number_d2)
putexcel M1 = "1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
}

//Export to doc with labels
asdoc mixed react ib21.topic || pid:, replace label dec(3) save(2.1_Results LMER_React with topic labels.doc)

*2) Rank *topics* on react (estimated mean)
margins i.topic
//sort on excel

quietly{
matrix b = r(table)'
matrix list b
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("2.2) React Topic-rank") modify
putexcel A1 = "Reactance) Margins by TOPIC_estimated mean"
putexcel A3= matrix(b), names nformat(number_d2)
putexcel M1 = "Topic #s: 1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
}

asdoc margins i.topic, replace label dec(3) save(2.2_Results LMER_Margins React with topic labels.doc)

*3) Rank *messages* on react (estimated mean)
mixed react i.msg || pid:
margins i.msg

quietly{
matrix c = r(table)'
matrix list c
putexcel set "$Results/Results_LMER and ranking.xlsx", sheet("2.3) React Msg-rank") modify
putexcel A1 = "Reactance) Margins by MSG_estimated mean"
putexcel A3= matrix(c), names nformat(number_d2)
putexcel M1 = "Msg #s: 1 mouth cancer1 | 2 mouth cancer2 | 3 liver cancer1 | 4 liver cancer2 | 5 hypertension1 | 6 hypertension2 | 7 road injuries1 | 8 road injuries2 | 9 sleep1 | 10 sleep2 | 11 throat cancer1 | 12 throat cancer2 | 13 colorectal cancer1 | 14 colorectal cancer2 | 15 generic cancer1 | 16 generic cancer2 | 17 fetal harms1 | 18 fetal harms2 | 19 sleep3 | 20 sleep4 | 21 larynx cancer1 | 22 larynx cancer2 | 23 breast cancer1 | 24 breast cancer2 | 25 dementia1 | 26 dementia2 | 27 liver disease1 | 28 liver disease2 | 29 guidelines1 | 30 guidelines2 | 31 esophageal cancer1 | 32 esophageal cancer2 | 33 generic cancer3 | 34 generic cancer4 | 35 hypertension3 | 36 hypertension4 | 37 liver disease3 | 38 liver disease4 | 39 addiction1 | 40 addiction2 | 41 control1 | 42 control2"
}

asdoc margins i.msg, replace label dec(3) save(2.3_Results LMER_Margins React with MSG labels.doc)


//////////
//////////

**#Supplemental Table 3. PME and reactace by message topic, by gender

tab gendercat
tab gendercat, nolabel
*gendercat == 1 (woman)
*gendercat == 2 (man)


*Filter by gender
**# PME Analysis by gender: 
forval f=1/2 {
	
*1) LMER - pme for each topic x control
mixed pme ib21.topic if gendercat==`f'|| pid: 

//doesn't export labels
quietly{
matrix a = r(table)'
matrix list a
putexcel set "$Results/Supp3_Results_LMER and ranking_gender.xlsx", sheet("1.G`f') PME B-LMER") modify
putexcel A1 = "`e(cmdline)'"
putexcel A3 = matrix(a), names nformat(number_d2)
putexcel M1 = "1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
putexcel L1 = "gender: 1 women | 2 men"
}

//Export to word doc with labels
asdoc mixed pme ib21.topic if gendercat==`f'|| pid:, replace label dec(3) save(Supp3_1.1.G`f'_Results LMER_PME with topic labels_gender.doc)


*2) Rank *topics* on pme (estimated mean)
margins i.topic
//sort on excel

quietly{
matrix b = r(table)'
matrix list b
putexcel set "$Results/Supp3_Results_LMER and ranking_gender.xlsx", sheet("1.G`f') PME Margins-Topic") modify
putexcel A1 = "PME) Margins by TOPIC_estimated mean"
putexcel A3= matrix(b), names nformat(number_d2)
putexcel M1 = "Topic #s: 1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
putexcel L1 = "gender: 1 women | 2 men"
}

asdoc margins i.topic, replace label dec(3) save(Supp3_1.2.G`f'_Results LMER_Margins PME with topic labels_gender.doc)
}

**# Reactance Analysis by gender:

forval f=1/2 {
*1) LMER - react for each topic x control
mixed react ib21.topic if gendercat==`f'|| pid:

//doesn't export labels
quietly{
matrix a = r(table)'
matrix list a
putexcel set "$Results/Supp3_Results_LMER and ranking_gender.xlsx", sheet("2.G`f') React B-LMER") modify
putexcel A1 = "`e(cmdline)'"
putexcel A3 = matrix(a), names nformat(number_d2)
putexcel M1 = "1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
putexcel L1 = "gender: 1 women | 2 men"
}

//Export to doc with labels
asdoc mixed react ib21.topic if gendercat==`f'|| pid:, replace label dec(3) save(Supp3_2.1.G`f'_Results LMER_React with topic labels_gender.doc)

*2) Rank *topics* on react (estimated mean)
margins i.topic
//sort on excel

quietly{
matrix b = r(table)'
matrix list b
putexcel set "$Results/Supp3_Results_LMER and ranking_gender.xlsx", sheet("2.G`f') React Margins-Topic") modify
putexcel A1 = "Reactance) Margins by TOPIC_estimated mean"
putexcel A3= matrix(b), names nformat(number_d2)
putexcel M1 = "Topic #s: 1 mouth cancer | 2 liver cancer | 3 hypertension | 4 road injuries | 5 sleep | 6 throat cancer | 7 colorectal cancer | 8 generic cancer | 9 fetal harms | 11 larynx cancer | 12 breast cancer | 13 dementia | 14 liver disease | 15 guidelines | 16 esophageal cancer | 20 addiction | 21 control"
putexcel L1 = "gender: 1 women | 2 men"
}

asdoc margins i.topic, replace label dec(3) save(Supp3_2.2.G`f'_Results LMER_Margins React with topic labels_gender.doc)

}
