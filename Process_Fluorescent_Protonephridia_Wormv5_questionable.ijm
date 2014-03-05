SNR_worm=10;
SNR_peaks=500;
SNR_proto_slc=40;
SNR_proto_cavII=250;
minimum_proto_size=100;
minimum_proto_seed_size=100;
minimum_worm_size=100000;
dropoff_count_slc=0.2;
dropoff_area_slc=0.2;
dropoff_count_cavII=0.3;
dropoff_area_cavII=0.25;



DAPI_channel=4;
H3P_channel=1;
cavII_channel=2;
slc_channel=3;

setBatchMode(true);

run("Set Measurements...", "area mean standard min centroid center bounding shape integrated skewness display redirect=None decimal=3");
current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}

run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);

title=getTitle();

//Copy DAPI_channel and generate "Mask"
setSlice(DAPI_channel);
run("Duplicate...", "title=DAPI channels="+DAPI_channel);
run("32-bit");
run("Percentile Threshold", "percentile=10 snr="+SNR_worm);
selectWindow("Result");
run("Fill Holes");
run("Open");
run("Analyze Particles...", "size="+minimum_worm_size+"-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
rename("Mask");
selectWindow("Result");
close();
selectWindow("Mask");
run("Analyze Particles...", "size="+minimum_worm_size+"-Infinity circularity=0.00-1.00 show=Nothing display clear add");
//If nothing found, get out of here!
IJ.log(""+nResults);
if (nResults<1) 
{
	IJ.log("Ack nothing found!");
	run("Close All");
	return;
}	
worm_area=getResult("Area");
//Measure the dynamic range of the DAPI channel and close it
selectWindow("DAPI");
roiManager("Select", 0);
run("Measure");
Dmax=getResult("Max");
Dmin=getResult("Min");
close();

//Now crop the Mask
selectWindow("Mask");
roiManager("Select", 0);
getSelectionBounds(x,y,width, height);
makeRectangle(x,y,width, height);
run("Crop");

//Make sure we have the cropped ROI for use later in the find maximum seeding
run("Analyze Particles...", "size="+minimum_worm_size+"-Infinity circularity=0.00-1.00 show=Nothing display clear add");
still_good=1;

//Duplicate all the other channels (cropped duplication)
selectWindow(title);
setSlice(H3P_channel);
makeRectangle(x,y,width, height);
run("Duplicate...", "title=Peaks channels="+H3P_channel);
selectWindow(title);
setSlice(cavII_channel);
makeRectangle(x,y,width, height);
run("Duplicate...", "title=CAVII channels="+cavII_channel);
selectWindow(title);
setSlice(slc_channel);
makeRectangle(x,y,width, height);
run("Duplicate...", "title=slc channels="+slc_channel);
selectWindow(title);
close();

//Measure dynamic range of Peaks
selectWindow("Peaks");
run("Smooth", "slice");
roiManager("Select", 0);
run("Measure");
max=getResult("Max");
min=getResult("Min");

//Create Spots image
run("Find Maxima...", "noise="+SNR_peaks+" output=[Single Points]");
run("Dilate");
rename("Spots");
selectWindow("Peaks");
run("Find Maxima...", "noise="+SNR_peaks+" output=Count");
H3P_count=getResult("Count");


//Process the slc image
selectWindow("slc");
run("Subtract Background...", "rolling=50");
run("Smooth");
run("32-bit");
run("Find Maxima...", "noise="+SNR_proto_slc+" output=[Point Selection]");
run("seeded multipoint adaptive region grow", "background=0 drop="+dropoff_count_slc);
rename("PrePeaks");
run("Analyze Particles...", "size="+minimum_proto_seed_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
slc_proto_count=nResults;
rename("slc_count");
selectWindow("PrePeaks");
close();


//Create area image
selectWindow("slc");
run("Find Maxima...", "noise="+SNR_proto_slc+" output=[Point Selection]");
run("seeded multipoint adaptive region grow", "background=0 drop="+dropoff_area_slc);
rename("PreArea");
run("Analyze Particles...", "size="+minimum_proto_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
number_slc_pros=nResults;
avg_slc_pro=0;
avg_slc_circ=0;
for (i=0; i<nResults; i++)
{
	avg_slc_pro=avg_slc_pro+getResult("Area", i);
	avg_slc_cir=avg_slc_cir+getResult("Circ.", i);
}
avg_slc_cir=avg_slc_cir/nResults;
rename("slc_area");
selectWindow("PreArea");
close();

//Process the CAVII image
selectWindow("CAVII");
run("Subtract Background...", "rolling=50");
run("Smooth");
run("32-bit");
run("Find Maxima...", "noise="+SNR_proto_cavII+" output=[Point Selection]");
run("seeded multipoint adaptive region grow", "background=0 drop="+dropoff_count_cavII);
rename("PrePeaks");
run("Analyze Particles...", "size="+minimum_proto_seed_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
cavII_proto_count=nResults;
rename("cavII_count");
selectWindow("PrePeaks");
close();

//Create area image
selectWindow("CAVII");
run("Find Maxima...", "noise="+SNR_proto_cavII+" output=[Point Selection]");
run("seeded multipoint adaptive region grow", "background=0 drop="+dropoff_area_cavII);
rename("PreArea");
run("Analyze Particles...", "size="+minimum_proto_size+"-Infinity circularity=0.00-1.00 show=Masks display clear add");
number_cavII_pros=nResults;
avg_cavII_pro=0;
avg_cavII_circ=0;
for (i=0; i<nResults; i++)
{
	avg_cavII_pro=avg_cavII_pro+getResult("Area", i);
	avg_cavII_cir=avg_cavII_cir+getResult("Circ.", i);
}
avg_cavII_cir=avg_cavII_cir/nResults;
rename("cavII_area");
selectWindow("PreArea");
close();

selectWindow("Peaks");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("Mask");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("slc_count");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("slc_area");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("cavII_count");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("cavII_area");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow("Spots");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
run("Concatenate...", "  title=Results image1=Mask image2=Peaks image3=Spots image4=slc image5=slc_count image6=slc_area image7=CAVII image8=cavII_count image9=cavII_area");
run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
Stack.setDisplayMode("grayscale");
for (i=1; i<10; i++)
{
	setSlice(i);
	run("Enhance Contrast", "saturated=0.35");
}
setSlice(1);

IJ.log("Area:  "+worm_area+" Peaks:  "+H3P_count+" Number protos in slc: "+slc_proto_count+" Area in proto area: "+avg_slc_pro+" Circularity in proto: "+avg_slc_cir+" Number protos in cavII: "+cavII_proto_count+" Area in proto area: "+avg_cavII_pro+" Circularity in proto: "+avg_cavII_cir);
run("32-bit");
saveAs("Tiff", current_file+"_H3P_hysteresis_mask.tif");
close();
print("\\Clear");
IJ.log(""+H3P_count +","+worm_area+","+max+","+min+","+Dmax+","+Dmin+","+slc_proto_count+","+avg_slc_pro+","+avg_slc_cir+","+cavII_proto_count+","+avg_cavII_pro+","+avg_cavII_cir);
//IJ.log(""+max_protos+","+avg_pro+","+worm_area+","+max_SNR+","+avg_cir);
logs=getInfo("log");
setBatchMode(false);
return logs;
