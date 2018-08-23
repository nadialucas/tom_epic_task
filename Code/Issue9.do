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
// log using "$logdir/XX.txt", replace text

cd "$outdir"

use superfund_sample.dta


// Generate hrs dummy
gen hrs = 0
replace hrs = 1 if hrs_82 > 28.5

/* Create an hrs_bin variable. This variable "bins" data into equally spaced 
bins of width equal to 4.75 hrs points. Make the bin value the midpoint of 
the two endpoints.
a. Example: For the bin [0,4.75), the bin value should be 2.375 */

gen byte hrs_bin = 2.375 if hrs_82 < 4.75

local i 4.75
while `i' <= 75 {
    local j `i'+4.75
    replace hrs_bin=(`i' + `j')/2 if hrs_82 >= `i' & hrs_82 < `j'
    local i `j'
} 

/*After that, restrict superfund_sample to only include those observations 
that have added data from sample82. Assert that this restricted is of 
size N = 409. Save this dataset as superfund_sample_restricted.*/

drop if hrs_bin ==.
assert _N == 409

save "superfund_sample_restricted.dta", replace



