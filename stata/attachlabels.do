* Tiny .do file to run after copylabels.do > collapse
* attachlabels.do

foreach v of var * {
        label var `v' "`lab`v''"
}

