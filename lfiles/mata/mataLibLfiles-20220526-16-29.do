adopath + $pado


cd `c(sysdir_personal)'


global AAS class AssociativeArray scalar
global SS  string scalar 
global RS  real scalar
global A   _lf_fav
global brFmt html jpg jpeg tif emf wmf eps doc xls xlsx docx rtf pdf csv scsv
global viewFmt do ado mata sthlp stcmd txt bat log lst sas smcl tex r
						
clear mata

include "$pmata\lf_matasrc_lfiles.do"
include "$pmata\lf_matasrc_favorites_20210107.do"

mata:
mata mlib create llfiles     , dir($pado) replace
mata mlib add    llfiles *() , dir($pado)
mata mlib index
end


shell xcopy /y "$pado" "$ppersonal" 
discard
lf $pado
cap prog drop lfiles
cap prog drop lf_doexec
mata: mata mlib index

exit


// cap adopath - "P:\Data\SFI_adm_704144\Database_programmer\ckol\Stata\ado"
// cap adopath - "P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado"

// copy P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado\lfiles.ado ///
//  C:\Users\yds4144\ado\personal\ , replace 
// copy P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado\lf_doexec.ado ///
//  C:\Users\yds4144\ado\personal\ , replace 
// copy P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado\llfiles.mlib ///
//  C:\Users\yds4144\ado\personal\ , replace 
//  adopath ++ P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado
 
cd $pado
do copyLfiles_args "`c(pwd)'" "C:\Users\yds4144\ado\personal\"
do copyLfiles_args "`c(pwd)'" "D:\Data\Formater\ado\"


