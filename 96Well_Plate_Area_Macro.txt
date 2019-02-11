// Creator: Sudarshan Chari @ Lewis Sigler Institute, Princeton University adapted from ReadPlate plugin (imagej.nih.gov/ij/plugins/readplate/index.html)
// Purpose: To measure body size (area in pixels or scaled) for Drosophila melanogaster plated individually in 96 well plate
// Usage: Open a tiff image in ImageJ
//		  Install this macro
//		  Click on this macro and it will begin the analysis of the image (follow the instructions as prompted)
// Input: Single .tiff image
// Output: "single space" separated .txt file per image, each containing "Label" (Image Name) "Area", "Row", "Col", "X-Coord", "Y-Coord"

macro "Macro to measure Body Area of flies in 96 Well Plate [7]"

{// Clearing table with results, removing overlay, converting image to 8-bit and setting scale
fileName=getTitle();
baseNameEnd=indexOf(fileName, ".tiff"); 
baseName=substring(fileName, 0, baseNameEnd); 
dir=getDirectory("image");

run("Clear Results");

run("Remove Overlay");

run("Rotate... ", "angle=180 grid=1 interpolation=None");
//run("Rotate 90 Degrees Left");
run("Split Channels");
run("8-bit");
run("8-bit");
// The line below should set a global scale
// run("Set Scale...", "distance=366 known=1 pixel=1 unit=cm global");

setTool("point");
title1="Select XY-coordinates for well A1";
msg1= "1) Click in the center of well A1 and Click OK";
waitForUser(title1, msg1);

A1 = selectionType();
if( A1 == -1 ) {
    exit("There was no selection.");
} else if( A1 != 10 ) {
    exit("The selection wasn't a point selection.");
} else {
    getSelectionCoordinates(xPoints,yPoints);
    A1x = xPoints[0];
    A1y = yPoints[0];
}

setTool("point");
title2="Select XY-coordinates for well H12";
msg2= "1) Click in the center of well H121 and Click OK";
waitForUser(title2, msg2);

H12 = selectionType();
if( H12 == -1 ) {
    exit("There was no selection.");
} else if( H12 != 10 ) {
    exit("The selection wasn't a point selection.");
} else {
    getSelectionCoordinates(xPoints,yPoints);
    H12x = xPoints[0];
    H12y = yPoints[0];
}
   			
//////////////////////////////////////////////////////////////////////////////////////////
// Setting default grid parameter values
// Depending on the grid you may have to play with these values

nc=12; nr=8; xo=A1x; yo=A1y; xf=H12x; yf=H12y; csize=250;

//////////////////////////////////////////////////////////////////////////////////////////
// Refining grid parameter values

do {

run("Remove Overlay");

//////////////////////////////////////////////////////////////////////////////////////////
// Entering grid parameter values

Dialog.create("Grid Parameters");
 
Dialog.addNumber("Number of Columns (max 12):", nc);

Dialog.addNumber("Number of Rows (max 8):", nr);

Dialog.addNumber("Center of well A1: X origin (in pixels, left equals zero):", xo);

Dialog.addNumber("Center of well A1: Y origin (in pixels, up equals zero):", yo);

Dialog.addNumber("Center of well H12: X end (in pixels):", xf);

Dialog.addNumber("Center of well H12: Y end (in pixels):", yf);

Dialog.addNumber("Circle Size (Diameter in pixels):", csize);

Dialog.show();

//////////////////////////////////////////////////////////////////////////////////////////
// Checking grid parameter values

nc=Dialog.getNumber();

if (nc > 12)
	exit ("The number of columns should be less than or equal to 12");
if (nc < 1)
	exit ("The number of columns should be at least 1");

nr=Dialog.getNumber();

if (nr > 8)
	exit ("The number of rows should be less than or equal to 8");
if (nr < 1)
	exit ("The number of rows should be at least 1");

xo=Dialog.getNumber();

if (xo < 0)
	exit ("The X origin cannot be negative");

yo=Dialog.getNumber();

if (yo < 0)
	exit ("The Y origin cannot be negative");

xf=Dialog.getNumber();

if (xf < xo)
	exit ("The X end cannot be lower than the X origin");

yf=Dialog.getNumber();

if (yf < yo)
	exit ("The Y end cannot be lower than the Y origin");

csize=Dialog.getNumber();

if (csize < 1)
	exit ("The Diameter should be at least one pixel");

csepx=(xf - xo)/11; 

csepy=(yf - yo)/7;

//////////////////////////////////////////////////////////////////////////////////////////
// Building the grid

for (i=0; i<nr; i++) {
 
	for (j=0; j<nc; j++) {

makeOval(xo-csize/2+j*csepx, yo-csize/2+i*csepy, csize, csize);
run("Add Selection...");
	} 
 }  
run("To ROI Manager");
run("Clear Results");

//////////////////////////////////////////////////////////////////////////////////////////

title="Does the grid fit the position of each well?";

msg= "1) Adjust the ROI circles manually if necessary\n" + "2) After adjusting the ROI circles, select the ROI manager window and unselect the 'show labels' box and then re-select it\n" + "3) Select this dialog box and click OK";

waitForUser(title, msg);

//////////////////////////////////////////////////////////////////////////////////////////

// Doing measurements on the chosen grid

run("Brightness/Contrast...");
		setMinAndMax(35, 40);
		
		title2="Is the contrast correct??";
		msg2= "Adjust the contrast manually if necessary and click OK";
		waitForUser(title2, msg2);

		run("Apply LUT");
   		run("Make Binary");
		run("Close-");
		run("Fill Holes");
		print("Label", "Area", "Row", "Col", "X-Coord", "Y-Coord");
		
for (i=0; i<nr; i++) {

	row=substring("ABCDEFGH",i,i+1);
	
	for (j=0; j<nc; j++) {

		makeOval(xo-csize/2+j*csepx, yo-csize/2+i*csepy, csize, csize);
		
		setResult("Area",nResults,0);
		
	    run("Analyze Particles...", "size=1000-Infinity display include summarize record");	
	    
	    lab=getResultLabel (nResults-1);
	    
	    area=getResult ("Area",nResults-1);
	    
	    xcoord=getResult ("XStart",nResults-1);
	    
	    ycoord=getResult ("YStart",nResults-1);
	    
	    setResult("Row", nResults, row);
	
 		setResult("Column", nResults-1, j+1);
    	
 		updateResults();
 		
 		ro=getResultString("Row",nResults-1);
 		
 		col=getResult("Column",nResults-1);
		
		print(lab, area, ro, col, xcoord, ycoord);
	} 

  }  
  selectWindow("Results");
  run("Close");
  selectWindow("ROI Manager");
  run("Close");
  selectWindow("B&C");
  run("Close");
  selectWindow("Summary");
  run("Close");
  run("Close");
  run("Close");
  run("Close");
  selectWindow("Log");
  saveAs("Text", dir + baseName + "_Result.txt");
  run("Close");
}       
//////////////////////////////////////////////////////////////////////////////////////////
