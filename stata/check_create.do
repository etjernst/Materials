cap prog drop check_create
program define check_create
args newfilepath

* Grab current working directory
	local cwd `"`c(pwd)'"'

* Check if a folder exists (cap --> get error code if doesn't exist)
	quietly cap cd "`newfilepath'"

* If it doesn't already exist, create folder
	if _rc mkdir "`newfilepath'"

* Reset working directory if it changed
	quietly cd `"`cwd'"'

end
