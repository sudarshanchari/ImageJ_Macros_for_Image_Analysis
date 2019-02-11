macro "Macro set Brightness & Scale [6]"
{//run("Brightness/Contrast...");
setMinAndMax(45, 50);
run("Apply LUT");
}

macro "Macro Get Area [7]"
{run("Crop");
run("Find Edges");
run("Sharpen");
run("Sharpen");
run("Make Binary");
run("Close-");
run("Fill Holes");
run("Analyze Particles...", "size=150-Infinity circularity=0.00-1.00 show=Outlines display clear include summarize record");
}
