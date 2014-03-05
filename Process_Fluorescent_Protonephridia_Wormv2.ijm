SNR_worm=10;
minimum_size=200;

scaler=1000;
count_high=2100/(4000/scaler);
count_low=1400/(4000/scaler);
area_high=1800/(4000/scaler);
area_low=1000/(4000/scaler);

channel_for_mask=3;
channel_for_analysis=4;

setBatchMode(false);
current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite");
open(current_file);
title=getTitle();
rename("Junk");
run("Duplicate...", "title="+title+" duplicate channels="+channel_for_mask);
run("32-bit");
run("Duplicate...", "title=tmp");
run("Smooth");
run("Subtract Background...", "rolling=800");
run("Percentile Threshold", "percentile=10 snr="+SNR_worm);
run("Fill Holes");
rename("Mask");
selectWindow(title);
close();
selectWindow("Junk");
run("Duplicate...", "title="+title+" duplicate channels="+channel_for_analysis);
run("32-bit");
selectWindow("Junk");
close();
selectWindow("tmp");
close();
selectWindow("Mask");
rename("Premask");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
rename("Mask");
selectWindow("Premask");
close();
selectWindow("Mask");
//Get area back out
run("Analyze Particles...", "size=60000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
print("\\Clear");
my_area=getResult("Area");

//Crop mask
roiManager("Select", 0);
getSelectionBounds(x,y,width, height);
makeRectangle(x,y,width, height);
run("Crop");

//Crop original image

selectWindow(title);
makeRectangle(x,y,width, height);
run("Crop");
run("Subtract Background...", "rolling=50");
run("Smooth");


//Added 10-16 a local contrast enhancer
run("Enhance Local Contrast (CLAHE)", "blocksize=49 histogram=256 maximum=4 mask=Mask");
//run("Enhance Local Contrast (CLAHE)", "blocksize=49 histogram=256 maximum=3 mask=Mask fast_(less_accurate)");
//End addition


//Find maximal process count and its SNR
max_protos=0;
max_SNR=0;

run("Hysteresis...", "high="+count_high+" low="+count_low);
run("Analyze Particles...", "size="+minimum_size+"-Infinity circularity=0.00-1.00 show=Nothing display clear");
selectWindow("Hysteresis");
close();
max_protos=nResults;

selectWindow(title);
//END find maximal process count and SNR

//Create counting image
run("Hysteresis...", "high="+count_high+" low="+count_low);
rename("PrePeaks");
run("Analyze Particles...", "size="+minimum_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
rename("Peaks");
selectWindow("PrePeaks");
close();
//Finish counting image

//Create area image
selectWindow(title);
run("Hysteresis...", "high="+area_high+" low="+area_low);
rename("PreArea");
run("Analyze Particles...", "size="+minimum_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
number_pros=nResults;
avg_pro=0;
avg_circ=0;
for (i=0; i<nResults; i++)
{
	avg_pro=avg_pro+getResult("Area", i);
	avg_cir=avg_cir+getResult("Circ.", i);
}
avg_cir=avg_cir/nResults;
rename("Area");
selectWindow("PreArea");
close();
//Finish area image

//Convert all to 32bit
selectWindow("Peaks");
run("32-bit");
selectWindow("Mask");
run("32-bit");
selectWindow("Area");
run("32-bit");
selectWindow(title);
run("Divide...", "value="+(10/(4000/scaler))+" slice");

run("Concatenate...", "  title=Results image1=Mask image2="+title+" image3=Peaks image4=Area image5=[-- None --]");
saveAs("Tiff", current_file+"_hysteresis_mask.tif");
close();
print("\\Clear");
IJ.log(""+max_protos+","+avg_pro+","+my_area+","+max_SNR+","+avg_cir);
logs=getInfo("log");
setBatchMode(false);
return logs;