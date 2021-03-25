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
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);
Stack.getDimensions(width, height, channels, slices, frames);
for (i=0; i<25; i++)
{
	run("Delete Slice", "delete=slice");
}
Stack.setSlice(slices);
run("Delete Slice", "delete=slice");

t=getTitle();
s=nSlices;
//run("Stack to Hyperstack...", "order=xyzct channels=2 slices="+(s/2)+" frames=1 display=Composite");
run("Smooth");
run("Subtract Background...", "rolling=50");
run("32-bit");
run("Split Channels");
run("Merge Channels...", "c1=[C2-"+t+"] c2=[C1-"+t+"] create");

t=getTitle();
Stack.setChannel(2);
//0.7
run("find blob 3D tester", "threshold=40 minimum=300 selection=40");
run("32-bit");
selectWindow(t);
run("Duplicate...", "title=A duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=2");
run("Merge Channels...", "c1=B c2=A c6=TempImg create");
run("Enhance Contrast", "saturated=0.35");

coloc_count=getResult("Total");
total_count=nResults-1;
logs=""+coloc_count+","+total_count;
IJ.log(logs);

run("Magenta");
saveAs("Tiff", current_file+"_coloc.tif");
run("Close All");
return logs;