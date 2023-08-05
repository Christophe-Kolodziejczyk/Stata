{smcl}
{* *! version 1.0.0 16-01-2017}{...}
{vieweralsosee "[R] help" "help help "}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:lfiles} {hline 2} Makes a list with hyperlinks of files and subdirectories included in a specific folder 


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:lfiles}  [{cmd:"}][{it:filespec}][{cmd:"}], {cmd:[}{it:option}{cmd:]}
{p2colreset}{...}

{pstd}
{it:filespec} is any valid Windows path or file specification. You can use {hilite:*} as {hilite:wildcards}. 
{p_end}

{title:Description}

{pstd}
{cmd:lfiles} lists files and subdirectories in a directory with hyperlinks. It follows the same syntax as {manhelp dir R}. The difference is that it is {hi:not} compulsory to use double quotes to enclose file specification which include spaces, but it is allowed. You can use {hilite:wildcards}, i.e. {hilite:*} and you can also specify a path or a full file specification. If the former case, you will change the current directory to the underlying path unless you specify the nocd option. These hyperlinks can be seen as buttons, which will trigger different actions from Stata depending on the context and/or the file extension.  If you do dot specify a path, then files in the current directory will be listed. Links to subdirectories redirect to these folders. You can navigate across folders by clicking and those links.
{p_end}

{pstd}
The program works mainly for Windows. Some of the features might work on other OS, but they have not been tested for different OS.
{p_end}

{title:Descriptions of the output from {cmd:lfiles}}

{pstd}
Below is an example of an output after having typed {cmd:lfiles} in the command-line.
{p_end}

{pstd}
{cmd:. lfiles}{break}
Current directory      : {bf:C:\Users\Christophe\Stata\} {hi:[+]} {break}
Root directory {space 3}: {bf:C:\Users\Christophe\}{break}
>>{hi:C:}>>{hi:Users}>>{hi:Christophe}>>{hi:Stata}>>{break}
{hi:Clear screen}{space 20}                           {hi:Explorer}{break}
{hi:.}{break}
{hi:..}{break}
<{hi:dir}>{hi:[+] [E] My data}{break}
<{hi:dir}>{hi:[+] [E] Rawdata}{break}
<{hi:dir}>{hi:[+] [E] do-files}{break}
[----] [{hi:use}{space 3}] [{hi:describe}] [-------] [------]      auto.dta{break}
[{hi:view}] [------] [--------] [-------] [------]      estAuto.rtf{break}
[----] [{hi:use}{space 3}] [--------] [-------] [------]      estAuto.ster{break}
[{hi:view}] [------] [--------] [-------] [------]      example.log{break}
[{hi:view}] [------] [--------] [-------] [------]      example.smcl{break}
[{hi:Load}] [------] [--------] [-------] [------]      myfavorites.lff{break}
[{hi:view}] [{hi:doedit}] [{hi:do}{space 6}] [{hi:run}{space 4}] [{hi:doexec}]      testLfiles.do{break}
<{hi:List favorites}>     <{hi:Reset favorites}>     <{hi:Load favorites}>     <{hi:Save favorites}>{break}
 {p_end}
 
{pstd}
{cmd: lfiles} makes a list of files and directories, there are any. 
The first line gives the current directory. You can add the directory to your favorites (see section on favorites further below) by clicking on [+]. The second line gives the root directory, that is the folder one level up.
The third line of the output gives the path of the current directory. Each level is shown with a links. Clicking on these links will lead you to the folder corresponding to this level. Clicking on Users will change to C:\Users. 
Click on {hi:.} to refresh the output. {hi:Clear screen} will more or less do the same but will clear the screen at the same time (see {manhelp cls R}). The button {hi:..} will change directory to the root directory (one level up). 
On Windows click on {hi:E} or {hi:Explorer} to open Windows Explorer to respectively the folder on the right of the button or the current folder.  
{p_end}

{pstd}
Clicking on the directories' name will change the current directory and show you the content of the directory. By default, it will not show you the list of files, but a button "show files" will you give the possibility to show it.
{p_end}

