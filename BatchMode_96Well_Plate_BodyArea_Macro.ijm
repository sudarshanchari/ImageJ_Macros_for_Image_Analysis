// Creator: Sudarshan Chari @ Lewis Sigler Institute, Princeton University
// Purpose: To measure body size (area in pixels or scaled) for Drosophila melanogaster plated individually in 96 well plate
// Usage: Edit this macro in any text editor to provide the correct input and output directory for the images to be analyzed
//        Open ImageJ and install this macro;
//		  Click on this macro and it will analyze all of the images in a given folder
// Input: Folder containing .tiff images
// Output: "single space" separated .txt file per image, each containing "Label" (Image Name) "Area", "Row", "Col", "X-Coord", "Y-Coord"

indir = "/Users/sudarshanchari/Desktop/D1_Luisa_Setup/Tiff/";
outdir = "/Users/sudarshanchari/Desktop/D1_Luisa_Setup/Tiff_out/";

setBatchMode(true);
filelist = getFileList(indir);
for (i=0; i<filelist.length; i++) 
	BA (indir,outdir,filelist[i]);
setBatchMode(false);

function BA (indir,outdir,filename){
   			open(indir + filename);
   			// Clearing table with results, removing overlay, converting image to 8-bit and setting scale
   			fileName=getTitle();
			baseNameEnd=indexOf(fileName, ".tiff"); 
			baseName=substring(fileName, 0, baseNameEnd); 
			dir=getDirectory("image");

			run("Clear Results");

			run("Remove Overlay");

			run("Rotate 90 Degrees Left");
			run("Split Channels");
			close("C1-filename");
   			close("C2-filename");
			run("8-bit");
			run("8-bit");

   			//run("ROI Manager...");
			//roiManager("Open", "/Applications/ImageJ/macros/RoiSet_D1_Luisa_06_19_17.zip");
			//roiManager("Show All with labels");
			
			// Grid parameters
			nc=12; nr=8; xo=432; yo=306; xf=4200; yf=2700; csize=250;
			csepx=(xf - xo)/11; 
			csepy=(yf - yo)/7;

   			// Doing measurements on the chosen grid

			run("Brightness/Contrast...");
			setMinAndMax(35, 40);
		
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
  //selectWindow("ROI Manager");
  //run("Close");
  selectWindow("B&C");
  run("Close");
  selectWindow("Summary");
  run("Close");
  run("Close");
  run("Close");
  run("Close");
  selectWindow("Log");
  //saveAs("Text", dir + baseName + "_Result.txt");
  saveAs("Text", outdir + filename + ".txt");
  run("Close");
}
}			

