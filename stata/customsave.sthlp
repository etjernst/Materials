{smcl}
{* 2 Apr 2020}{...}
{hline}
help for {hi:customsave}
{hline}

{title:Title}

{phang2}{cmdab:customsave} {hline 2} Adds metadata to a dataset and optionally checks that identifiers are unique and non-missing.

{title:Syntax}

{phang2}
{cmdab:customsave}
, {cmdab:idvar:name(}{it:varname}{cmd:)} {cmdab:filename(}{it:string}{cmd:)} {cmdab:path(}{it:string}{cmd:)} {cmdab:dofile:name(}{it:string}{cmd:)} [{cmdab:description(}{it:string}{cmd:)} {cmdab:user(}{it:string}{cmd:)} {cmdab:noidok}]


{marker opts}{...}
{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{synopt :{cmdab:idvar:name(}{it:varname}{cmd:)}}specifies the ID variable
	that hopefully uniquely identifies the observations in the data set{p_end}
{synopt :{cmdab:filename(}{it:string}{cmd:)}}the filename for the data
	to be saved{p_end}
{synopt :{cmdab:path(}{it:string}{cmd:)}}specifies directory where
	{it: filename} should be saved (command saves to {it:path}/{it:filename}){p_end}
{synopt :{cmdab:dofile:name(}{it:string}{cmd:)}}the name of the .do file
	that is doing the saving (helpful for tracking untidy code){p_end}
{synopt :{cmdab:description(}{it:string}{cmd:)}}optional longer description;
	added to data as a note{p_end}
{synopt :{cmdab:user(}{it:string}{cmd:)}}specifies username (default is
	system username){p_end}
{synopt :{cmdab:noidok}}skips checks of uniqueness, etc. of {it:idvar} {p_end}

{synoptline}

{title:Description}

{pstd}{cmdab:customsave} is a small utility that adds standardized metadata to
	datasets and optionally checks the quality of the ID variable. Only
	takes one variable as identifier.

{pstd}The command also a few forms of meta data to the data set. This is
	useful for future users and for transparency. Metadata is added
	using {cmdab:char}, which stores meta data to the data set using an
	associative array, see {help char} for an explanation.
	The command also labels the data set with the name of the do file that
	created it, the last date that it was modified, and the current user. A
	longer data note additionally adds the name an optional longer description.

{p2colset 5 32 36 2}
{p2col : Charname}Metadata associated with the charname{p_end}
{p2line}
{p2col :{cmdab:_dta[config_idvar]}}stores the name of the ID variable.{p_end}
{p2col :{cmdab:_dta[config_version]}}stores the Stata version used
 	to create the data set. Retrieved from {cmdab:c(version)}.{p_end}
{p2col :{cmdab:_dta[config_date]}}stores the date the file was saved. Copying files,
	or sharing them via email can change the time stamp you see; this is more
	reliable. Retrieved from {cmdab:c(current_date)}.{p_end}
{p2col :{cmdab:_dta[config_user]}}stores user name (either from
	{cmdab:c(username)} or chosen by user.{p_end}
{p2col :{cmdab:_dta[config_host]}}stores computer name (from {cmdab:c(hostname)}).{p_end}

{p2line}

{title:Options}

{phang}{cmdab:idvar:name(}{it:varname}{cmd:)} specifies the ID variable that is
	supposed to fully and uniquely identify the data set. Only one variable
	is allowed in {it:varname}.{p_end}

{phang}{cmdab:filename} is the name of the data set to be saved.{p_end}

{phang}{cmdab:path} is the directory to save in.{p_end}

{phang}{cmdab:dofile:name} is the name of the dofile that modified the
	dataset.{p_end}

{phang}{cmdab:description} adds optional longer comment.{p_end}

{phang}{cmdab:user} changes the username in the metadata from the one in
 	c(username).{p_end}

{phang}{cmdab:noidok} skips checks of ID variable. But it still outputs an
	obnoxious comment in your log file noting that you really should think
	through your ID variable.{p_end}

{title:Examples}

{pstd} {hi:Example 1}

{pmore}{inp:customsave, idvarname(hhid) filename(superCleanData) path($projectfolder/dataWork/Analysis/dataSets) dofile(lastDoFile.do)}

{pmore}This minimal example checks that the variable {it:hhid}
uniquely and fully identifies that data set, and saves meta data to the
data set using char, a data label, and a note.

{pstd} {hi:Example 2}

{pmore}{inp:customsave, idvarname(hhid) filename(superCleanData) path($projectfolder/dataWork/Analysis/dataSets) dofile(lastDoFile.do) noidok}

{pmore}This adds the same metadata as in Example 1, but skips the ID checks.


{title:Acknowledgements}

{phang}Parts of this draw heavily on the DIME unit's {browse: "https://dimewiki.worldbank.org/wiki/Ieboilsave":ieboilsave} command, which is part of the {browse "https://dimewiki.worldbank.org/wiki/Stata_Coding_Practices#ietoolkit":ietoolkit} package.

{title:Author}

{phang}Emilia Tjernström's convenience utility for metadata.

{phang}Please send bug-reports, suggestions and requests for
	clarifications to emilia.tjernstrom@sydney.edu.au

{phang}The code and version
		 history is all located in {browse "https://github.com/etjernst/Materials":my GitHub repository}.{p_end}