{pstd}
Each filename is preceded by five buttons, which are links performing different events depending on the file extension. The first button allows to view the file. If it is a text file, i.e. not binary, Stata's viewer is called. Otherwise the relevant program is opened, if it is installed on your computer. *.xlsx files are opened with excel and *.docx with Word. The other buttons will be different depending on the context. If it is a do-file (*.do, *.ado,*.mata), you will be able to edit the file or run the do-file (silently or not). The link with doexec wil run the do-file in batch mode. If is a Stata dataset you will be able to use and describe the file.
If the file has the extension *.ster (Stata's estimates files), you will be able to load the file in memory. 
{p_end}

{title:Options}

{synoptset 20 tabbed}
{synopthdr}
{synoptline}

{synopt :{opt nod:ir}} Omit the list of directories{p_end}
{synopt :{opt nof:iles}} Omits the list of files{p_end}
{synopt :{opt size}} List the size of the files{p_end}
{synopt :{opt cls}} Clear the screen before outputting{p_end}
{synopt :{opt nocd}} show the content of the folder while staying in the current directory{p_end}


{title:File extensions}

Files which you will be able to view:
do, ado, mata, sthlp, stcmd, txt, bat, log, lst, sas, smcl, tex, r

Files which can be browsed if the appropriate program is installed:

html, jpg, jpeg, tif, emf, wmf, eps, doc, docx, xls, xlsx, rtf, pdf, csv, scsv

lf is short for lfiles and can be used instead of lfiles
{title:Examples}

{p 8 17 2}
{stata lfiles :. lfiles} {p_end}
{pstd}
List all the files and subdirectories in your current directory. {p_end}

{p 8 17 2}
{stata lfiles .. :. lfiles ..} {p_end}
{pstd}
List all the files and subdirectories in the parent directory. {p_end}

{p 8 17 2}
{cmdab:. lfiles *.do} {p_end}
{pstd}
List all the files in the current directory with the extension {hilite:.do}.

{p 8 17 2}
{cmdab:. lfiles res*.xlsx} {p_end}
{pstd}List all the files in the current directory beginning with res and with
 the extension {hilite:xlsx}.

{p 8 17 2}
{cmdab:. lfiles res*.xlsx} {p_end}
{pstd}List all the files in the c-drive beginning with res and with
 the extension {hilite:xlsx}.
 
{p 8 17 2}
{cmd:. lfiles c:\res*.xlsx} {p_end}
{pstd}List all the files on the c-drive. By default lfiles will change the current directory

{p 8 17 2}
{cmd:. lfiles c:\*.xlsx}{p_end}
{pstd}List all the files on the e-drive. with
 the extension {hilite:xlsx}.
 
{p 8 17 2}
{cmd:. lfiles c:\ , nocd}  {p_end}
{pstd}List all the files in e:\ and stays in the current directory.


{title:Favorites}

{pstd}
{cmd:lfiles} offers the possibility of saving in memory and on disk a list of folders to quick access. These are called favorites. Each directory  from the output, except the root directory, can be added to you favorites. Click on [+] to add a directory to your favorites. At the bottom fo the output you will find four buttons. 
{p_end}
{p 8 8 }
1. Click on <{hi:List favorites}> to list your favorites{break}
{p_end}

{p 11 11}
{cmd:. lf_favorites , list}{break}
{hi:[-] C:\Users\Christophe\Stata\Rawdata}{break}
{hi:[-] C:\Users\Christophe\Stata\do-files} {break}
{hi:[-] C:\Users\Christophe\Stata\My data} {break}
<{hi:List favorites}>     <{hi:Reset favorites}>     <{hi:Load favorites}>     <{hi:Save favorites}>{break}
{p_end}

{p 11 11}
Click on [-] to remove a directory from your favorites{p_end}
{p 8 8}
2. Click on <{hi:Reset favorites}> to reset your favorites{break}
3. Click on <{hi:Load favorites}> to load your favorites{break}
4. Click on <{hi:Save favorites}> to save your favorites to a file{break}
5. As usual click on the links to the folder to change directory
{p_end}





{title:Remarks}

{pstd}{cmd:lfiles} is inspired by {help dirtools:dirtools}.

{title:Author}

{pstd}
Christophe Kolodziejczyk{break}
VIVE, the Danish Center of Applied Social Science{break}
Herluf Trolles Gade 11{break}
DK-1052 - Copenhagen K{break}
ckol@vive.dk{break}
www.vive.dk{break}

{p2colreset}{...}
