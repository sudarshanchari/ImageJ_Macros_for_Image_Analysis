run("Set Scale...", "distance=620 Known Distance=1.0 pixel=1 unit=mm");
run("Crop");
run("Find Edges");
run("Sharpen");
run("Sharpen");
run("Sharpen");
run("Make Binary");
run("Close-");
run("Fill Holes");
run("Analyze Particles...", "size=0.05-Infinity circularity=0.00-1.00 show=Outlines display clear include summarize");