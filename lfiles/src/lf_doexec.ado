*! lf_doexec
* 17-05-2021 : option for appending the date & time to logfile 
* 10-06-2020 : possibility to pass arguments to the do-file
* Modified 15-01-2020: program finds the correct executable depending oh the system values
* Modified 13-01-2020: Possibility to choose between winexec and shell (async or not)
prog lf_doexec

		syntax anything , [b Shell Date]
		
		local path `c(pwd)'
		
		if ("`b'"!="") local mode /b
		else local mode /e
		
		// Asynchrone
		if ("`shell'"!="") local exec shell 
		else local exec winexec
		
		// Date
		if ("`date'"!="") {
			local fmt %tcCCYYNNDD-HH-MM-SS
			local datetimeStr `c(current_date)' `c(current_time)'
			di "`datetimeStr'"
			local datetime = clock("`datetimeStr'","DM19Yhms")
			local dateStr : di `fmt' `datetime'
		}
		
		gettoken file args  : anything
		
		di `"Filename : `file'"'
		di `"Arguments: `args'"'
		
		if (`c(SE)'==1) local flavor SE
		if (`c(MP)'==1) local flavor MP
		
		global stataExec "`c(sysdir_stata)'Stata`flavor'-`c(bit)'.exe"

		
		di "Executable: $stataExec"
		
		confirm file `file'
		splitfilename "`file'"

		
		
		qui cd "`s(path)'"
		`exec' "$stataExec"  ///
			`mode' do "`s(file)'" `args'
		cd `path'
		
		mata:st_local("logfile",pathrmsuffix("`s(file)'")+".log")
		
		di `"{view "`s(path)'\\`logfile'":[View log file]}"'
		di `"{stata `"lf_doexec `0'"':[Redo]}"'
		


end

prog splitfilename , sclass

		args filename
		
		//di reverse("`filename'")
		
		mata: filename = usubinstr("`filename'","/","\",.)
		mata:pathsplit(filename,path="",file="")
		
		// mata:path,file
		mata:path =  (strtrim(path)!="" ? path+"\" : "")
		mata:st_local("file",file)
		mata:st_local("path",path)
		
		if ("`path'") == "" local path `c(pwd)'
		
		sret clear

		sreturn local filename = "`filename'"
		sreturn local file = "`file'"
		sreturn local path = "`path'"


end
