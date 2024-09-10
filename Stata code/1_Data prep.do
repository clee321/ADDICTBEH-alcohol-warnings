
*Data cleaning

use "$Data/Raw Data.dta", clear
count

*We will exclude participants who do not complete the survey or who complete the survey implausibly quickly (defined as <1/3 of the median completion time) [from Analysis Plan]

*Consent
tab consent
drop if consent==0 //no consent

*Completion progress
tab finished
tab progress
*Exclude those that did not complere survey
drop if progress!=100 
//there was one id that progress was 100 but was not marked as finished - we are keeping this record (responseid = R_1VrLI8B33BDFruy)
tab finished progress if responseid == "R_1VrLI8B33BDFruy"

*Dates
gen recordeddate_clean = ""
replace recordeddate_clean = substr(recordeddate,1,10)
tab recordeddate_clean

*Age
tab age
drop if age<21

*Survey Status
tab svy_status

*Completion time
sum durationinseconds, detail
scalar median = r(p50)
scalar cutoff = median/3
di cutoff
*213.33

*Exclusion of those who responded too fast
count if durationinseconds < 213.33
tab responseid if durationinseconds < 213.33
drop if durationinseconds < 213.33

*Check if there are duplicate ids
distinct responseid

*Create numeric id
gen pid = _n

*Replace -99 to missing
mvdecode *, mv(-99)

////

**#Demographics

*Age
*hist age

recode age (21/29 = 1) (30/44 = 2) (45/59 = 3) (60/100 = 4), generate(agecat)
label define agelabels 1 "21-29 years" 2 "30-44 years" 3 "45-59 years" 4 "60+ years"
label values agecat agelabels
tab agecat


*Gender
recode gender ("1" = 1) ("2" = 2) ("3" = 3) ("4" = 3), generate(gendercat)
label define genderlabels 1 "Woman" 2 "Man" 3 "Non-binary or self-described" 
label values gendercat genderlabels
tab gendercat

**Clean check text responses
gsort -gender_4_text
**Clean responses manually
replace gender=2 if responseid=="R_1ps78tIKilUQSWf"

*********

*Sexual Orientation
recode sexualorient ("1" = 1) ("2" = 2) ("3" = 2) ("4" = 4), generate(sexualorientcat)
label define sexualorientlabels 1 "Straight or Heterosexual" 2 "Gay or lesbian, bisexual" 4 "self-described"
label values sexualorientcat sexualorientlabels
tab sexualorientcat

**no need to re-categorize text responses

*********

*Race

/*From codebook:
race_1=American Indian or Alaska Native
race_2=Asian
race_3=Black or African American
**race_4=Hispanic, Latino, or Spanish
race_5=Middle Eastern or North African
race_6=Native Hawaiian or Other Pacific Islander
race_7=White
race_8=Another race or ethnicity 
*/

*Race responses in separate columns.

**Clean, check text responses
gsort -race_8_text

**Clean responses manually
replace race_1=1 if responseid=="R_7qqUrvPzENnTe0p"
replace race_4=1 if responseid=="R_6w63YJdyNRIcG6I"
replace race_4=1 if responseid=="R_6lzPMUpXLgvpbsB"
replace race_8=. if responseid=="R_6lzPMUpXLgvpbsB"
replace race_1=1 if responseid=="R_7d0GDNuupaq7dlG"
replace race_8=. if responseid=="R_7d0GDNuupaq7dlG"

*Count total races marked and replace those who marked more than 1 race as "other or multiracial"
	
	egen totalraces = rowtotal(race_1 race_2 race_3 race_4 race_5 race_6 race_7 race_8)

