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
roiManager("reset");
t=getTitle();

run("Make Composite");
run("Delete Slice", "delete=channel");
run("Delete Slice", "delete=channel");
tiff = substring(current_file, 0, lengthOf(current_file)-4);
saveAs("Tiff", ""+tiff+".tif");
run("Close All");
old = nResults;
run("Cellpose Infer", "source=["+tiff+".tif] diameter=100 normalize=-1 normalize_0=-1 type=WebcamWorms_60");

//Save
count = roiManager("count");
if (count>0)
{
	roiManager("Deselect");
	roiManager("Save", current_file+".zip");
	roiManager("Measure");
	new = nResults;
	for (i=old; i<new; i++)
	{
		setResult("Directory", i, current_file);
	}
}