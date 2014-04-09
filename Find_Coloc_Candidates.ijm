current_file=getArgument;
setBatchMode(true);
selection_threshold=0.5;

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
slices=(nSlices)/2;
//run("Duplicate...", "title=A duplicate range="+(slices*2+1)+"-"+(nSlices));
//selectWindow(t);
//close();
//selectWindow("A");
IJ.log("About to scale");
run("Scale...", "x=.5 y=.5 z=1.0 width=1741 height=672 depth="+slices+" interpolation=Bilinear average process create title=B");
IJ.log("Made it through scale");
selectWindow(t);
close();
selectWindow("B");

run("Split Channels");
IJ.log("Split");
selectWindow("C1-B");
run("Duplicate...", "title=Smoo duplicate range=1-"+nSlices);
IJ.log("Duplicated");
run("Mean...", "radius=20 stack");
imageCalculator("Subtract create 32-bit stack", "C1-B","Smoo");
IJ.log("Subtracted");
selectWindow("Result of C1-B");
run("Merge Channels...", "c1=[Result of C1-B] c2=C2-B create");
IJ.log("Merged");
rename("B");
selectWindow("Smoo");
close();
selectWindow("C1-B");
close();
selectWindow("B");
IJ.log("made it here");
Stack.setSlice(slices);
//Weird bug in the accquisition, last slice of last channel is not right place
run("Delete Slice", "delete=slice");
slices=slices-1;
run("32-bit");
run("Subtract Background...", "rolling=50 stack");
print("\\Clear");
Stack.setChannel(2);
//return("");
run("find colocalization candidates 3D percentile", "threshold=400 minimum=80 percentile=0.85");
run("Make Composite", "display=Composite");
run("Green");
Stack.setChannel(2);
run("Magenta");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("Histogram Normalize Percentile", "sample=1 percentile_max=90 percentile_min=10 mymax=100 mymin=20");
selectWindow("B");
close();
logs=getInfo("log");
selectWindow("TempImg");

saveAs("Tiff", current_file+"_"+substring(logs,0,lengthOf(logs)-1)+"_candidates.tif");

close();






return("");


run("find blob 3D tester", "threshold=510 minimum=50 selection="+selection_threshold);

rename("C");
run("32-bit");
//run("Merge Channels...", "c2=B c6=C create");
selectWindow("B");
run("Re-order Hyperstack ...", "channels=[Slices (z)] slices=[Channels (c)] frames=[Frames (t)]");
run("Hyperstack to Stack");
run("Concatenate...", "  title=B image1=B image2=C image3=[-- None --]");
run("Stack to Hyperstack...", "order=xyzct channels=3 slices="+slices+" frames=1 display=Grayscale");

Stack.setDisplayMode("composite");
Stack.setActiveChannels("1011");
Stack.setActiveChannels("1001");
Stack.setChannel(2);
run("Magenta");
Stack.setChannel(3);
run("Magenta");
setMinAndMax(0, 255);
Stack.setChannel(1);
run("Green");
saveAs("Tiff", current_file+"_composite.tif");
close();         
logs=getInfo("log");
logs=substring(logs, 0, lengthOf(logs)-1)+","+nResults;
return logs;