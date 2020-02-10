cap prog drop customsave

program define customsave
args description dataname dofilename filepath

* Macro with today's date
    local today "`'c(current_date)'"

* Label data with a short description & today's date
    label data "`description' | `today'"

* Add a longer data note
    note: `dataname' | `description' | ///
	created using `dofilename' | last modified: `today'

* Save the data set in `filepath'
    save "`filepath'/`dataname'", replace
end
