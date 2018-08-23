clear all 
set more off 
capture log close 

// Set local git directory and local dropbox directory
if c(username) == "Tom Bearpark" {
    global dbdir = "C:\Users\Tom Bearpark\Dropbox\epic_task_nadia\tom"
    global hbpdir = "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task"
	}
else if c(username) == "nadialucas" {
    global dbdir = "/Users/nadialucas/Dropbox/epic_task_nadia/tom"
    global hbpdir = "/Users/nadialucas/"
}

// Input and output directories
global outdir = "$dbdir/IntermediateData"
global codedir = "$hbpdir/Code"
global logdir = "$codedir/Logfiles"

// Create a plain text log file to record output
// Log file has same name as do-file
log using "$logdir/Cleaning_and_merge_log.txt", replace text

cd "$dbdir/RawData"

local list : dir . files "*.txt"
foreach f of local list {
	di "`f'"
	import delimited "`f'" , varnames(1)
	save "$outdir/`f'.dta", replace
	clear
	} 

cd "$dbdir/IntermediateData"
	
use "demographics.txt.dta", clear

merge 1:1 fips using "house_age1.txt.dta"
drop _m
merge 1:1 fips using "house_age2.txt.dta"
drop _m
merge 1:1 fips using "house_chars1.txt.dta"
drop _m
merge 1:1 fips using "house_chars2.txt.dta"
drop _m
merge 1:1 fips using "sample82.txt.dta"
drop _m


gen dividedfips = fips/(10)^8
gen statefips = string(dividedfips)
replace statefips = substr(statefips,1,2)
destring statefips, replace
drop dividedfips


save "$dbdir/IntermediateData/superfund_sample.dta", replace
