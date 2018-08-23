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
log using "$logdir/Balance_check.txt", replace text

cd "$outdir"

use superfund_sample.dta

local price_control lnmeanhs8

#delimit;
local house_controls firestoveheat80 noaircond80 nofullkitchen80 zerofullbath80 
	bedrms0_80occ bedrms1_80occ bedrms2_80occ bedrms3_80occ bedrms4_80occ 
	bedrms5_80occ blt0_1yrs80occ blt2_5yrs80occ blt6_10yrs80occ blt10_20yrs80occ 
	blt20_30yrs80occ blt30_40yrs80occ blt40_yrs80occ detach80occ mobile80occ ;
#delimit cr
	
#delimit;
local economic_controls pop_den8 shrblk8 shrhsp8 child8 old8 shrfor8 ffh8 smhse8 
hsdrop8 no_hs_diploma8 ba_or_better8 unemprt8 povrat8 welfare8 avhhin8 tothsun8 
ownocc8 occupied80 ;
#delimit cr


// Create a balance table
cd "$hbpdir/Build"
balancetable npl2000 `price_control' `house_controls' `economic_controls' using "balance_table.tex", replace ctitles("Not NPL" "NPL" "Difference")


