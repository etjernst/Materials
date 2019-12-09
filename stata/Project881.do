clear

//Data Preparations

cd/Users/qianhuili/Desktop/PA881/Talip 

import delimited sub_data

rename ïyear year

drop v6

drop v7

//////////////

***Install Packages***

ssc install coefplot, replace

******* Year 1 ***********

	****Simulation 1*****
{
preserve
	keep if year==1
	xtile plot_quintile =plot_area, nq(5)
	set seed 12345
	generate randum = uniform()
	egen T = cut(randum), group(2)

	
	generate sr_new = sr_yield + 0.24*sr_yield if T == 1
	generate cc_new = cc_yield+0.24*cc_yield if T == 1
	replace sr_new = sr_yield[_n] if missing(sr_new)
	replace cc_new = cc_yield[_n] if missing(cc_new)
	
	reg sr_new i.T, vce(cluster plot_quintile)
	estimates store sr11
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

	
