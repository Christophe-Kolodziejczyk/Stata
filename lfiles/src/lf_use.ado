program lf_use , rclass

		syntax anything
		
		cap use `anything'	
		if (_rc!=0)  {
				if (_rc==4) {
						cap window stopbox rusure "Do you want to clear the memory?"
						if (_rc==0) use `anything' , clear
								// if (_rc>0) error _rc
				}
				else error _rc
		}
		
		return local filename = `anything' 
		return scalar rc      = `: di _rc'

end
