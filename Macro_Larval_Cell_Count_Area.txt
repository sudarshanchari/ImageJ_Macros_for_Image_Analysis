macro "Macro Larval Cell count and area [1]"
{run("Crop");
run("8-bit");
run("8-bit");
//run("Brightness/Contrast...");
setMinAndMax(80, 255);
run("Apply LUT");
run("Smooth");
run("Despeckle");
run("Enhance Contrast...", "saturated=5");
run("Make Binary");
run("Close-");
run("Watershed");
run("Analyze Particles...", "size=10-Infinity show=Outlines display clear include summarize");}