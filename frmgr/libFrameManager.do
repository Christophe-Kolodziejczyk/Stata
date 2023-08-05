mata:mata set matastrict off
global quote char(34)
clear mata
mata:
class c_frame {

	string scalar framename, filename
	real scalar  nVars, nObs
		
	void getInfo()
	
}


void c_frame::getInfo(string scalar name)
{
	framename = name
	st_framecurrent(framename)
	nVars = st_nvar() ; nObs = st_nobs()
	filename = c("filename")
	if (filename!="") filename= pathbasename(filename)

} 

struct framestate
{
	string scalar curr_frame
	string vector framelist, nObs_nVars, filenames
	class c_frame  vector frInfo
	real   vector hasChanged, lengthNames
	real   scalar nFrames, maxLength, maxLength2
}


void frm_update(struct framestate scalar fs)
{
	fs.curr_frame = st_framecurrent()
	fs.framelist  = st_framedir()
	fs.nFrames    = length(st_framedir())
	fs.lengthNames = strlen(fs.framelist)
	
	fs.nObs_nVars = fs.filenames = J(fs.nFrames,1,"")
	fs.frInfo = c_frame(1,fs.nFrames)
	frm_hasChanged(fs)
	
	real scalar i
	for (i =1 ; i <= fs.nFrames; i++)
	{
		fs.frInfo[i].getInfo(fs.framelist[i])
		fs.nObs_nVars[i] = sprintf(" ( %g x %g)",fs.frInfo[i].nObs,fs.frInfo[i].nVars)
		// "( " + strtrim(strofreal(fs.frInfo[i].nObs)) +
		// " x " + strtrim(strofreal(fs.frInfo[i].nVars)) + " )"
	}
// 	fs.nObs_nVars
// 	strlen(fs.nObs_nVars)
	fs.maxLength2 = max(strlen(fs.nObs_nVars))
	fs.maxLength = max(fs.lengthNames)
	st_framecurrent(fs.curr_frame)
}

void frmgr_update()
{
	struct framestate scalar fs
	
	frm_update(fs)
	printf("{text}Current frame is {res}%s{text}\n", fs.curr_frame)
	
}
void frameManager()
{
	
	struct framestate scalar fs
	
	frm_update(fs)
	listFrames(fs)
	
}

void printCurrentFrame(struct framestate scalar fs) 
{
	printf("{text}Current frame is {res}%s{text}\n", fs.curr_frame)
	
}

void changeFrame(string scalar framename)
{
		struct framestate scalar fs
		rc = _st_framecurrent(framename,1)
		if (rc==0) {
// 			printf("Current frame is now %s \n",st_framecurrent())
			frameManager()
			
		}
		else exit(rc)
// 		display("{stata browse}")
	
	
}

void dropFrame(string scalar framename)
{
	
		stata(`"cap window stopbox rusure "Do you want to remove the frame from memory?""')
// 		stata("di _rc")
		stata("scalar rc = _rc")
		st_numscalar("_rc")
		if (st_numscalar("rc")!=0) {
			printf("Frame %s has not been removed \n",framename)
			return
// 			exit()
		}
		rc = _st_framedrop(framename,1)
		if (rc==0) {
			printf("Frame %s has been removed \n",framename)
// 			frameManager()
			
		}
		else exit(rc)
// 		display("{stata browse}")
	
}

void frm_mainMenu(struct framestate scalar fs)
{
	
	printf("{text}Current frame: {res}%s{text}\n",fs.curr_frame)
	toDisplay = "<{stata browse}>{space 2}<{stata describe}>{space 2}<{stata des , s:des}>" 	+ "{space 2}"+"<{stata frmgr:update}>"
	display(toDisplay)
	printf("\n")
	
}


void frm_hasChanged(struct framestate scalar fs)
{
	
		fs.hasChanged = J(fs.nFrames,1,0)
		for ( i = 1; i <= fs.nFrames ; i++)
		{
				rc = _st_framecurrent(fs.framelist[i],0)
				if (rc==0) fs.hasChanged[i] = c("changed")
				
			
		}
		st_framecurrent(fs.curr_frame)
	
}

void listFrames(struct framestate scalar fs)
{
		real scalar i, def
		string scalar fr
		
		frm_mainMenu(fs)
		
// 		fs.maxLength
		col = "{col " + strofreal(fs.maxLength + 15) + "}"
// 		col
		for ( i = 1; i <= length (fs.framelist) ; i++)
		{
			fr  = fs.framelist[i]
			def = (fr == st_framecurrent()) 
			but3 = def ? col + "{err} <--{text}" : ""
			
			but2 = `"{matacmd changeFrame(""' + fr  + `""):"'+ fr + "}" 
			but1 = fr != st_framecurrent() ? `"{matacmd dropFrame(""' + fr  + `""):[-]}"' : "[-]"
			but4 = fs.hasChanged[i] ? col + (def ? "{space 1}": "{space 5}" ) + "{hi: *}" : ""
		    display(but1 + 2*char(32) + but2 + but3 + but4)	
// 			display("{stata frame change " + fr +  ":" + fr +"}")	
//             display(`"{matacmd changeFrame(""' + fr  + `""):"'+ fr + "}" )	
		}
		printf("\n{err}<--  {text}Current fame\n") //  ; {hi}*{text}    Unsaved data\n")
		printf("{hi}*{text}    Unsaved data\n")
		
	
}

void brFrame(string scalar frame)
{
	stata("frmgr , change("+ frame+") br")
// 	stata("browse")
// 	stata("frmgr , br ") // _update()")
	
}

