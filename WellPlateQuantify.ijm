t=getTitle();
run("Z Project...", "projection=[Max Intensity]");
run("Subtract Background...", "rolling=50 stack");
rename(t+"_Projection");
tt=getTitle();
run("Duplicate...", "duplicate channels=1");
run("32-bit");
run("Gaussian Blur...", "sigma=2");

run("Percentile Threshold", "percentile=30 snr=200");
run("Watershed");

run("Analyze Particles...", "size=80-800 circularity=0.6-1.00 add");

count=roiManager("Count");
selectWindow(tt);
for (s=0; s<2; s++)
{
	setSlice(s+1);
	for (i=0; i<count; i++)
	{
		roiManager("Select", i);
		run("Measure");
	}
}

for (i=0; i<count; i++) 
{
	roiManager("Select", 0);
	roiManager("Delete");
}

