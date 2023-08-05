*! lls, CKK 09-01-2017
program lfiles , sclass

		syntax [anything(name=path)] , [noDir noFiles nocd Size cls LFAVorites Exp Add]


		local nSize = 0
		if ("`size'"!="") local ++nSize

		if (`"`path'"'!="") local path = subinstr(`"`path'"',`"""',"",.)
		_splitfilename "`path'"

		// sret li

		if ("`s(path)'"=="") local path "`c(pwd)'"
		if ("`cd'"==""|trim("`path'")=="..") qui cd `"`s(path)'"'
		
		
		mata:testDir("`s(path)'")

		if("`cls'"!="") cls
		if ("`dir'"!="") mata:listDir("`s(path)'","`s(file)'",0,0,0)
		else mata:listDir("`s(path)'","`s(file)'",1,"`add'"!="","`exp'"!="")
		
		if ("`files'"=="") mata:listFiles("`s(path)'","`s(file)'",`nSize')
		else {
				di "List of files not shown."
				di `"{matacmd `"listFiles("`s(path)'","`s(file)'",`nSize')"':show files}"'
		}
		
		if ("`lfavorites'"!="") {
			di "List of favorites"
			lf_favorites , list
		}
		else lf_favorites
		


end

prog _splitfilename , sclass

		args filename

		mata:splitFilename("`filename'")
		sret clear

		sreturn local filename = "`filename'"
		sreturn local file = "`file'"
		sreturn local path = "`path'"


end

prog refresh

		syntax [anything(name=path)] ,[*]
		
		cls 
		lfiles , `options'

end
