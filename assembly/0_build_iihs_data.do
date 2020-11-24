clear
set more off
cd "YOURPATHHERE\MinimumDrivingAgeDatabase\"

** READ IN DATA AND PREP MAIN DATASET **
import 	excel using "source\IIHS\GDL history edited.xlsx", firstrow
gen 	Sub_space = strpos(SubIssue, " ")
gen 	Code = substr(SubIssue, 1, Sub_space-1)
destring Code, replace i(".")
drop 	Sub_space

gen 	year = year(EffectiveStart)
gen 	month = month(EffectiveStart)

tempfile masterdata
save 	"`masterdata'", replace

** Code 1: Learner Stage Minimum Entry **
keep if Code==1
gen 	LMA_years = substr(Summary, 1, 2)
gen 	hasmonths = strpos(Summary, "months")
gen 	LMA_months = substr(Summary, 4, 2) if hasmonths!=0

destring LMA_*, replace i(" ")
replace	LMA_months = 0 if LMA_months==.
drop 	Summary hasmonths

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c1_startdate = 0
replace c1_startdate = 1 if mindate==myr

keep 	State LMA_* year month c?_startdate
sort 	State year month

tempfile code1
save 	"`code1'", replace

** Code 2: Learner Stage Mandatory Holding Period **
use 	"`masterdata'"
keep if Code==2
keep if Alt==. | Alt==0
gen 	hasspace = strpos(Summary, " ")
gen 	LMA_minholdingmonths = substr(Summary, 1, hasspace-1)
destring LMA_minholdingmonths, replace i(" ")
drop 	Summary hasspace

keep 	State LMA_* year month
sort 	State year month

tempfile code2a
save 	"`code2a'", replace

** Code 2: Learner Stage Mandatory Holding Period (Alternate) **
use 	"`masterdata'"
keep if Code==2
keep if Alt==. | Alt==1
gen 	hasspace = strpos(Summary, " ")
gen 	LMA_minholdingmonths_Alt = substr(Summary, 1, hasspace-1)
destring LMA_minholdingmonths_Alt, replace i(" ")
drop 	Summary hasspace

keep 	State LMA_* year month
sort 	State year month

tempfile code2b
save 	"`code2b'", replace

** Code 2 Merge **

use  	"`code2a'"
merge 1:1 State year month using "`code2b'"
drop 	_merge

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c2_startdate = 0
replace c2_startdate = 1 if mindate==myr

keep 	State LMA_* year month c?_startdate

tempfile code2
save 	"`code2'", replace

** Code 3: Learner Stage Minimum Amount of Supervised Driving **
*use 	"`masterdata'"
*keep if Code==3

** Code 4: Intermediate Stage Mininum Age **
use 	"`masterdata'"
keep if Code==4
keep if Alt==. | Alt==0

gen 	IMA_years = substr(Summary, 1, 2)
gen 	hasmonths = strpos(Summary, "months")
gen 	IMA_months = substr(Summary, 4, 2) if hasmonths!=0

destring IMA_*, replace i(" ")
replace	IMA_months = 0 if IMA_months==.
drop 	Summary hasmonths

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c3_startdate = 0
replace c3_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate
sort 	State year month

tempfile code4a
save 	"`code4a'", replace

** Code 4: Intermediate Stage Mininum Age (Alternate) **
use 	"`masterdata'"
keep if Code==4
keep if Alt==. | Alt==1

gen 	IMA_years_Alt = substr(Summary, 1, 2)
gen 	hasmonths = strpos(Summary, "months")
gen 	IMA_months_Alt = substr(Summary, 4, 2) if hasmonths!=0

destring IMA_*, replace i(" ")
replace	IMA_months_Alt = 0 if IMA_months_Alt==.
drop 	Summary hasmonths

keep 	State IMA_* year month
sort 	State year month

tempfile code4b
save 	"`code4b'", replace

** Code 4 Merge **

use  	"`code4a'"
merge 1:1 State year month using "`code4b'"
drop 	_merge

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c4_startdate = 0
replace c4_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate

tempfile code4
save 	"`code4'", replace

** Code 5: Intermediate Stage Unsupervised Driving Prohibited **
use 	"`masterdata'"
keep if Code==5

gen 	none = strpos(Summary, "none")
gen 	IMA_nightrestrict = 1
replace IMA_nightrestrict = 0 if none==1

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c5_startdate = 0
replace c5_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate
sort 	State year month

tempfile code5
save 	"`code5'", replace

** Code 6: Intermediate Stage Restrictions on Passengers **
use 	"`masterdata'"
keep if Code==6

gen 	IMA_passrestrict = 1
replace IMA_passrestrict = 0 if EffectiveStart==.

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c6_startdate = 0
replace c6_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate
sort 	State year month

tempfile code6
save 	"`code6'", replace

** Code 7: Minimum Age Restrictions Lifted Nighttime **
use 	"`masterdata'"
keep if Code==7

