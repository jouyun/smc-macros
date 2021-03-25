
curdir='/home/smc/Data/BRS/DeepLearn/Originals/';
list=getFileList(curdir);
for (ff=0; ff<list.length; ff++)
{
	if (endsWith(list[ff], ".tif"))
	{
roiManager("Open", curdir+substring(list[ff], 0, lengthOf(list[ff])-4)+".zip");		
open(curdir+list[ff]);
t=getTitle();
count=roiManager("Count");
Stack.getDimensions(width, height, channels, slices, frames);
newImage("HyperStack", "8-bit grayscale-mode", 2048, 2044, 2, slices, count);
rename("New");

for (i=0; i<count; i++)
{
	selectWindow("New");
	roiManager("Select", i);
	Stack.setFrame(i+1);
	Stack.setChannel(1);
	setBackgroundColor(0, 0, 0);
	setForegroundColor(255, 255, 255);
	run("Fill", "slice");

	/*Stack.getPosition(c,s,f);
	if (s-1>0&&s-1<=slices) 
	{
		Stack.setSlice(s-1);
		run("Fill", "slice");
	}
	if (s+1>0&&s+1<=slices) 
	{
		Stack.setSlice(s+1);
		run("Fill", "slice");
	}
	Stack.setSlice(s);*/

	Stack.setChannel(2);
	setBackgroundColor(0, 0, 0);
	setForegroundColor(255, 255, 255);
	run("Fill", "slice");
	run("Fill Holes", "slice");
	setForegroundColor(0,0,0);
	run("Fill", "slice");

	/*
	Stack.getPosition(c,s,f);
	if (s-1>0&&s-1<=slices) 
	{
		Stack.setSlice(s-1);
		setBackgroundColor(0, 0, 0);
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		run("Fill Holes", "slice");
		setForegroundColor(0,0,0);
		run("Fill", "slice");
	}
	if (s+1>0&&s+1<=slices) 
	{
		Stack.setSlice(s+1);
		setBackgroundColor(0, 0, 0);
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		run("Fill Holes", "slice");
		setForegroundColor(0,0,0);
		run("Fill", "slice");
	}
	Stack.setSlice(s);*/
}
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
run("Z Project...", "projection=[Max Intensity] all");
Stack.getDimensions(w,h,c,s,f);
run("32-bit");
IJ.log(""+c+","+s+","+f);
selectWindow("MAX_New");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames="+f+" display=Grayscale");
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
rename("B");

run("Split Channels");
selectWindow(t);
run("Split Channels");

run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=C1-B c4=C2-B create");
selectWindow(t);
run("Save", "save=/home/smc/Data/BRS/DeepLearn/"+t+"_annotated.tif");
run("Close All");
if (isOpen("ROI Manager")) 
{
     selectWindow("ROI Manager");
     run("Close");
}
	}
}