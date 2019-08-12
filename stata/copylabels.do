* Tiny .do file to copy variable labels before collapsing
* Run this file before collapsing (and then run attachlabels.do after collapsing)
* copylabels.do

* Loop over all variables
foreach v of var * {
  * Store variable label in a local
        local lab`v' : variable label `v'
            if `"`lab`v''"' == "" {
            local lab`v' "`v'"
        }
}
