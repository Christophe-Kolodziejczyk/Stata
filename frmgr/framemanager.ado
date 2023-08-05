prog framemanager

		syntax [anything] , [BRowser change(string)]

		if ("`browser'"!="" & "`change'"=="") mata:frameBrowser()
		else if ("`change'"!="") frmgr_change `change' `browser'
		else mata:frameBrowser2()
// 		else mata:frameManager()

		

end

prog frmgr_change
	
	args frame br
	frame change `frame'
	if ("`br'"!="") {
		browse
		
	} 
	frmgr , browser
end







