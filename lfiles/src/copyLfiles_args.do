global flist lfiles.ado lf.ado lf_doexec.ado lf_favorites.ado lfiles.sthlp ///
	llfiles.mlib tostattransfer.ado copyLfiles.do copyLfiles_args.do ///
	lf_mata_favorites_20210107.do mataLibLfiles-20210113-08-45.do
	
global src 	`1' // P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado
global dest `2' // D:\Data\Formater\ado\

cd $src
foreach x in $flist {
    di "`x' $dest"
	copy `x' $dest , replace
	
} 

dir $dest\l*
