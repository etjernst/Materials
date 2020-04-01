*! version 2.0.1 01apr2020  Emilia Tjernström

* **********************************************************************
* 1 - Program customsave
    /* labels data and saves it
     - takes the following arguments:
     + description (in "quotes")
     + dofilename (the .do file that is saving the data) 
     + filename (name of the data set you are saving)
     + filepath (filepath to save in) 
     + name or initials of user */
* **********************************************************************

cap prog drop customsave

program define customsave
args description dofilename filename filepath user

* Macro with today's date
    local today "`c(current_date)'"

* Label data
    label data "`description' | created using `dofilename' | last modified:  `today' by `user'" 

* Add a note to the data note
    note: `filename' | created using `dofilename' | modified `today' by `user'

* Save the data set in `filepath'
    save "`filepath'/`filename'", replace
end