void browseFrames(struct framestate scalar fs)
{
	real scalar i
	
	toDisplay = `"{matacmd brFrame(""' :+fs.framelist :+ `""):"' :+ fs.framelist :+ `"}"'
	
	real vector cur_Frame
	cur_Frame = (fs.curr_frame:==fs.framelist)
	
	for (i = 1 ; i<= fs.nFrames; i++)
	{
		
		if (cur_Frame[i]) printf("{err}*{text}%s{err}*{text}{space 2}",toDisplay[i])
		else printf("<%s>{space 2}",toDisplay[i])
		if (mod(i,5)==0) printf("\n")
		
	}
	printf("\n")
	
}

void frameBrowser()
{
	
	struct framestate scalar fs
	
	frm_update(fs)
	browseFrames(fs)
	printCurrentFrame(fs)
	
}


void showFrames(struct framestate scalar fs)
{
	
	
	quoteFrlist = $quote :+ fs.framelist :+ $quote 
	curfr = (fs.framelist :== st_framecurrent())
	
	
	real scalar start 
	start = 20
	
// 	start = start + fs.maxLength2 + 5
	colfr   = "{col " + strofreal(start+ 5) + "}"
	start = start + fs.maxLength + 5
	
// 	strofreal( start + fs.maxLength + 2) 
	k1 = 1; k2 = 5 ; k3 = 9;
	col2    = "{col " + strofreal(start + k2 ) + "}"
	col1    = "{col " + strofreal(start + k1) + "}"
	colnobs = "{col " + strofreal(start + k3) + "}"  // + maxLength2
// 	col3    = "{col " + strofreal(start + 5 ) + "}"
	start   = start + fs.maxLength2 +  k3
	col3    = "{col " + strofreal(start + 2) + "}"
// 	col1 
// 	col2
	
 
	arrow = curfr:*( col1 :+ "{err}<--{text} ")
	unsaved = fs.hasChanged:*(col2 :+ "{txt}*")
	but1 = !curfr:*("{matacmd action(" :+ quoteFrlist :+ `","-"):[-]} - "') :+ 
		curfr:*"{text}[-] - "
	but2 = "{matacmd action(" :+ quoteFrlist :+ `","B"):[B]}"'
	but3 = "{matacmd action(" :+ quoteFrlist :+ `","D"):[D]}"'
	but4 = "{matacmd action(" :+ quoteFrlist :+ `","d"):[d]}"'
	but4b = "{matacmd action(" :+ quoteFrlist :+ `","ds"):[ds]}"'
	but5 = "{matacmd action(" :+ quoteFrlist :+ "):" :+ fs.framelist :+"}"
	
// 	but2 = "{stata frame " :+ fs.framelist :+ "browse:[B]}"
// 	but3 = "{stata frame " :+ fs.framelist :+ ": describe, full:[D]}"
// 	but4 = "{stata frame " :+ fs.framelist :+ ": des , s:[d]}"
	
	real scalar i
	

	toDisplay = but1 + but2 + but3 + but4 + but4b :+ colfr :+ but5 +  arrow :+ unsaved :+
	colnobs // :+ fs.nObs_nVars
// 	colnobs 
// 	col3 
// 	toDisplay
	printf("{res}{hline}\n")
	printf("Framemanager\n")
	printf("{hline}{text}\n")
	printf("{ul on}Actions{ul off}" + colfr + "{ul on}Frame{ul off}" + 
		col1 + "{ul on}C{ul off}" + col2 + "{ul on}M{ul off}" +
		colnobs + "{ul on}Size{ul off}" + col3 + "{ul on}Filename{ul off}\n\n")
	for (i = 1; i <= fs.nFrames ; i++)
	{
		nobs = sprintf("( {res}%g {txt}x {res}%g{txt} )",fs.frInfo[i].nObs,fs.frInfo[i].nVars)
		display(toDisplay[i] + nobs + col3 + fs.frInfo[i].filename)
		
	}
	
	printf("\n[-] = Remove ; B = browse ; D = describe ; d = des , s ; ds = ds , a \n")
	printf("{err}<--  {text}Current fame ({res}%s{text})\n",fs.curr_frame) //  ; {hi}*{text}    Unsaved data\n")
	printf("{hi}*{text}    Unsaved data\n")
	printf("Note: The current frame cannot be removed!\n")
	printf("{stata framemanager:Update}\n")
	

}

void action(string scalar framename,| string scalar action)
{
	
	if (args()>1 & action == "-") {
// 		"remove frame "
		dropFrame(framename)
		frameBrowser2()
	}
	else {
// 		"pouet"
		if (args()==1) {
			stata("frame change " + framename) // changeFrame(framename)
			frameBrowser2()
		}
		else if ( args() > 1 ) {
			string cmd 
			cmd = "frame "+ framename + ":" 
			if (action=="B") {
			    stata("frame change " + framename)
				stata("browse")
				frameBrowser2()
			}
			else {
			    if (strlower(substr(action,1,1))=="d") printf("{txt}Description of {res}%s{txt}\n",framename)
			    if (action=="D") stata(cmd + "describe , full")
				else if (action=="d") stata(cmd + "describe , s ")
				else if (action=="ds") stata(cmd + "ds , a")
				display("")
				display("{stata framemanager : Update framemanager}")
			}
		}
		
	}
	
// 	frameBrowser2()
	
	
}

void frameBrowser2()
{
	struct framestate scalar fs
	
	frm_update(fs)
	showFrames(fs)
// 	printCurrentFrame(fs)
	
		
}


end


lmbuild lfrmanag , replace dir(PERSONAL)
// frmgr ,br
mata:frameBrowser2()
shell xcopy R:\Stata\frmgr\*.ado C:\Users\B247696\ado\personal /y
