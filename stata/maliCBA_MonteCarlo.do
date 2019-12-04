* Program to generate triangular distributions *
* 1 = minimum value	*
* 2 = mode (peak)   *
* 3 = maximum value *
* 4 = name of triangular variable generated *
clear all
import excel "C:\Users\nli59\Dropbox\CBA\stata_dataset.xlsx", sheet("mk_stata") firstrow 
destring year, replace
lab var enroll "Raw data on enrollment"

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

* Draw from tri distribution, centered at the mean of data
	sum enroll
	scalar mean_enrol = `r(mean)'
	scalar sd_enrol = `r(sd)'
	scalar min_enrolment = ((mean_enrol - sd_enrol)>=0)*(mean_enrol - sd_enrol)
	scalar max_enrolment = mean_enrol + sd_enrol

* Generate RV enrollment
	Triangular min_enrolment mean_enrol max_enrolment enrol_rv
	lab var enrol_rv "Random draw from triangular distro (min, mode, max)"

cap prog drop NPV
prog def NPV, rclass
	gen ben_rv = enrol_rv*488.41 + enrol_rv*10 + 4*254 + 488.41*10 
	gen netbet = ben_rv - 4413528
	gen nb = netbet/((1.03)^year) //assuming 3% discount rate
	sum nb
	return scalar total = r(sum)
end
	

* Use simulate to do this many times
	simulate npv_tri = r(total), reps (1000) nodots: NPV
	hist npv_tri, percent scheme(plotplain) xtitle ("Monte Carlo PVNB") 


