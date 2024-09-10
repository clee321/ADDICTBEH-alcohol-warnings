use "$Data/2_Addon Demog_AlcoholPilot_clean.dta", clear

*Separate columns for n and %
global varlist "agecat gendercat sexualorientcat racecat educcat income4cat fplcat alcdaysdrankcat alctimesbingecat currentwarninguse"

putexcel set "$Results/Table 1.xlsx", modify

	local row=2
	foreach var in $varlist {

		tabulate `var', matcell(`var'freq) matrow(`var'names)
			putexcel A`row'="`var'"
			local ++row
			putexcel A`row'= matrix(`var'names) 
			putexcel B`row'=matrix(`var'freq) 
			putexcel C`row'=matrix(`var'freq/r(N)), nformat(percent) 
		
			local rows = rowsof(`var'names)
			forval i=1/`rows'   {
				local val = `var'names[`i',1]
				local val_lab : label (`var') `val'
				putexcel A`row'=("`val_lab'")
				local ++row
				display "row is `row'"
			}
	 }


mdesc *cat

mdesc currentwarninguse
