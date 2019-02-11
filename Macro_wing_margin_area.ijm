macro "Macro set scale & crop [6]"
{run("Set Scale...", "distance=308 known=200 pixel=1 unit=um");
run("Crop");
run("Split Channels");
close();
setOption("BlackBackground", false);
run("Make Binary");
run("Make Binary");}

macro "Macro wg/margin area [7]"
{run("Close-");
run("Fill Holes");
run("Analyze Particles...", "size=1000-Infinity show=Outlines display clear include summarize");}
