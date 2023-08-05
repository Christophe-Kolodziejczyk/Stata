{smcl}
{* *! version 1.0.0 16-01-2017}{...}


{title:Title}

{phang}
{cmd:framemanager} {hline 2} Lists the frames in memory with information 
on the frames and  hyperlinks for quick access.
{p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
{cmd:framemanager} or 
{cmd:frmgr}
{p_end}


{title:Description}

{pstd}
Framemanager gives an overview of the frames in memory. Frames are listed in the 
results window as shown on the example below. Click on the frame's 
name in the column {hi:Frame} to change frame. The current frame is shown with an arrow on the right. 
The column {hi:M }indicates  whether there are unsaved data. 
The {hi:Size} gives you the number of observations and the number of variables of the frames 
({res}# of observations{txt} x {res}# of variables{txt}). 
The column {hi:Filename} gives you the name of the dataset which has been loaded in the frame 
(if a dataset has been loaded into the frame).
{p_end}

{pstd}
Actions or events related to the buttons:{break}
{hi:[-]}{space 2}: Removes the frame. Note that the current frame cannot be removed.{break}
{hi:[B]}{space 2}: Browses the frame. Shows the content of the frame in the browser{break}
{hi:[D]}{space 2}: Describes the frame {manhelp describe D}{break}
{hi:[d]}{space 2}: Describes the frame in short version {manhelp describe D}{break}
{hi:[ds]}{space 1}: Compactly list variables {manhelp ds D}{break}
{p_end}

{pstd}
Clicking on {hi:[B]} will change the current frame. Click on {hi:update}
to update the framemanager.
{p_end}


{smcl}
{com}{sf}{ul off}{txt}
{com}. {stata framemanager}
{res}{res}{hline}
Framemanager
{hline}{text}
{ul on}Actions{ul off}{col 25}{ul on}Frame{ul off}{col 33}{ul on}C{ul off}{col 37}{ul on}M{ul off}{col 41}{ul on}Size{ul off}{col 52}{ul on}Filename{ul off}


{matacmd action("default","B"):[B]}{matacmd action("default","D"):[D]}{matacmd action("default","d"):[d]}{matacmd action("default","ds, a"):[ds]}{col 25}{matacmd action("default"):default}{col 33}{err}<--{text}{col 41}({res}0 {txt}x {res}0{txt})

[-] = Remove ; B = browse ; D = describe ; d = des , s ; ds = ds , a 
{err}<--  {text}Current fame ({res}default{text})
{hi}*{text}    Unsaved data
Note: The current frame cannot be removed!
{matacmd frameBrowser2():Update}
{smcl}
{com}{sf}{ul off}

{title:Author}

{pstd}
Christophe Kolodziejczyk{break}
VIVE, the Danish Center of Applied Social Science{break}
Herluf Trolles Gade 11{break}
DK-1052 - Copenhagen K{break}
ckol@vive.dk{break}
www.vive.dk{break}

{p2colreset}{...}