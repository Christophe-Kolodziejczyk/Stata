mata:
struct folder {
	string scalar root 
	string scalar foldername
	string rowvector filesList
	string colvector dirsList
	
	real scalar nFiles , nFolders, folderSize
	real colvector filesSizes
}


string scalar findRootDir(string scalar path)
{

		string rowvector t
		real scalar n 
		real rowvector index, selIndex
		
		t = tokens(path,"\")
		n = cols(select(t,t:=="\"))
	
		index = runningsum(strlen(t))
		selIndex = selectindex(t:=="\")
		
		
		if (n>1) return(substr(path,1,index[selIndex[n-1]]))
		return(pwd())

}

void listDir(string scalar directory,
             string scalar ext, 
             real scalar showDir,
			 real scalar favButton,
			 real scalar expButton)
{

		string scalar pathname, rootDirectory, pathnameWoSlash
		string scalar toBeDisplayed, dirname
		string colvector dirs 
		real scalar i, pos, pLen
		
		pathname = directory

		pLen = strlen(directory)
		
		if (substr(pathname,pLen,1)!="\") pathname = pathname + "\"
		// printf("pathname=%s\n",pathname)
		
		
		pos = strrpos(pathname,"\")
		pathnameWoSlash = substr(pathname,1,pos-1)

		rootDirectory = findRootDir(pathname)
		// subinstr(pathnameWoSlash,pathbasename(pathnameWoSlash),"",.)
// 		printf("{text}Current directory      : {res}%s\n",pwd())
		display("{text}Current directory      : {res}"+ pwd() + " " + buttonAddPath(pwd()) )
		printf( "{text}Parent directory       : {res}%s\n",rootDirectory)
		display(linksToPath(pathname))
		
		string scalar str 
		str = st_global("c(os)") == "Windows" ? sprintf(
		`"{col 40}{stata "winexec explorer "') +
		st_global("c(pwd)") + `"":Explorer}"' : ""
// 		display(str)
		display(`"{stata "lfiles , cls":Clear screen}"' + str)
		display(`"{stata "lfiles .. , nof":..}"') // + rootDirectory + `" , nof cd ":..}"')
		display(`"{stata "lfiles "' + pathname + `" , cd ":.}"')
		
		if (showDir) showDir(pathname, favButton, expButton)
		
}


void showDir(string scalar pathname, 
             real scalar addDirButton,
			 real scalar explorerButton)
{
		string scalar toBeDisplayed, dirname, dir
		string colvector dirs 
		real scalar i, pos, pLen

		// printf("{text}List of directories in : {res}%s{text}\n",directory)
		dirs = ustrltrim(dir(pathname,"dirs","*"))
// 		dirs
// 		ustrsortkey(dirs)
		_sort(dirs,1)
// 		exit()
		if (rows(dirs)==0) printf("No subdirectories found\n")
		else {
            for (i  = 1; i <= rows(dirs) ; i++)
            {
                    dir = pathname + ustrltrim(dirs[i])
                    dirname = dir + "\*"
                    toBeDisplayed = `"{text}<dir>"' +
					(addDirButton ? buttonAddPath(dir) : "") +
					(explorerButton ? buttonStataCmd("winexec explorer ",dir,"[E]"): "") +
					`" {stata "lfiles "' + dirname + `" , cd ":"' +dirs[i]+ "}"

                    display(toBeDisplayed)
            }
            
        }
		

}

real scalar inlist(string colvector x, string rowvector list )
{
		return(sum(x:==list))
}

void listFiles(string scalar directory,
               string scalar pattern,
			   real   scalar size)
{
		string colvector filesList, ext
		string scalar toBeDisplayed, colDis, buttons
		string scalar but1, but2 ,but3, but4, but5, space
		string scalar ibut1, ibut2 ,ibut3, ibut4, ibut5
		real scalar maxLen
		
		struct folder scalar f
		
		filesList = dir(directory,"files",pattern)
		
		if (size) f = folderSize(directory,f,pattern,0) // st_folderSize(f,directory,0)

		
		// maxLen = max(strlen(filesList)) + 10
		// colDis = "{col " +strofreal(maxLen) +"}"
		ibut1 = "[----] "
		ibut2 = "[------] "
		ibut3 = "[--------] "
		ibut4 = "[-------] " //
		ibut5 = "[------] "
		space = "{space 5}"
		buttons = ibut1 + ibut2 + ibut3 + ibut4 + ibut5 + space
		maxLen = strlen(buttons)+max(strlen(filesList)) + 5
		colDis = "{col " +strofreal(maxLen) + "}"
		
		string scalar sasFile, dtaFile, statTrans
		
		
		if (rows(filesList)>0) 
		{
				string colvector filesList2
				
				if (size) 
				{
				
						pointer rowvector units
						units  = detUnits(f.filesSizes)
						filesList2 = filesList :+ colDis :+ 
						strrtrim(strofreal(f.filesSizes:/(*units[1]),"%20.1f")):+ 
						(*units[2])
						// colDis = "{space " +strofreal(maxLen+20) +"}" 
				}
				else filesList2 = filesList
				
				_sort(filesList2,1)
				_sort(filesList,1)
				
				ext = substr(filesList,strrpos(filesList,"."):+1,.)
				real scalar i
				for (i = 1; i<= rows(filesList) ; i++)
				{
					    but1 = ibut1
 						but2 = ibut2
						but3 = ibut3
						but4 = ibut4
						but5 = ibut5
						
						string scalar brFmt, viewFmt
						
												
						// "html","jpeg","tif","emf","eps","doc","xls","xlsx","docx","rtf","pdf","csv"
						brFmt = "$brFmt"
						viewFmt = "$viewFmt"
						
						if (inlist(ext[i],tokens(brFmt)) )
						{
								but1 = printView(directory+filesList[i],"browse","view",1)
						}
						else if (inlist(ext[i],("dta")))
						{						
							
							 dtaFile =  directory + filesList[i]
							 sasFile =  directory + subinstr(filesList[i],".dta","",.)
							 statTrans = dtaFile  + " " + sasFile + " /Y /O"
							 
							 but2 = printStata(dtaFile,"lf_use","use   ")
							 but3 = printStata(dtaFile,"describe using","describe")
							 but4 = printStata(dtaFile,"describe using","des    ",0,", s")
// 							 but2 = printStata(dtaFile ,"lf_use","use   ")
						
						}
	/*					else if (inlist(ext[i],("sas7bdat")))
						{
						

							 dtaFile =  directory+filesList[i]
							 sasFile =  directory+subinstr(filesList[i],"sas7bdat","",.)
							 but4 = printStata(sasFile,"ckuse","toStata",0,", ext(sas7bdat)")
							 // `"[{stata "tostattransfer "'  + sasFile + `" , ext(sas7bdat) " :toStata}] "'
						
						
						} */
						else if (ext[i]=="lff") {
							but2 = `"[{stata "lf_favorites , load("' + 
							directory+filesList[i] + `")":Load  }] "'
						}
						else if (ext[i]=="gph")
						{
                                but1 = printStata(directory+filesList[i],"graph use","view")
						}
						else if (ext[i]=="ster")
						{
								but2 = printStata(directory+filesList[i] ,"estimates use","use   ")
						}	
						else if (inlist(ext[i],("do","mata","ado","sthlp")))
						{

								string scalar filename
								filename = directory+filesList[i]
								but1 = `"[{view  "' + quote(filename) + `":view}] "' // 
								but2 = printStata(filename,"doedit","doedit")
								if (ext[i]!="sthlp") {
										but3 = printStata(filename,"do", "do      ")
										but4 = printStata(filename,"run","run    ")
										but5 = printStata(filename,"lf_doexec","doexec")
								} 
								
						}
						else if (inlist(ext[i], tokens(viewFmt))) // ("do","ado","mata","sthlp","stcmd","txt","bat","log","sas","smcl")))
						{
								string scalar fname, quote
								quote = `"`"" "'"'
								fname = quote + directory+filesList[i] + quote 
								but1 = "[{view " + fname + " :view}]"
								fname = char(96)+ 2*char(34) + directory+filesList[i]  + 2*char(34)+ char(39)
								but1 = `"[{view  "' + fname + `":view}] "' 
						}
						/*
						else 
						{
// 								string scalar fname, quote
								quote = `"`"" "'"'
								fname = quote + directory + filesList[i] + quote 
								but1 = "[{view " + fname + " :view}]"
								fname = char(96)+ 2*char(34) + directory+filesList[i]  + 2*char(34)+ char(39)
								but1 = `"[{view  "' + fname + `":view}] "' 
						}*/
						
						buttons = but1 + but2 + but3 + but4 + but5 + space
						toBeDisplayed = buttons + filesList2[i]
						display("{res}"+toBeDisplayed)
				}
		}
		else if (sum(pattern:!=("*",""))>0)  printf("No files found\n")


}

string scalar printView(string scalar s, 
                        string scalar cmd,
						string scalar tag,|	real scalar noquote)
{

		string scalar sname
		sname = args() > 3 & noquote ? s : quote(s) 
// 		return(`"[{"' + cmd + `" ""' + s+ `"":"' + tag + "}] ")
		return(`"[{"' + cmd + `" ""' + sname + `"":"' + tag + "}] ")

}

string scalar quote(s) return(char(96)+ 2*char(34) + s + 2*char(34)+ char(39)) 
string scalar squote(s) return(char(34) + s + char(34)) 

string scalar printStata(string scalar s, 
                         string scalar cmd,
						 string scalar tag,| real scalar quotes, string scalar options)
{ 
		if (args() <= 4) options = ""
		if (args() <= 3) quotes = 0
		
// 		quotes
// 		if (quotes) return(`"[{stata ""' + cmd + `" ""' +  s + `"""' + options + `"":"' + tag + "}] ")
// 		else return(`"[{stata ""' + cmd + " " + s + options +`"":"' + tag + "}] ")

		string scalar sname, lquote, rquote, command
		sname =  quote(s)
		
		lquote = char(96) + char(34) ;
		rquote = char(34) + char(39)
		command = lquote + cmd + " " + squote(s)  + options	+ rquote
// 		command
// 		return(`"[{stata"' + quote( cmd + " " + s + options) + ":" + tag + "}]")
		return(`"[{stata "' + command + ":" + tag + "}] ")
}

pointer rowvector detUnits(real colvector x)
{
		
		real colvector numFig , divisor
		string colvector units, strNumFig
		real scalar i
		
		numFig = strlen(strofreal(x,"%20.0f"))
		strNumFig = strofreal(numFig)
		
		divisor = round((numFig:-1)/3)
		units  = J(rows(divisor),1,"")
		
		for (i = 1 ; i <= rows(divisor) ; i++)
		{
				if (divisor[i]==0) units[i] = "K"
				else if (divisor[i]==1) units[i] = "M"
				else if (divisor[i]==2) units[i] = "G"
				else units[i] = "G"
		}
		
		// _editvalue(divisor,0,1)
		
		divisor = 1024:^divisor

		return( (&divisor,&units))

}

void splitFilename(string scalar filename)
{
		string scalar path, file
		real scalar pLen, root
		
		root = 0
		
		filename = usubinstr(filename,"/","\",.)
		// test if syntax is .. then return the root directory
		if (strtrim(filename)=="..") 
		{
				filename=pwd()
				filename = substr(filename,1,strlen(filename)-1)
				root = 1
		}
		
		// test if it's only a pathname
		// a pathname does not contain an * or . (extension)	
		// filename
		// regexm(filename,"\.|\*")
		
		if (regexm(filename,"\.|\*")|root) 
		{
				pathsplit(filename,path="",file="")
				
		}
		else 
		{
		// "no split"
				path = filename
				file = ""
		}
		

		pLen = strlen(path)
		if (substr(path,pLen,1)!="\"&!root) path =  (strtrim(path)!="" ? path+"\" : "")
		// printf("pathname=%s\n",path)
		
		if (path=="") path = pwd()
		// if (file=="") file = ""
		
		
		st_local("file",file)
		st_local("path",path)
		

}


real scalar fileSize(string scalar filename)
{
		real scalar fh, start, eof
		
		if (!fileexists(filename))
		{
				return(-99)
		}
		
		fh = fopen(filename,"r")
		start = ftell(fh)
		fseek(fh,0,1)
		eof = ftell(fh)
		fclose(fh)
		
		return(eof-start)
}

struct folder scalar folderSize(string scalar foldername,
                                struct folder colvector F,
								string scalar pattern,
								real scalar recursive)
{
		struct folder scalar f
		string rowvector filesList
		real rowvector filesSizes
		real scalar nFiles, i, maxLength
		string scalar root
		
		f.root = foldername
		
		
		// f.nFolders = ( f.nFolders==. ? 1 : f.nFolders + 1)
		
		// foldername
		f.foldername = foldername
		f.filesList = dir(foldername,"files",pattern)
		f.dirsList  = dir(foldername,"dirs","")
		
		
		f.nFiles = rows(f.filesList)
		f.filesSizes = J(f.nFiles,1,.)
		
		root = f.root
		for (i = 1; i<=f.nFiles; i++)
		{
				string scalar filename
				filename = strtrim(root)+"\"+strtrim(f.filesList[i,1])
				// fileSize(filename)
				f.filesSizes[i,1] = fileSize(filename)

		}
		
		_editvalue(f.filesSizes,-99,.)
		f.filesSizes = f.filesSizes/1024
		f.folderSize = sum(f.filesSizes)
		
		F = F\f
		string colvector dirsList
		dirsList = f.dirsList
		
		root = f.root 
		if (rows(dirsList)!=0 & recursive )
		{
				for (i = 1; i <= rows(dirsList);i++)
				{
						f = folderSize(root+"\"+dirsList[i,1],F,pattern,recursive)
				}
		
		}
		
		return(f)
}

string scalar linksToPath(pathname)
{
		string vector elem
		string scalar str , path, quote, sep
		real scalar i
		
		elem = subinstr(pathname,"\",";",.)
		elem = pathlist(subinstr(elem,"/",";",.))

		str = path = ""
		sep = ">>"
		for ( i = 1; i <=length(elem); i++)
		{
			path = path  + elem[i] + "\"
			quote = `"""'
			str = str +  sep + `"{stata "lfiles "' + path + `" , nof ":"' + elem[i] + `"}"'
		}

		return(str+sep)	
}

void testDir(pathname)
{
	if (!direxists(pathname)) 
	{
			printf("{err}Folder does not exist or can't be opened!{text}\n")
			exit(error(170))
			
	}
}

string scalar buttonStataCmd($SS cmd,
                             $SS cmdArg, 
                             $SS buttonLabel)
{
		$SS lquote , rquote, cmd2
		lquote = char(96) + char(34) ;
		rquote = char(34) + char(39)
		cmd2 = lquote + cmd + " " + squote(cmdArg) + rquote
		toDisplay = direxists(cmdArg) ? `"{stata "' + cmd2 + ":" + buttonLabel + "}" : buttonLabel 
        
        return(toDisplay)
}

end
