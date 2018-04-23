
direc='U:\\smc\\public\\VPS\\Hdac8_PAS_Redo\\Marked\\';
t=getTitle();
roiManager("Add");
roiManager("Select", 0);
roiManager("Deselect");
run("Select All");
//run("Gaussian Blur...", "sigma=4");
run("Make Composite");
run("Duplicate...", "title=G duplicate channels=2");
rename(t+"_processed");
run("Invert");

//Threshold and segment
Stack.getDimensions(width, height, channels, slices, frames);
run("Scale...", "x=.125 y=.125 width=1790 height=909 interpolation=Bilinear average create");
smallTitle=getTitle();
run("32-bit");


run("Duplicate...", "title=S");
setThreshold(40.0000, 235.0000);
run("Convert to Mask");
run("Divide...", "value=255");
run("32-bit");
imageCalculator("Multiply create 32-bit", smallTitle,"S");
tt=getTitle();
snr=8;
dont_break=true;
while(dont_break)
{
	selectWindow(tt);
	run("Percentile Threshold", "percentile=10 snr="+snr);
	run("Dilate");
	run("Erode");
	run("Fill Holes");
	run("Scale...", "x=- y=- width="+width+" height="+height+" interpolation=None average create");
	
	roiManager("Select",0);
	run("Clear Outside");
	run("Select All");
	setThreshold(129, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	mask=getTitle();
	run("Analyze Particles...", "size=500.00-Infinity add");

	snr=snr*1.2;
	selectWindow(t);
	roiManager("Show All");	 
	waitForUser("Hold shift to end");

	if (isKeyDown("alt"))
	{
		snr=snr/1.2/1.2;
	}
	
	if (isKeyDown("shift"))
	{
		dont_break=false;
		selectWindow(mask);
		rename(t+"_processed");
		roiManager("Select",0);
		run("Measure");
		setResult("Label",nResults-1,getTitle());
		run("Select All");
		run("Analyze Particles...", "size=500.00-Infinity display");
	}

	roiManager("Save", direc+t+"_Sub.zip");
	rois=roiManager("count");
	for (i=0; i<rois-1; i++)
	{
		roiManager("Select", 1);
		roiManager("Delete");
	}
}

roiManager("Select", 0);
roiManager("Delete");


