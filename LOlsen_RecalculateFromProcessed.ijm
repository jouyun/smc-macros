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
run("Duplicate...", "title=Mask duplicate channels=1");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(1, 3);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Divide...", "value=255");
//run("Brightness/Contrast...");
run("Select All");
rename(t);
run("Measure");