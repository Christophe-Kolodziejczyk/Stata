*! lf_favorites
prog lf_favorites

	
	syntax , [reset list save(string) load(string) wload wsave] 
	
	if ("`reset'"!="") mata:createAsarray()
	else if ("`list'" !="") mata: listPaths(_lf_fav)
	else if ("`wsave'"!="") lf_wsaveFavorites 
	else if ("`wload'"!="") lf_wloadFavorites
	else if ("`save'"!="") lf_saveFavorites `save'
	else if ("`load'"!="") lf_loadFavorites `load'
	if ( "`reset'"=="" & "`wsave'"=="" & "`wload'"=="" & "`load'" =="" & "`save'"=="") {
			mata: fav_exists()
// 			mata: addPathToFavorites(A,"`s(path)'")
// 			mata: listPaths(A)
			mata:buttonFavorites()
// 			di "<{stata lf_favorites , list  :List favorites}>" _skip(5) ///
// 			"{stata lf_favorites , reset :Reset favorites}" _skip(5) ///
// 			"{stata lf_favorites , wload :Load favorites}" _skip(5) ///
// 			"{stata lf_favorites , wsave :Save favorites}"
	}


end


prog lf_wloadFavorites

	capture window fopen f_to_open "Open favorites file" ///
		"Favorites lfiles|*.lff" // "lff"
		
// 	if (_rc == 0) {
// 		confirm file  $f_to_open // `filename' 
// 		mata:paths = loadFavorites("$f_to_open")
// 		mata: _lf_fav = initFavorites(paths)
// 		mata: listPaths(_lf_fav)
// 	}

	if (_rc == 0) {
			lf_favorites , load($f_to_open)
// 			di "{text}Favorites {res}$f_to_open{text} loaded."
// 			di "{stata lf_favorites , list  : List favorites}"
	}
	

end


prog lf_wsaveFavorites


	
	capture window fsave f_to_save "Save favorites file" ///
		"Favorites lfiles|*.lff" // "lff"
// 	if (_rc == 0) {
// 		mata: paths = arrayToVector(_lf_fav)
// 		mata:saveFavorites("$f_to_save",paths)
//		
// 	}
	
	if (_rc == 0) {
		lf_favorites , save($f_to_save)
		di "{text}Favorites saved to {res}$f_to_save{text}."
		di "{stata lf_favorites , list  : List favorites}"
	}

end 

prog lf_loadFavorites

	args filename
	
	mata: fav_exists()
	confirm file `filename' 
	mata:paths = loadFavorites("`filename'")
	di "{text}Favorites {res}`filename'{text} loaded."
	mata: _lf_fav = initFavorites(paths)
	di "Your favorites"
	mata: listPaths(_lf_fav)	
	
	

end


prog lf_saveFavorites

	mata: fav_exists()
	args filename	
	mata: paths = arrayToVector(_lf_fav)
	mata:saveFavorites("`filename'",paths)
		


end 




// syntax 
// lf_fa