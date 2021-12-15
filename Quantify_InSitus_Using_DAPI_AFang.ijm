run("Clear Results");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
run("Options...", "iterations=1 count=1 black");
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
cellpose_file = substring(current_file, 0, lengthOf(current_file)-5)+".tif"; 
mask_file = substring(current_file, 0, lengthOf(current_file)-5)+"_mask.tif"; 
roi_file = substring(current_file, 0, lengthOf(current_file)-5)+".roi";

z_index = parseInt(substring(current_file, lengthOf(current_file)-5, lengthOf(current_file)-4));
IJ.log(""+z_index);

//setTool("rectangle");
run("SIMR Nd2 Reader", "imagefile="+current_file);
run("Set Scale...", "distance=0 known=0 unit=pixel");

t=getTitle();
run("Split Channels");
selectWindow("C1-"+t);
run("shift z and wrap", "shift=1");
run("Merge Channels...", "c1=TempImg c2=C2-"+t+" c3=C3-"+t+" c4=C4-"+t+" create");
run("Duplicate...", "duplicate slices="+z_index);
saveAs("Tiff", cellpose_file);
run("Close All");

run("Cellpose Infer", "source="+cellpose_file+" diameter=50 normalize=-1 normalize_0=-1 type=cyto channel=3");
run("Close All");
open(cellpose_file);
tt = getTitle();
open(mask_file);
ttt = getTitle();
roiManager("reset");
open(roi_file);
run("Clear Outside");
setThreshold(1, 65535);
run("Convert to Mask");
run("Analyze Particles...", "size=400-Infinity add");

selectWindow(tt);
run("Duplicate...", "title="+tt+"_CH1 duplicate channels=1");
roiManager("Measure");
selectWindow(tt);
run("Duplicate...", "title="+tt+"_CH3 duplicate channels=3");
roiManager("Measure");

saveAs("Results", substring(current_file, 0, lengthOf(current_file)-4)+".csv");
