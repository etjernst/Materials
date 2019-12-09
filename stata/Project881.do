* **********************************************************************
* Project: CBA project
* Created: Fall 2019
* Last modified: 12/08/2019 by ET
* Stata v.16

* Note: file directory is set in section 0
* users only need to change the location of their path there
* or their initials
* **********************************************************************
* does
    /* This code opens data from Talip
	and then does X
	and then does Y
	 */

* assumes
	* Add any dependencies here
	* for packages, make a local containing any required packages
        local userpack "coefplot"

* TO DO:
    * Add to do list here

* **********************************************************************
* 0 - General setup
* **********************************************************************
* Users can change their initials
* All subsequent files are referred to using dynamic, absolute filepaths

* User initials:
* Emilia	et
* Qianhui 	ql

* Set this value to the user currently using this file
    global user "et"
* **********************************************************************
* Set root folder globals
    if "$user" == "et" {
        global myDocs "Z:"
        * global myDocs "N:/users/tjernstroem"
	    global projectFolder          "$myDocs/Materials/stata"
    }
    if "$user" == "ql" {
        global myDocs  "C:/Users/qianhuili/Desktop/"
	    global projectFolder          "$myDocs/PA881/Talip"

    }
* **********************************************************************
* Check if any required packages are installed:
	foreach package in `userpack' {
		capture : which `package'
		if (_rc) {
			display as result in smcl `"Please install package {it:`package'} from SSC in order to run this do-file."' _newline `"You can do so by clicking this link: {stata "ssc install `package'":auto-install `package'}"'
			exit 199
		}
	}
* **********************************************************************
* Set graph and Stata preferences
    set scheme plotplain
    set more off

* Start a log file
    cap: log close
* Generate a folder for logs
	qui: capture mkdir "$projectFolder/logs/"
    log using "$projectFolder/logs/project881", replace

* **********************************************************************
* 1 - Data preparation
* **********************************************************************
* import data
	import delimited "$projectFolder/sub_data.csv", clear

* generate more reasonable year variable	// avoid overwriting varnames
	clonevar year = ïyear
	lab var year "Survey year"			// always always always label vars

* Check if any non-missing values of v6 and v7
	count if !mi(v6)
	count if !mi(v7)
	cap drop v6
	cap drop v7

	sort hhid year 		// easier to see data

