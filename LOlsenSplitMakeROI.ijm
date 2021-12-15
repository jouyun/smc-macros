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
t=getTitle();
run("Select All");
run("Duplicate...", "title=A duplicate channels=1");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(100, 255);
//setThreshold(100, 255);
run("Convert to Mask");
roiManager("reset");
run("Analyze Particles...", "add");
selectWindow("ROI Manager");
run("Analyze Particles...", "add");
roiManager("Save", substring(current_file, 0, lengthOf(current_file)-4)+".zip");
selectWindow(t);
run("Select All");
run("Duplicate...", "title=Real duplicate channels=2");
run("Save As Tiff", "save="+current_file);