**Clean responses manually
replace totalraces=2 if responseid=="R_1ps78tIKilUQSWf"
replace totalraces=2 if responseid=="R_1pf4bC9Xa3zzY4A"
	
	gen racecat=.
		replace racecat = 1 if race_1==1 & totalraces==1 //AmInd only
		replace racecat = 2 if race_2==1 & totalraces==1 //Asian only
		replace racecat = 3 if race_3==1 & totalraces==1 //Black only
		replace racecat = 4 if race_4==1 & totalraces==1 //Hispanic only
		replace racecat = 5 if race_5==1 & totalraces==1 //Mid. Eastern only
		replace racecat = 6 if race_6==1 & totalraces==1 //Nat. Hawaiian or Pac. Islander
		replace racecat = 7 if race_7==1 & totalraces==1 //White only
		replace racecat = 8 if race_8==1 //Other
		replace racecat = 8 if totalraces>=2 & totalraces!=.

	label define racecatlabels 1 "Amer Ind AK Native" 2 "Asian" 3 "Black" 4 "Hispanic" 5 "Mid. Eastern" 6 "Nat. Hawaii or Pac. Islander" 7 "White" 8 "Other or multi-racial"
	label values racecat racecatlabels
		tab racecat

*********

*Education
recode educ ("1" =1) ("2"=1) ("3"=2) ("4"=3) ("5"=3) ("6"=4), generate(educcat)
label define educlabels 1 "High school diploma or less" 2 "Some college" 3 "College graduate or Associate's degree" 4 "Graduate degree"
label values educcat educlabels
tab educcat

*********

*Income
recode income_10cat (1/3 = 1) (4/5 = 2) (6 = 3) (7/10 = 4) , generate(income4cat)
label define incomelabels 1 "$0 to $24,999" 2 "$25,000 to $49,999" 3 "$50,000 to $74,999" 4 "$75,000 or more"
label values income4cat incomelabels
tab income4cat

*********

*FPL
gen fpl_all = .

forval f=1/20{
	replace fpl_all = fpl_`f' if hhsize_num == `f'
}

recode fpl_all (1=1) (2=1) (3=2) (4=2) (5=2), generate(fplcat)
label define fpllabels 1 "lower than 185%FPL" 2 "above 185%FPL"
label values fplcat fpllabels
tab fplcat

*********

*Frequency of drinking (v1_per week)
*tab alcdaysdrank

recode alcdaysdrank (3/5 = 3) , generate(alcdaysdrankcat)
label define alcdaysdranklabels 0 "Not at all" 1 "Less than 1 day per week" 2 "1-2 days per week" 3" 3-7 days per week"
label values alcdaysdrankcat alcdaysdranklabels
tab alcdaysdrankcat

*********

*Binge drinking
*tab alctimesbinge_female
*tab alctimesbinge_notfem

gen alctimesbingeall = .
replace alctimesbingeall=alctimesbinge_female if gender==1
replace alctimesbingeall=alctimesbinge_notfem if gender!=1

recode alctimesbingeall (1/30 = 1) , generate(alctimesbingecat)
label define alctimesbingelabels 0 "0 days" 1 "1 or more days"
label values alctimesbingecat alctimesbingelabels
tab alctimesbingecat

*********

*Current warning use

label define currentwarninguselabels 1 "Never" 2 "Rarely" 3 "Sometimes" 4 "Often" 5 "Every time" 6 " didn't see alcoholic container"
label values currentwarninguse currentwarninguselabels
tab currentwarninguse

save "$Data/1_All studies_AlcoholPilot_eligible.dta", replace
*Other add-on studies (e.g. Aline's) should start from this version.

/////////

**#Split datasets - they have different shapes

**Main study dataset (pme and react)

**Dataset with all variables
use "$Data/1_All studies_AlcoholPilot_eligible.dta", clear

drop causalpme_cancer-reasons_na_1

**Dataset with main variables
save "$Data/1_Main_AlcoholPilot_eligible.dta", replace

/////////

**Add-on and Demog dataset

use "$Data/1_All studies_AlcoholPilot_eligible.dta", clear

drop pme_set1_msg1-react_set4_msg42

**Dataset with add-on study variables (causal, behavior, color)
save "$Data/1_Addon Demog_AlcoholPilot_eligible.dta", replace

********************************

**#DATA RESHAPE
*Main Variables - Repeated (participants rate 12 warnings)

use "$Data/1_Main_AlcoholPilot_eligible.dta", clear

*Group control responses into 1 column each
*Participants only see 1 set (sets don't overlap)

foreach x in pme react{
	gen `x'41=.
	gen `x'42=.
}

foreach x in pme react{
	forval f=1/4{
		replace `x'41=`x'_set`f'_msg41 if set==`f'
		replace `x'42=`x'_set`f'_msg42 if set==`f'
	}
}

*Rename rest of columns
*Remove `set#' (won't need it for reshaping or analysis)

foreach y of numlist 1/10 {
	foreach x in pme react{
rename `x'_set1_msg`y' `x'`y'
}
}

