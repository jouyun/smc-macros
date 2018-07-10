a=getTitle();
run("Duplicate...", "title="+a+"B duplicate");
t=getTitle();
run("32-bit");
run("Gaussian Blur...", "sigma=1 stack");
if (isOpen("ROI Manager"))
{
	selectWindow("ROI Manager");
	run("Close");
}
for (c=1; c<4; c++)
{
	roiManager("Open", "/n/core/micro/rek/zaf/brs/20180515_3PO_Test/20180515_120422_718/Plate000_Well1_Object0_MAXB-1-channel"+c+".zip");
	selectWindow(t);
	Stack.setChannel(c);
	run("Clear Results");
	nrois=roiManager("Count");
	for (i=0; i<nrois; i++)
	{
		roiManager("Select", i);
		Stack.setChannel(c);
		run("Find Nearest Peak", "search=3");
	}
	run("Select All");
	run("Clear", "slice");
	roiManager("Deselect");

	nr=nResults;
	run("Colors...", "foreground=white background=black selection=yellow");
	for (i=0; i<nr; i++)
	{
		x=(getResult("X",i));
		y=(getResult("Y",i));
		makeRectangle(x-1, y-1, 3, 3);
		Roi.setFillColor(255);
		run("Fill", "slice");
	}
	selectWindow("ROI Manager");
	run("Close");
}
run("8-bit");
setThreshold(1, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=1 display=Grayscale");
run("Z Project...", "stop=3 projection=[Max Intensity]");
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(1, 255);
setOption("BlackBackground", true);
run("Analyze Particles...", "size=0-80 show=Nothing add");
run("Clear Results");
selectWindow(t);
Stack.setChannel(1);
roiManager("Measure");
Stack.setChannel(2);
roiManager("Measure");
Stack.setChannel(3);
roiManager("Measure");
f=getTitle();

selectWindow(a);
run("32-bit");
run("Split Channels");
selectWindow(f);
run("Split Channels");
run("Merge Channels...", "c1=C1-"+a+" c2=C2-"+a+" c3=C3-"+a+" c4=C4-"+a+" c5=C1-"+f+" c6=C2-"+f+" c7=C3-"+f+" create");
selectWindow(a);
for (i=1; i<5; i++)
{
	Stack.setChannel(i);	
	run("Green");
	
}
for (i=5; i<8; i++)
{
	Stack.setChannel(i);	
	run("Grays");
}
Stack.setChannel(1);
setMinAndMax(106.2031, 354.6782);
Stack.setChannel(2);
setMinAndMax(87.1919, 455.8598);
Stack.setChannel(3);
setMinAndMax(90.1411, 342.5361);
Stack.setChannel(4);
setMinAndMax(60.1134, 834.2977);
setTool("rectangle");