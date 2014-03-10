my_channel=1;

current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}
open(current_file);
setSlice(my_channel);
run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated median skewness kurtosis redirect=None decimal=3");
run("Duplicate...", "title=T channels="+my_channel);

open(current_file+"_mask.tif");
run("Convert to Mask", "method=Default background=Dark black");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear add slice");
close();

roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
run("Clear Outside");
roiManager("Deselect");

selectWindow("T");
run("32-bit");
run("Percentile Threshold", "percentile=30 snr=10");
run("Open");
run("Analyze Particles...", "size=300-Infinity circularity=0.00-1.00 show=Masks display clear");
run("Invert LUT");
//run("Close All");
avg_area=0;
avg_circ=0;
for (i=1; i<nResults; i++)
{
	avg_area=avg_area+getResult("Area",i);
	avg_circ=avg_circ+getResult("Circ.", i);
}
IJ.log("\\Clear");
//For Hanh prior to 9/26/2013 wanted shape parameters
//IJ.log(""+(avg_circ/nResults)+","+(avg_area/nResults)+",");
//For Kim want simply the count
IJ.log(""+nResults+","+(avg_area/nResults)+",");
