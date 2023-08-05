global flist lfiles.ado lf.ado lf_doexec.ado lf_favorites.ado lfiles.sthlp ///
	llfiles.mlib tostattransfer.ado copyLfiles.do copyLfiles_args.do  ///
	lf_mata_favorites_20210107.do mataLibLfiles-20210108-08-45.do
	
global src 	P:\Data\SFI_adm_704144\VIVE_Programmer\Stata\ado
global dest D:\Data\Formater\ado\

cd $src
foreach x in $flist {
    
	copy `x' $dest , replace
	
} 

dir $dest\l*
