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

program customsave , rclass
    syntax , IDVARname(varlist) DOFILEname(string) [DESCription(string) user(string) noidok path()] using filename

    qui {
		preserve
        local origversion "`c(version)'"
		version 16.0

* **********************************************************************
* Checking that user only supplied one id variable
	if `:list sizeof idvarname' > 1 {
		noi di as error "{phang} You should not have multiple ID variables in idvarname(`idvarname').{p_end}"
		noi di ""
		error 103
		exit
	}
* **********************************************************************
* Test potential issues with id variable

    * 1 - check whether idvarname uniquely identifies observations in the data
    capture isid `idvarname'
    if _rc {
        // Test missing
        capture assert !missing(`idvarname')
    		if _rc {
                if "`noidok'" != "" {
        			count if missing(`idvarname')
        			noi di as error "{phang}`r(N)' observation(s) are missing the ID variable `idvarname'. If you want to allow this, specify the noid option but what does that mean?"
        			noi di ""
                }
    		}

    * 2 - check for duplicates in idvarname
		// Test duplicates
		tempvar dup

        * Count how many duplicates there are
		duplicates tag `idvarname', gen(`dup')
		count if `dup' != 0
        local dupnumber = `r(N)'
		if r(N) > 0 {
			sort `idvarname'
			noi di as error "{phang}The ID variable `idvarname' has duplicate observations in `dupnumber' values:{p_end}"
			noi list `idvarname' if `dup' != 0
		}
		noi di ""
		error 148
		exit
	}

    restore
    }

* **********************************************************************
* Metadata
	* Store the name of idvar in dataset characteristics and in notes
		char  _dta[config_idvar] "`idvarname'"
        if "`noidok'" != "" {
            local idOut "Observations in this data set are identified by `idvarname'. "
        }

	* Store Stata version that generated the data
		char  _dta[config_version] "`origversion'"
		local versOut "This data set was created with .do file `dofile'"

	* Date
		char  _dta[config_date] "`c(current_date)'"
		local dateOut " | Last modified on `c(current_date)'"

	* User
        if "`user'" == "" {
            char  _dta[config_user] "`c(username)'"
            local user "`c(username)'"
        }
		char  _dta[config_host] "`c(hostname)'"
		local userOut " by user `user' using computer `c(hostname)'"
		}

* **********************************************************************
* 5 - Add metadata (data label and notes) and save

    char _dta[config_boilsave] "`idOut'`versOut' `userOut'`dateOut'"
    display "`idOut' `versOut' `userOut' `dateOut'"

    label data "`versOut' `dateOut' `userOut'"

    * Add a note to the data (useful for tracking edits over time)
    note: Dataset `filename' | `versOut' `dateOut' `userOut' | Further description: `description'

    * Save
    save "`path'/`filename'", replace

	end