gen 	minage0 = 0 if EffectiveStart==.

gen 	minagepos = strpos(Summary, "min. age: ")
gen 	minage1 = substr(Summary, minagepos+10, .) if minagepos!=0

browse if minage0==. & minage1==""

gen 	ppos = strpos(minage1, ")")
gen		minage2 = substr(minage1, 1, ppos-1) if ppos!=0
replace minage2 = Summary if ppos==0 & minage0==.
gen 	mpos = strpos(minage2, "m")

gen 	IMA_nightlift_year = substr(minage2, 1, 2) if minage0==.
gen 	IMA_nightlift_month = substr(minage2, mpos-3, 2) if minage0==. & mpos!=0

destring IMA_*, replace i(" ")
replace IMA_nightlift_month = 0 if IMA_nightlift_month==. & minage0==.

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c7_startdate = 0
replace c7_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate
sort 	State year month

tempfile code7
save 	"`code7'", replace


** Code 8: Minimum Age Restrictions Lifted Passenger **
use 	"`masterdata'"
keep if Code==8
keep if Alt==. | Alt==0

gen 	minage0 = 0 if EffectiveStart==.

gen 	minagepos = strpos(Summary, "min. age: ")
gen 	minage1 = substr(Summary, minagepos+10, .) if minagepos!=0

browse if minage0==. & minage1==""

gen 	ppos = strpos(minage1, ")")
gen		minage2 = substr(minage1, 1, ppos-1) if ppos!=0
replace minage2 = Summary if ppos==0 & minage0==.
gen 	mpos = strpos(minage2, "m")

gen 	IMA_passlift_year = substr(minage2, 1, 2) if minage0==.
gen 	IMA_passlift_month = substr(minage2, mpos-3, 2) if minage0==. & mpos!=0

destring IMA_*, replace i(" ")
replace IMA_passlift_month = 0 if IMA_passlift_month==. & minage0==.

keep 	State IMA_* year month
sort 	State year month

tempfile code8a
save 	"`code8a'", replace

** Code 8: Minimum Age Restrictions Lifted Passenger (Alternate) **
use 	"`masterdata'"
keep if Code==8
keep if Alt==. | Alt==1

gen 	minage0 = 0 if EffectiveStart==.

gen 	minagepos = strpos(Summary, "min. age: ")
gen 	minage1 = substr(Summary, minagepos+10, .) if minagepos!=0

browse if minage0==. & minage1==""

gen 	ppos = strpos(minage1, ")")
gen		minage2 = substr(minage1, 1, ppos-1) if ppos!=0
replace minage2 = Summary if ppos==0 & minage0==.
gen 	mpos = strpos(minage2, "m")

gen 	IMA_passlift_year = substr(minage2, 1, 2) if minage0==.
gen 	IMA_passlift_month = substr(minage2, mpos-3, 2) if minage0==. & mpos!=0

destring IMA_*, replace i(" ")
replace IMA_passlift_month = 0 if IMA_passlift_month==. & minage0==.

keep 	State IMA_* year month
sort 	State year month

rename 	IMA_passlift_year IMA_passlift_year_Alt
rename 	IMA_passlift_month IMA_passlift_month_Alt

tempfile code8b
save 	"`code8b'", replace

** Code 8 Merge **

use  	"`code8a'"
merge 1:1 State year month using "`code8b'"
drop 	_merge

gen		myr = year + 0.01*month
egen	stgr = group(State)
bys stgr: egen mindate = min(myr)
gen 	c8_startdate = 0
replace c8_startdate = 1 if mindate==myr

keep 	State IMA_* year month c?_startdate

tempfile code8
save 	"`code8'", replace

/*
** Code 9: Keys for Unsuperised Driving **
*use 	"`masterdata'"
*keep if Code==9

** Code 9.1: Keys for Passenger Restrictions**
*use 	"`masterdata'"
*keep if Code==91
*/

** Merge all together **

use "`code1'"
merge 1:1 State year month using "`code2'", keepusing(LMA_minholdingmonths* c?_startdate)

gen 	code1 = 0
replace code1 = 1 if _merge==1 | _merge==3
gen 	code2 = 0
replace code2 = 1 if _merge==2 | _merge==3
drop	_merge 

merge 1:1 State year month using "`code4'", keepusing(IMA_year* IMA_months* c?_startdate)

gen 	code4 = 0
replace code4 = 1 if _merge==2 | _merge==3
drop	_merge 

merge 1:1 State year month using "`code5'", keepusing(IMA_nightrestrict c?_startdate)

gen 	code5 = 0
replace code5 = 1 if _merge==2 | _merge==3
drop	_merge 

merge 1:1 State year month using "`code6'", keepusing(IMA_passrestrict c?_startdate)

gen 	code6 = 0
replace code6 = 1 if _merge==2 | _merge==3
drop	_merge 

merge 1:1 State year month using "`code7'", keepusing(IMA_nightlift* c?_startdate)

