
*Analysis Parent File

*Replace xxx with your Stata username
	*If you forgot your username, use the following command: [display "`c(username)'"] 
*Replace yyy with the applicable folder location

*User file paths
if "`c(username)'" =="xxx" {
	global Data 	"/yyy/Project folders-files/Data"
	global Results  "/yyy/Project folders-files/Results"
	global Code 	"/yyy/ADDICTBEH-alcohol-warnings/Stata code"
}

*************
*Run the codes below:

*Data cleaning and preparation
run "$Code/1_Data prep.do"
run "$Code/2_Main analysis.do"
run "$Code/3_Addon analysis.do"
run "$Code/4_Table 1.do"
