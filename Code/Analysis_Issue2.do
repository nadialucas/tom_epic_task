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
    global hbpdir = "/Users/nadialucas/Documents/tom_epic_task"
}

// Input and output directories
global outdir = "$dbdir/IntermediateData"
global codedir = "$hbpdir/Code"
global logdir = "$codedir/Logfiles"

// Create a plain text log file to record output
// Log file has same name as do-file
*log using "$logdir/Analysis.txt", replace text

cd "$outdir"

use superfund_sample, replace

/* Want to measure impact of Superfund cleanup on local housing prices.
Want to observe the relationship between a locale's 2000 log median house prices 
(which I'll now call lnmdvalhs0) and its NPL status in 2000 (npl2000).*/

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
	
// 1. Regress lnmdvalhs0 onto npl2000, using a price control

reg lnmdvalhs0 npl2000 `price_control', r
est sto m1
// 2. Regress lnmdvalhs0 onto npl2000, using price and house controls

reg lnmdvalhs0 npl2000 `price_control' `house_controls', r
est sto m2
// 3. Regress lnmdvalhs0 onto npl2000, using price, house, and economic controls

reg lnmdvalhs0 npl2000 `price_control' `house_controls' `economic_controls', r
est sto m3
/* 4. Lastly, regress lnmdvalhs0 onto npl2000, using price, house, 
		and economic controls. Use a statefips fixed effect.*/

reghdfe lnmdvalhs0 npl2000  `price_control' `house_controls' `economic_controls' , absorb(statefips) 
est sto m4

// Tabulate the regression results
	  
#delimit;
	esttab m1 m2 m3 m4 using "$hbpdir/Build/reg_results_table.tex", 
	se r2 
	coeflabel(npl2000 "House Price Coefficient")
	nonumber 
	title("Measuring the impact of Superfund cleanup on local housing prices")
	mtitle("Model 1" "Model 2" "Model 3" "Model 4")
	b(%9.3f) t(%9.3f) r2(%9.5f) 
	keep(npl2000)
	//drop(`price_control' `house_controls' `economic_controls')
	addnote("Model 1: Only price controls" "Model 2: Price and house controls"
	"Model: 3 Price, house and economic controls" 
	"Model 4: Price, house and economic controls, and fixed effects")
	replace ;
#delimit cr


/* Results show that is a positive association between NPL status in 2000 
house prices in that year. This is robust to all specifications tried./*
