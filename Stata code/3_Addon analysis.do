use "$Data/2_Addon Demog_AlcoholPilot_clean.dta", clear

*1)	Identify the most discouraging "causal language" 
*2)	Identify the most discouraging behavioral variant
*3)	Identify the most discouraging color

//sort in excel
//using descriptive table command

foreach var in causalpme behaviorpme colorpme{
		
dtable i.`var', by(design_topic)
putexcel set "$Results/3_Add-on Design Results.xlsx", sheet ("`var'") modify
putexcel A2 = collect

}

*Prop displays Standard Error and 95%CI - used for plot
foreach var in causalpme behaviorpme colorpme{
prop `var' 
matrix b = r(table)'
matrix list b
putexcel set "$Results/3_Add-on Design Results with SE.xlsx", sheet("`var'") modify
putexcel A2 = ("Prop `var' ")
putexcel A4 = matrix(b), names nformat(number_d2)

if "`var'"=="causalpme"{
	putexcel D2 = ("1 increases risk of, 2 contributes to, 3 leads to, 4 can contribute to, 5 causes")
}
	
if "`var'"=="behaviorpme"{
	putexcel D2 = ("1 drinking alcohol, 2 alcohol consumption, 3 alcohol use, 4 consuming alcohol, 5 alcohol")
}
	
if "`var'"=="colorpme"{
	putexcel D2 = ("1 black, 2 red, 3 white, 4 yellow")
}

}


