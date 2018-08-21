clear 
set more off
capture log close
cd "C:\Users\Tom Bearpark\Dropbox\epic_orientation\Data_Task_Orientation"

local list : dir . files "*.txt"
foreach f of local list {
di "`f'"
import delimited "`f'" , varnames(1)
save "`f'.dta", replace
clear
} 

use "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task\raw_data\demographics.txt.dta", clear

merge 1:1 fips using "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task\raw_data\house_age1.txt.dta"
drop _m
merge 1:1 fips using "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task\raw_data\house_age2.txt.dta"
drop _m
merge 1:1 fips using "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task\raw_data\house_chars1.txt.dta"
drop _m
merge 1:1 fips using "C:\Users\Tom Bearpark\Documents\Data_Task\tom_epic_task\raw_data\house_chars2.txt.dta"
drop _m

drop statefips

gen dividedfips = fips/(10)^8
gen statefips = string(dividedfips)
replace statefips = substr(statefips,1,2)
destring statefips, replace
drop dividedfips

save superfund_sample.dta, replace