gen 	code7 = 0
replace code7 = 1 if _merge==2 | _merge==3
drop	_merge 

merge 1:1 State year month using "`code8'", keepusing(IMA_passlift* c?_startdate)

gen 	code8 = 0
replace code8 = 1 if _merge==2 | _merge==3

drop	_merge 

order 	code?, last

foreach n of numlist 1 2 4 5 6 7 8 {
	replace code`n'=0 if code`n'==.
}

drop 	c?_*

** Cleaning and create panel **

merge m:1 State using "\source\crosswalks\stfipsXwalk.dta"
drop 	_merge

** Temporary approach to dealing with unlisted dates -- assume that date is 12/1994 **
/* Justified because most undated laws precede dataset creation */

replace month = 12 if year==.
replace year = 1994 if year==.

gen 	moyr = ym(year, month) 
format 	moyr %tm 
order 	State state2d stfips moyr, first

xtset 	stfips moyr

** Year Version **
bys stfips: carryforward  LMA_* IMA_*, replace

** Manual fixes for key variables **
replace IMA_years = 16 if stfips==27
replace IMA_months = 0 if stfips==27

gen 	jr_age = IMA_years + IMA_months/12

tab 	moyr if jr_age==.

gen 	unr_age_ni = jr_age
gen 	unr_age_pa = jr_age
replace unr_age_ni = max(jr_age, IMA_nightlift_year + IMA_nightlift_month/12) if IMA_nightlift_year!=.
replace unr_age_pa = max(jr_age, IMA_passlift_year + IMA_passlift_month/12) if IMA_passlift_year!=.
gen		unr_age = max(unr_age_ni, unr_age_pa)

tab 	moyr if unr_age==.

replace jr_age = 15 if stfips==28 & year==1994
replace unr_age_ni = 15 if stfips==28 & year==1994
replace unr_age_pa = 15 if stfips==28 & year==1994
replace unr_age = 15 if stfips==28 & year==1994

order 	State state2d stfips moyr jr_age unr_age*, first

** Finish Panel Creation **
tsfill

drop if moyr<tm(1990m12)

tsfill, full

bys stfips: carryforward State state2d jr_age unr_age*, replace

keep if month(dofm(moyr))==1

replace year = year(dofm(moyr))

drop if year<1995

tab		year

keep 	State state2d stfips jr_age unr_age_ni unr_age_pa unr_age year

xtset	stfips year

bys year: tab jr_age
bys year: tab unr_age

sort stfips year

lab var year 		"Year - Regulation as of January"
lab var jr_age 		"Junior license minimum age"
lab var unr_age 	"Unrestricted license minimum age"
lab var unr_age_ni 	"Nighttime restrictions lifted minimum age"
lab var unr_age_pa 	"Passenger restrictions lifted minimum age"

* DATA SET READY TO GO 1995-2017 *

save "output\driver_license_age_requirements.dta", replace

* SUMMARY FILE *
gen 	jr_age_u155 = 0
replace jr_age_u155 = 1 if jr_age<=15.5

gen 	jr_age_u160 = 0
replace jr_age_u160 = 1 if jr_age<=16

gen 	jr_age_u165 = 0
replace jr_age_u165 = 1 if jr_age<=16.5

gen 	jr_age_u170 = 0
replace jr_age_u170 = 1 if jr_age<=17

gen 	unr_age_u160 = 0
replace unr_age_u160 = 1 if unr_age<=16

gen 	unr_age_u165 = 0
replace unr_age_u165 = 1 if unr_age<=16.5

gen 	unr_age_u170 = 0
replace unr_age_u170 = 1 if unr_age<=17

gen 	unr_age_u175 = 0
replace unr_age_u175 = 1 if unr_age<=17.5

gen 	unr_age_u180 = 0
replace unr_age_u180 = 1 if unr_age<=18

collapse (sum) jr_age_u??? unr_age_u???, by(year)

lab var jr_age_u155 	"Num. States with jr_age<=15.5"
lab var jr_age_u160 	"Num. States with jr_age<=16.0"
lab var jr_age_u165 	"Num. States with jr_age<=16.5"
lab var jr_age_u170 	"Num. States with jr_age<=17.0"
lab var unr_age_u160 	"Num. States with unr_age<=16.0"
lab var unr_age_u165 	"Num. States with unr_age<=16.5"
lab var unr_age_u170 	"Num. States with unr_age<=17.0"
lab var unr_age_u175 	"Num. States with unr_age<=17.5"
lab var unr_age_u180 	"Num. States with unr_age<=18.0"

save "output\driver_license_age_statesummary.dta", replace
clear

*******************
** MISC OLD CODE **

/*
** Deal with missing data values **
/* 
gen 	URMA_years = .
gen 	URMA_months = .

replace URMA_years = 16 if stfips==4 & moyr==.
replace URMA_months = 0 if stfips==4 & moyr==.
replace moyr = tm(1994m1) if stfips==4 & moyr==.
*/
