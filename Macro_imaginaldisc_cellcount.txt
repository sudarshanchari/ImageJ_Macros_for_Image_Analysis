macro "Macro set scale & crop [6]"
{run("Set Scale...", "distance=308 known=200 pixel=1 unit=um");
run("Crop");
run("Split Channels");
close();}

macro "Macro wg/green box [7]"
{setAutoThreshold("Default");
//run("Threshold...");
setThreshold(180, 255);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=1000-Infinity circularity=0.00-1.00 show=Outlines display clear include summarize");
close();
run("Create Selection");}

macro "Macro cell prolif/red box [8]"
{setAutoThreshold("Default");
//run("Threshold...");
setThreshold(230, 255);
run("Convert to Mask");
run("Restore Selection");
run("Watershed");
run("Analyze Particles...", "size=5-Infinity circularity=0.00-1.00 show=Outlines display exclude clear include summarize");}
