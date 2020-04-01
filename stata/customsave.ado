*! version 2.0.1 01apr2020  Emilia Tjernström

* **********************************************************************
* 1 - Program customsave
    /* labels data and saves it
     - takes the following arguments:
     + description (in "quotes")
     + dataname (name of the data set you are saving)
     + dofilename (the .do file that is saving the data)
     + filepath (filepath to save in) */
* **********************************************************************

cap prog drop customsave

program define customsave
args description dofilename filename filepath user

* Macro with today's date
    local today "`c(current_date)'"

* Label data
    #delimit ;
    label data "`description' | created using `dofilename' |
    last modified:  `today' by `user'" ;
    #delimit cr

* Add a note to the data note
    note: `dataname' | created using `dofilename' | modified `today' by `user'

* Save the data set in `filepath'
    save "`filepath'/`dataname'", replace
end