foreach y of numlist 11/20 {
	foreach x in pme react{
rename `x'_set2_msg`y' `x'`y'
}
}

foreach y of numlist 21/30 {
	foreach x in pme react{
rename `x'_set3_msg`y' `x'`y'
}
}

foreach y of numlist 31/40 {
	foreach x in pme react{
rename `x'_set4_msg`y' `x'`y'
}
}

*Reshape dataset to long format on message #
reshape long pme react, i(pid) j(msg)

*Now, each pid have 42 rows (rows for each message number), but only 12 rows with data.
*Check if reshaped adequately - each set should show the right message #s.

forval f=1/4{
	di "Set`f'"
tab msg if pme!=. & set==`f'
}

tab msg if pme!=.

forval f=1/4{
	di "Set`f'"
tab msg if react!=. & set==`f'
}

tab msg if react!=.

*Removed the empty msg rows that were created for each pid (message #s that are not within the set participants saw)
drop if pme==. & react==.

forval f=1/4{
	di "Set`f'"
tab msg if set==`f'
distinct pid if set==`f'
}

*Create columns for topic
*Generate as integers
*Then label them

*The same topic number will be assigned to topics that repeat across different sets (e.g. hypertension is topic 3 and is in both set 1 and 4)

gen topic = .
	replace topic= 1 if msg==1
	replace topic= 1 if msg==2 //mouthcc - set1
	replace topic= 2 if msg==3
	replace topic= 2 if msg==4 //livercc
	replace topic= 3 if msg==5
	replace topic= 3 if msg==6 //hypertension1
	replace topic= 4 if msg==7
	replace topic= 4 if msg==8 //road injuries
	replace topic= 5 if msg==9
	replace topic= 5 if msg==10 //sleep1
	
	replace topic= 6 if msg==11
	replace topic= 6 if msg==12 //throatcc - set2
	replace topic= 7 if msg==13
	replace topic= 7 if msg==14 //colorectalcc
	replace topic= 8 if msg==15
	replace topic= 8 if msg==16 //genericcc1
	replace topic= 9 if msg==17
	replace topic= 9 if msg==18 //fetal harms
	replace topic= 5 if msg==19
	replace topic= 5 if msg==20 //sleep2
	
	replace topic= 11 if msg==21
	replace topic= 11 if msg==22 //larynxcc - set3
	replace topic= 12 if msg==23
	replace topic= 12 if msg==24 //breastcc
	replace topic= 13 if msg==25
	replace topic= 13 if msg==26 //dementia
	replace topic= 14 if msg==27
	replace topic= 14 if msg==28 //liver disease1
	replace topic= 15 if msg==29
	replace topic= 15 if msg==30 //guidelines
	
	replace topic= 16 if msg==31
	replace topic= 16 if msg==32 //esophagealcc - set4
	replace topic= 8 if msg==33
	replace topic= 8 if msg==34 //genericcc2
	replace topic= 3 if msg==35
	replace topic= 3 if msg==36 //hypertension2
	replace topic= 14 if msg==37
	replace topic= 14 if msg==38 //liver disease2
	replace topic= 20 if msg==39
	replace topic= 20 if msg==40 //addiction
	
	replace topic= 21 if msg==41
	replace topic= 21 if msg==42 //control - allsets
	
*Check if any missing values for topic
mdesc topic
tab topic

*Note: topic numbers below won't follow a perfect sequence - there will be some #s that will be skipped.

label define topiclab 1 "mouth cancer" 2 "liver cancer" 3 "hypertension" 4 "road injuries" 5 "sleep" 6 "throat cancer" 7 "colorectal cancer" 8 "generic cancer" 9 "fetal harms" 11 "larynx cancer" 12 "breast cancer" 13 "dementia" 14 "liver disease" 15 "guidelines" 16 "esophageal cancer" 20 "addiction" 21 "control"
label values topic topiclab
tab topic

*Label messages with initial words of the warning messages for easier identification
label define msglab 1 "mouth cancer1 1Drinking alcohol can cause" 2 "mouth cancer2 2Alcohol use increases " 3 "liver cancer1 3Alcohol use increases" 4 "liver cancer2 4Drinking alcohol can cause" 5 "hypertension1 5Alcohol consumption increases" 6 "hypertension2 6Drinking alcohol can cause" 7 "road injuries1 7Drinking alcohol and driving" 8 "road injuries2 8Consumption of alcoholic beverages impairs" 9 "sleep1 9Drinking alcohol can worsen " 10 "sleep2 10Alcohol use worsens" /// 
11 "throat cancer1 11Alcohol use can cause" 12 "throat cancer2 12Drinking alcohol increases" 13 "colorectal cancer1 13Alcohol use can cause" 14 "colorectal cancer2 14Drinking alcohol increases" 15 "generic cancer1 15There is a direct link" 16 "generic cancer2 16Drinking alcohol can cause" 17 "fetal harms1 17Alcohol use in pregnancy" 18 "fetal harms2 18Women should not drink" 19 "sleep3 19Drinking alcohol causes" 20 "sleep4 20Alcohol can disrupt your sleep" ///
21 "larynx cancer1 21Drinking alcohol can cause" 22 "larynx cancer2 22Alcohol use increases" 23 "breast cancer1 23Alcohol use can cause" 24 "breast cancer2 Drinking alcohol increases" 25 "dementia1 25Drinking alcohol increases" 26 "dementia2 26Alcohol consumption increases" 27 "liver disease1 27Alcohol consumption can cause" 28 "liver disease2 28Alcohol use increases" 29 "guidelines1 29To reduce health risks" 30 "guidelines2 30Have no more than" ///
31 "esophageal cancer1 31Drinking alcohol increases" 32 "esophageal cancer2 32Alcohol use can cause " 33 "generic cancer3 33Drinking all types of alcohol" 34 "generic cancer4 34Alcohol use increases" 35 "hypertension3 35Alcohol use contributes" 36 "hypertension4 36Alcohol consumption increases" 37 "liver disease3 37Alcohol consumption increases" 38 "liver disease4 38Drinking alcohol can cause" 39 "addiction1 39Alcohol use can cause" 40 "addiction2 40Alcohol is an addictive drug" ///
41 "control1 41This product is for individual use" 42 "control2 42Please recycle"
label values msg msglab
tab msg

save "$Data/2_Main_AlcoholPilot_long.dta", replace

********************************

**#ADD-ONS

use "$Data/1_Addon Demog_AlcoholPilot_eligible.dta", clear

*Group DESIGN outcomes
gen design_topic = ""
	replace design_topic = "cancer" if causalpme_cancer!=.
	replace design_topic = "bloodpr" if causalpme_bloodpr!=.
	replace design_topic = "liver" if causalpme_liver!=.
	

foreach var in causal behavior color{
gen `var'pme = .
	replace `var'pme = `var'pme_cancer if harm == "cancer"
	replace `var'pme = `var'pme_bloodpr if harm == "high blood pressure"
	replace `var'pme = `var'pme_liver if harm == "liver disease"

	mdesc `var'pme
}

*Label causalpme
label define causallabels 1 "increases risk of" 2 "contributes to" 3 "leads to" 4 "can contribute to" 5 "causes" 
label values causalpme causallabels

*Label behaviorpme
label define behaviorlabels 1 "drinking alcohol" 2 "alcohol consumption" 3 "alcohol use" 4 "consuming alcohol" 5 "alcohol" 
label values behaviorpme behaviorlabels

*Label behaviorpme
label define colorlabels 1 "black" 2 "red" 3 "white" 4 "yellow" 
label values colorpme colorlabels

/////

*Group COGTEST outcomes
gen cogtest_topic = .

foreach f of numlist 1/28 31/40  {
	replace cogtest_topic = `f' if cogtest`f'_1stthought!=""
}

gen cogtest_1stthoughtall = ""
gen cogtest_confuseall = ""

foreach var in 1stthought confuse {
foreach f of numlist 1/28 31/40 {
		replace cogtest_`var'all = cogtest`f'_`var' if cogtest_topic ==`f'
	}
}

save "$Data/2_Addon Demog_AlcoholPilot_clean.dta", replace
