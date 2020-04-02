* **********************************************************************
* Project: Mali CBA
* Created: Fall 2019
* Last modified: 12/04/2019 by ET
* Stata v.16

* Note: file directory is set in section 0
* users only need to change the location of their path there
* or their initials
* **********************************************************************
* does
    /* This code opens stata_dataset.xlsx, which contains enrollment
	defines a program that draws from the triangular distribution
	and allows enrollment to be a random variable
	 */

* assumes
	* Add any dependencies here
	* for packages, make a local containing any required packages
        local userpack ""

* TO DO:
    * Add to do list here

* **********************************************************************
* 0 - General setup
* **********************************************************************
* Users can change their initials
* All subsequent files are referred to using dynamic, absolute filepaths

* User initials:
* Emilia		et
* Niying Li		nl

* Set this value to the user currently using this file
    global user "et"
* **********************************************************************
* Set filepath globals
    if "$user" == "et" {
        global myDocs "Z:"
        global projectFolder "$myDocs/Materials/stata"
    }
    if "$user" == "nl" {
        global myDocs "C:/Users/nli59/Dropbox/"	// avoid backslashes
		global projectFolder "$myDocs/CBA"
    }

* Set graph and Stata preferences
    set scheme plotplain
    set more off

* Start a log file
    cap: log close
    log using "$projectFolder/maliCBA_MonteCarlo", replace
	
* **********************************************************************
* 1 - Open enrollment data
* **********************************************************************
* Open data
	clear all
	import excel "$projectFolder/stata_dataset.xlsx", ///
	sheet("mk_stata") firstrow

* Destring year variable
	destring year, replace
	lab var enroll "Raw data on enrollment"
	
* Look at the data
	br		// ok, so there are a bunch of unnecessary rows; get rid of them
	drop if mi(year)
	sum enroll	/* hm: the max is very, very weird - why are there fractional
	students in the school? */
	
* Since time series, time series setup
	tsset year
* What does enrollment look like over time?
	tsline enroll

* What are these values exactly?
	list year enroll /* ok, more questions: why does enrollment "stabilize"
	at 388.9? */	

* **********************************************************************
* 2 - Define program to draw from triangular
* **********************************************************************
* Program to generate triangular distributions *
* 1 = minimum value	*
* 2 = mode (peak)   *
* 3 = maximum value *
* 4 = name of triangular variable generated *

	capture program drop Triangular
	program define Triangular
	local min = `1'
	local mode = `2'
	local max = `3'
	local variable = "`4'"
	local cutoff=(`mode'-`min')/(`max'-`min')
	generate Tri_temp = uniform()
	generate `variable' = `min' + sqrt(Tri_temp*(`mode'-`min')*(`max'-`min')) if Tri_temp<`cutoff'
	replace `variable' = `max' - sqrt((1-Tri_temp)*(`max'-`mode')*(`max'-`min')) if Tri_temp>=`cutoff'
	drop Tri_temp
	end

* **********************************************************************
* 3 - Define program to simulate net benefits
* **********************************************************************
/* Lines 31 - 37 in mcTriET.do show that you have to define another program
	to calculate the net benefits, and within that simulate a draw of the RV.
	What you were doing was just creating a scalar, mean_enrol,
	which equals the mean of enroll and then multiplying it by 488.41
	many many times!
	Your NPV program as it was written featured no random variables
	because you were drawing them outside of the program :) */

	cap prog drop NPV
	prog def NPV, rclass
	
	* Save data state
		preserve
		
	* Find mean of enrollment
		sum enroll
		scalar mean_enrol        = `r(mean)'
		scalar sd_enrol          = `r(sd)'
		scalar min_enrolment     = 			///
			((mean_enrol - sd_enrol)>=0)*(mean_enrol - sd_enrol)
		scalar max_enrolment     = mean_enrol + sd_enrol

	* Generate RV enrollment by drawing from the triangular distribution
		Triangular min_enrolment mean_enrol max_enrolment enrol_rv
		lab var enrol_rv "Random draw from triangular distro (min, mode, max)"
	
	* Generate a variable that multiplies enrollment by something
		gen ben_rv = enrol_rv*488.41 + enrol_rv*10 + 4*254 + 488.41*10
		/* I don't understand where 488.41 & 10 come from, nor the other
		numbers -- please add these as scalars above line 116 at the very least
		and you might also consider making them random as well, depending. */
	lab var ben_rv "No idea what this is"
	
	* Subtract an undefined number from ben_rv
	gen netbet = ben_rv - 4413528
	lab var netbet "This is also not labeled"
	
	* Discount netbet by 3%
	gen pvnb = netbet/((1.03)^year) //assuming 3% discount rate
	lab var pvnb "Something something"
	sum pvnb
	return scalar total = r(sum)
	
	* return to earlier data state
		restore
end


* Use simulate to do this many times
	simulate npv_tri = r(total), reps (10000) nodots: NPV
	hist npv_tri, percent scheme(plotplain) xtitle ("Monte Carlo PVNB")

	
	
	
	
log close	