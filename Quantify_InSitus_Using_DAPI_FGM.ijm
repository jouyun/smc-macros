run("Clear Results");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}

//setTool("rectangle");
run("SIMR Nd2 Reader", "imagefile="+current_file);
run("Set Scale...", "distance=0 known=0 unit=pixel");
//run("Channels Tool...");
Stack.setDisplayMode("grayscale");
run("Enhance Contrast", "saturated=0.35");
t=getTitle();
run("32-bit");
run("Subtract Background...", "rolling=50");
//run("Subtract...", "value=104 stack");

Stack.getDimensions(width, height, channels, slices, frames);
while (slices%6!=0)
{
	Stack.setSlice(slices);
	run("Delete Slice", "delete=slice");
	Stack.getDimensions(width, height, channels, slices, frames);
}

Stack.getDimensions(width, height, channels, slices, frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices=6 frames="+(slices/6)+" display=Grayscale");
//run("Duplicate...", "duplicate slices=1");
ttt=getTitle();
run("Z Project...", "projection=[Sum Slices] all");
run("Split Channels");
selectWindow(ttt);
run("Duplicate...", "title=DAPI duplicate channels=3 slices=4");
run("Merge Channels...", "c1=C1-SUM_"+ttt+" c2=C2-SUM_"+ttt+" c3=DAPI create");
summed = getTitle();
saved_file = substring(current_file, 0, lengthOf(current_file)-4)+".tif";
run("Save As Tiff", "save="+saved_file);
run("Cellpose Infer local", "source="+saved_file+" diameter=150 normalize=-1 normalize_0=-1 type=cyto channel=0");
run("Close All");
open(saved_file);
tt=getTitle();
run("Duplicate...", "title="+tt+"_CH1 duplicate channels=1");
roiManager("Measure");
selectWindow(tt);
run("Duplicate...", "title="+tt+"_CH2 duplicate channels=2");
roiManager("Measure");
selectWindow(tt);
run("Duplicate...", "title="+tt+"_CH3 duplicate channels=3");
roiManager("Measure");

saveAs("Results", substring(current_file, 0, lengthOf(current_file)-4)+".csv");
