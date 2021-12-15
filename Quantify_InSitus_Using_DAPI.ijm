correction_file = "S:/micro/cry/jle/smc/20210618_105258_084/DAPI_Correction.tif";
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
run("Split Channels");
selectWindow("C1-"+t);
selectWindow("C2-"+t);
selectWindow("C3-"+t);

open("S:/micro/cry/jle/smc/20210618_105258_084/DAPI_Correction.tif");
selectWindow("C3-"+t);
run("Correct Flatness Using Image", "correction=DAPI_Correction.tif");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=Result create");
run("Subtract Background...", "rolling=50");

Stack.setSlice(19);
run("Delete Slice", "delete=slice");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=3 frames=6 display=Grayscale");
//run("Duplicate...", "duplicate slices=1");
ttt=getTitle();
run("Z Project...", "projection=[Sum Slices] all");
run("Split Channels");
selectWindow(ttt);
run("Duplicate...", "title=DAPI duplicate channels=3 slices=2");
run("Merge Channels...", "c1=C1-SUM_"+ttt+" c2=C2-SUM_"+ttt+" c3=DAPI create");

saved_file = substring(current_file, 0, lengthOf(current_file)-4)+".tif";
run("Save As Tiff", "save="+saved_file);

run("Cellpose Infer", "source="+saved_file+" diameter=40 normalize=-1 normalize_0=-1 type=cyto channel=2");
tt=getTitle();
run("Duplicate...", "title="+tt+"_CH1 duplicate channels=1");
roiManager("Measure");
selectWindow(tt);
run("Duplicate...", "title="+tt+"_CH2 duplicate channels=2");
roiManager("Measure");

saveAs("Results", substring(current_file, 0, lengthOf(current_file)-4)+".csv");