* **********************************************************************
* 2 - Simulations using year 1 data
* **********************************************************************
* {
* Set seed	
	set seed 9701259		// 12345 is not a good random number for a seed
	
* preserve
	keep if year == 1
	* Divide data into 5 quintiles
		xtile plot_quintile = plot_area, nq(5)
		lab var plot_quintile "Quintile of baseline plot area"
		tab plot_quintile		// roughly 88 hhs per quintile		

	* Generate draws from the uniform distribution for treatment dummy
		generate randum = uniform()
		egen T = cut(randum), group(2)
		hist randum

	/* Generate simulated value of outcome variable
	  by adding 24% of the original yield for the treatment group 
	  for both self-reports and crop-cuts   */
		
		generate sr_new = sr_yield + 0.24*sr_yield if T == 1
		generate cc_new = cc_yield + 0.24*cc_yield if T == 1
		
		lab var sr_new "Simulated treatment yield for self-report"
		lab var cc_new "Simulated treatment yield for crop cut"
		
	* Fill in values for the "control group"
		replace sr_new = sr_yield if missing(sr_new)	// no need for [_n]
		replace cc_new = cc_yield if missing(cc_new)

	* Run a treatment effect regression	
		reg sr_new i.T, vce(cluster plot_quintile)
		estimates store sr11
		/* The "treatment effect" is not statistically significant
	     this is not terribly surprising since the sample size is small
	     and the yields are very, very noisy 
	     You can see this in a few ways:
	  
	     1) look at a basic cross-tab with 
	     tab T, sum(sr_yield)
	     and 
	     tab T, sum(sr_new) --> look at the standard deviations!! They are HUGE!
	  
	     2) look at the data in, say, a basic histogram	 */
	 
	local hist1 = "fcolor(red%30) lcolor(red%80) lwidth(vvthin)"
	local hist2 = "fcolor(ebblue%40) lcolor(ebblue%80) lwidth(vvthin)"
		 
	* Look at histogram for the simulated treatment effect
	* Also add line with mean in each group
		sum sr_new if T
		local meanT = `r(mean)'
		sum sr_new if !T
		local meanC = `r(mean)'
	
		twoway	(hist sr_new   if T,    `hist1' percent 	///
			xline(`meanT', lcolor(red%50) lpattern(solid)))		///
			(hist sr_new   if !T,   `hist2' percent 	///
			xline(`meanC', lcolor(ebblue%50) lpattern(shortdash))) 	///
			, legend(order(1 "Control" 2 "Treatment") pos(5) cols(2))

	* Look at histogram for the actual self-reported yields
	* Also add line with mean in each group	
		sum sr_yield if T
		local meanT = `r(mean)'
		sum sr_yield if !T
		local meanC = `r(mean)'
	
		twoway	(hist sr_yield   if T,    `hist1' percent 	///
			xline(`meanT', lcolor(red%50) lpattern(solid)))		///
			(hist sr_yield   if !T,   `hist2' percent 	///
			xline(`meanC', lcolor(ebblue%50) lpattern(shortdash))) 	///
			, legend(order(1 "Control" 2 "Treatment") pos(5) cols(2)) 	///
			xtitle("Self-reported yield without added treatment effect")

	* If you either log the data or winsorize it it looks a lot less crazy!	
		gen log_sr_yield = log(sr_yield)	// very few zeros so should be ok
			lab var log_sr_yield "log(self-reported yield)"
		winsor2 sr_yield, suffix(W) cut(5 95)
			lab var sr_yieldW "Self-reported yield, winsorized at 5th and 95th"
			
		twoway	(hist log_sr_yield   if T,    `hist1' percent) 	///
				(hist log_sr_yield   if !T,   `hist2' percent) 	///
			, legend(order(1 "Control" 2 "Treatment") pos(5) cols(2)) 	///
			saving(log, replace)			///
			xtitle("Log of self-reported yield without added treatment effect")
			
		twoway	(hist sr_yieldW   if T,    `hist1' percent )	///
			(hist sr_yieldW   if !T,   `hist2' percent) 	///
			, legend(order(1 "Control" 2 "Treatment") pos(5) cols(2)) 	///
			saving(winsorized, replace)			///
			xtitle("Winsorized self-reported yield w/o added treatment effect")			
			
		graph combine log.gph winsorized.gph	
			
* **********************************************************************
* ET: I did not go further than this. As I suggested before, the outliers are 
* a big problem. I would recommend dealing with those either by logging 
* or winsorizing (logging looks pretty good) and then re-run the regression
* **********************************************************************
			
	reg cc_new i.T, vce(cluster plot_quintile)
	estimates store cc11

	coefplot sr11 cc11, drop(_cons) xline(0)
	save "coefplot_sim1yr1", replace

	reg sr_new i.T##i.plot_quintile, vce(cluster plot_quintile)
	estimates store srT_Q_11
	margins, dydx(T) over (plot_quintile)
	marginsplot, noci
	save "SR_Margins of T=1",replace

	reg cc_new i.T##i.plot_quintile, vce(cluster plot_quintile)
	estimates store ccT_Q_11
	margins, dydx(T) over (plot_quintile)
	marginsplot, noci
	save "CC_Margins of T=1",replace

	bysort plot_quintile: egen sr_control = mean(sr_yield)
	bysort plot_quintile: egen sr_treated = mean(sr_new)
	bysort plot_quintile: gen ATE_sr= (sr_treated-sr_control)
	graph bar ATE_sr, over(plot_quintile) blabel(total)
	save "ATE_SR",replace

	bysort plot_quintile: egen cc_control = mean(cc_yield)
	bysort plot_quintile: egen cc_treated = mean(cc_new)
	bysort plot_quintile: gen ATE_cc= (cc_treated-cc_control)
	graph bar ATE_cc, over(plot_quintile) blabel(total)
	save "ATE_CC",replace

	bysort plot_quintile: gen ATE_diff= (ATE_sr-ATE_cc)
	graph bar ATE_diff, over(plot_quintile) blabel(total)
	save "ATE_Diff",replace

restore
}






/////////Haven't make changes below/////see above



	****Simulation 2*****
{
preserve
	keep if year==1
	xtile plot_quintile =plot_area, nq(5)
	set seed 54321
	simple_ra T, replace prob(.5)
	tab T

	generate sr_new = sr_yield + 0.24*sr_yield if T == 1
	generate cc_new = cc_yield+0.24*cc_yield if T == 1
	replace sr_new = sr_yield[_n] if missing(sr_new)
	replace cc_new = cc_yield[_n] if missing(cc_new)

	reg sr_new T, vce(cluster plot_quintile)
	estimates store sr12
	reg cc_new T, vce(cluster plot_quintile)
	estimates store cc12
restore
}

******* Year 2 *************

	****Simulation 1*****
{
preserve
	keep if year==2
	xtile plot_quintile =plot_area, nq(5)
	set seed 12345
	simple_ra T, replace prob(.5)
	tab T

	generate sr_new = sr_yield + 0.24*sr_yield if T == 1
	generate cc_new = cc_yield+0.24*cc_yield if T == 1
	replace sr_new = sr_yield[_n] if missing(sr_new)
	replace cc_new = cc_yield[_n] if missing(cc_new)

	reg sr_new T, vce(cluster plot_quintile)
	estimates store sr21
	reg cc_new T, vce(cluster plot_quintile)
	estimates store cc21
restore
}

	****Simulation 2*****
{
preserve
	keep if year==1
	xtile plot_quintile =plot_area, nq(5)
	set seed 54321
	simple_ra T, replace prob(.5)
	tab T

	generate sr_new = sr_yield + 0.24*sr_yield if T == 1
	generate cc_new = cc_yield+0.24*cc_yield if T == 1
	replace sr_new = sr_yield[_n] if missing(sr_new)
	replace cc_new = cc_yield[_n] if missing(cc_new)

	reg sr_new T, vce(cluster plot_quintile)
	estimates store sr22
	reg cc_new T, vce(cluster plot_quintile)
	estimates store cc22
restore
}
