


// clear mata
mata:
void createAsarray()
{
// 		printf("A will be now created\n")
		stata("qui mata: $A = AssociativeArray()")
		stata(`"qui mata: $A.reinit("string")"')
	
}

void fav_exists()
{
    pointer ext 
	ext = findexternal("$A")
    if (ext==NULL) createAsarray()
	else if ( eltype(*ext) != "class" | classname(*ext) !="AssociativeArray" ) createAsarray()

// 	else {
// 	    printf("A exists already\n")
// 	}
	
	
}


void addPath($AAS $A, $SS path)
{
		
		if (direxists(path)) 
		{
		    $A.put(path,"")
			printf("{text}%s added to favorites\n",path)
			
			string str
// 			str = sprintf("{stata lf_favorites , list  : List favorites}{space 5}" +
// 			"{stata lf_favorites , reset :Reset favorites}{space 5}"+ 
// 			"{stata lf_favorites , wload :Load favorites}{space 5}"+
// 			"{stata lf_favorites , wsave :Save favorites}")
// // 			display("{stata lf_favorites , list : List favorites}{stata lf_favorites , reset :Reset favorites}")
// 			display(str)
			buttonFavorites()
		}
		else printf("{err}Path %s does not exist\n",path)
	
}


void removePath($AAS $A, $SS path)
{
		
		if ($A.N()>0 & $A.exists(path)) $A.remove(path)
		else if ($A.N()<=0) printf("Favorites empty")
		else printf("{err}Cannot be removed! Path %s does not exist\n",path)
	
}


void addCurrentPath($AAS $A)
{
    lquote = char(96) + char(34) ;
	rquote = char(34) + char(39)
	cmd2 = lquote + "mata addPath($A," + squote(pwd()) + ")" + rquote
	toDisplay = `"{stata "' + cmd2 + ":[+] }" 
	
	
	display(toDisplay)
	listPaths($A)
}

string scalar buttonAddPath($SS path)
{
	$SS lquote , rquote, cmd2
    lquote = char(96) + char(34) ;
	rquote = char(34) + char(39)
	cmd2 = lquote + "mata addPath($A," + squote(path) + ")" + rquote
	toDisplay = direxists(path) ? `"{stata "' + cmd2 + ":[+] }" : "[+] " 
	
	return(toDisplay)
}

void addPathToFavorites($AAS $A,path)
{
    lquote = char(96) + char(34) ;
	rquote = char(34) + char(39)
	cmd2 = lquote + "mata addPath($A," + squote(path) + ")" + rquote
	toDisplay = `"{stata "' + cmd2 + ":[+] }" 
	
	display(toDisplay)
	listPaths($A)
}


void Favorites() 
{
    display("{matacmd listPaths($A):Favorites}")
	display("{stata lf_favorites , reset :Reset favorites}")
	
}

void listPaths($AAS $A)
{
    $RS i, N
	string vector keys
	$SS str, lquote, rquote, command, toDisplay
	
	lquote = char(96) + char(34) ;
	rquote = char(34) + char(39)
		
	
	N = $A.N()
	keys = $A.keys()
	
	if (N==0)
	{
	    printf("{text}Favorites empty\n")
		return		
	}
	
    for (i = 1; i <= $A.N() ; i++)
	{
	    
// 		str = "cd " + squote(keys[i])
// 		str = quote(str)

		cmd1 = lquote + "lf " + " " + squote(keys[i])	+ rquote
		cmd2 = lquote + "mata removePath($A," + squote(keys[i]) + ")" + rquote
		toDisplay = `"{stata "' + cmd2 + ":[-] }" +
		`"{stata "' + cmd1 + ":" + keys[i] + "} " 
		
		
	    display(toDisplay)
// 		printStata(keys[i],"cd","moef")
		
	}
	
// 	Favorites()
	
}


void saveFavorites($SS filename,string vector pathsFav)
{
		real scalar rc
		
		rc = _unlink(filename)
		if (rc>0) printf("replacing %s\n",filename)
		else if (rc < 0)
		{
				printf("File cannot be replaced")
		}
		fh = fopen(filename,"w") 
		fputmatrix(fh,pathsFav)
		fclose(fh)
	

}

string vector loadFavorites($SS filename)
{
	string vector s
	fh = _fopen(filename,"r")
	if (fh >= 0) {
			s  = fgetmatrix(fh)
			fclose(fh)
	}
	return(s)
}

$AAS initFavorites(string vector favorites)
{
	$AAS A
	A = AssociativeArray()
	A.reinit("string")
	
	real scalar N
	N = length(favorites)
	if ( N > 0) {
		real scalar i 
		for (i = 1; i <= N ; i++ )
		{
			A.put(favorites[i],"")
		}
		
	}
	
	return(A)
	
}

string vector arrayToVector($AAS A)
{
	real scalar i, N
	string vector paths
	N = A.N()
	paths = A.keys()
	return(paths)
}
void buttonFavorites()
{
	 display("<{stata lf_favorites , list  :List favorites}>{space 5}" +
			"<{stata lf_favorites , reset :Reset favorites}>{space 5}" + ///
			"<{stata lf_favorites , wload :Load favorites}>{space 5}" + ///
			"<{stata lf_favorites , wsave :Save favorites}>")
	
}
end
exit

// mata:A = AssociativeArray()
// A.reinit("string")
mata:fav_exits()
mata:addPath(A,"c:\")
mata:addPath(A,"D:\data\workdata\")
mata:addPath(A,"P:\data")
mata:listPaths(A)
mata:removePath(A,"z:\data")
mata:listPaths(A)

// mata:display(`"{stata `"cd "c:\""': c:\}"')
// mata:display("{matacmd listPaths(A):historic}")
mata:Favorites()
mata:addCurrentPath(A)

