
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
IJ.log(current_file);
open(current_file);
//run("Clear Results");
run("Measure");
t=getTitle();
selectWindow(t);
roiManager("Add");
ROI_File=File.getParent(current_file)+File.separator+"RoiSet-"+substring(File.getName(current_file), 0, lengthOf(File.getName(current_file))-4)+".zip";
open(ROI_File);

run("32-bit");
roiManager("Select", roiManager("Count")-2);
Stack.setChannel(1);
run("Measure");
roiManager("Select", roiManager("Count")-1);
Stack.setChannel(1);
run("Measure");

run("Select All");
run("Duplicate...", "duplicate channels=2");
rename("Base");



//For 20X 2.5 will miss fewer but have a lot more guys double counted, 3 will miss more but have fewer false positives
i=3;
s=sx=sy=i;
//s=sx=sy=12;
sz=0.7;
run("LoG 3D", "sigmax="+s+" sigmay="+s+" sigmaz="+sz+" displaykernel=0 volume=1");
while (isOpen("LoG of Base")==false)
{
	wait(1000);
}
run("Invert", "stack");
rename("LoG");
//return("");
roiManager("Select", roiManager("Count")-3);
run("Find Maxima...", "noise=1.50 output=[Single Points]");
selectWindow("Base");
selectWindow(t);
Stack.setDisplayMode("grayscale");
run("Arrange Channels...", "new=213");

resBefore=nResults;

run("Duplicate...", "title=AA duplicate channels=1");
selectWindow(t);
run("add channel", "target=AA");

run("Compute 3D Blob Statistics Round", "mask=[LoG Maxima] first=5 lateral=4 threshold=1500");
run("Make Composite", "display=Composite");

Stack.setActiveChannels("011");
Stack.setChannel(2);
run("Green");
Stack.setChannel(3);
run("Magenta");
run("Enhance Contrast", "saturated=0.35");
Stack.setDisplayMode("composite");
resAfter=nResults;
for (i=resBefore-1; i<resAfter; i++)
{
	setResult("Label", i, File.getName(current_file));
}

//saveAs("Results", ""+current_file+".csv");
IJ.log(current_file+"_processed.tif");
saveAs("Tiff", current_file+"_processed.tif");
run("Close All");