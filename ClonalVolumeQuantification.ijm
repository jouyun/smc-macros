name=getArgument;
source_img = File.openDialog("Pick file");
source_dir=File.getParent(source_img);
new_directory=source_dir+File.separator+"Crops"+File.separator;
File.makeDirectory(new_directory);
cnt=roiManager("count");
open(source_img);
t=getTitle();
run("Clear Results");

for (i=0; i<cnt; i++)
{
	selectWindow(t);
	roiManager("Select",i);
	run("seeded region grow 3D thresholded", "threshold=7");
	run("Crop NonZero");
	saveAs("Tiff", new_directory+"Cropped"+(i+1)+".tif");
	tt=getTitle();
	selectWindow("Img");
	close();
	selectWindow(tt);
	run("Duplicate...", "title=Mask duplicate");
	setAutoThreshold("Default dark");
	//run("Threshold...");
	setThreshold(1, 255);
	//setThreshold(1, 255);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Close-", "stack");
	run("Fill Holes", "stack");
	run("Divide...", "value=255.000 stack");
	run("Z Project...", "projection=[Sum Slices]");
	run("Measure");
	close();
	selectWindow("Mask");
	close();
	selectWindow(tt);
	close();
	//close();
}
saveAs("Results", source_img+".csv");