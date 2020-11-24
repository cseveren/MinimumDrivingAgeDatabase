clear
set more off
cd "YOURPATHHERE\MinimumDrivingAgeDatabase\"

import excel using "source\USDOT\USDOT_All.xlsx", firstrow
sort State Year









gen year = 1980
tempfile dl_1980
save "`dl_1980'", replace
clear

import excel using "source\USDOT\USDOT_1982.xlsx", firstrow
gen year = 1982
tempfile dl_1982
save "`dl_1982'", replace
clear

import excel using "source\USDOT\USDOT_1984.xlsx", firstrow
gen year = 1984
tempfile dl_1984
save "`dl_1984'", replace
clear

import excel using "source\USDOT\USDOT_1986.xlsx", firstrow
gen year = 1986
tempfile dl_1986
save "`dl_1986'", replace
clear

import excel using "source\USDOT\USDOT_1988.xlsx", firstrow
gen year = 1988
tempfile dl_1988
save "`dl_1988'", replace
clear

import excel using "source\USDOT\USDOT_1994.xlsx", firstrow
gen year = 1994
tempfile dl_1994
save "`dl_1994'", replace
clear

import excel using "source\USDOT\USDOT_1996.xlsx", firstrow
gen year = 1996

append using "`dl_1994'"
append using "`dl_1988'"
append using "`dl_1986'"
append using "`dl_1984'"
append using "`dl_1982'"
, force
append using "`dl_1980'", force

rename L notes

order State Code year

sort Code year
