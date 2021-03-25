t=getTitle();
nRois=roiManager("Count");
for (i=nRois-1; i>-1; i--)
{
	selectWindow(t);
	roiManager("Select", i);
	run("Delete Slice", "delete=slice");
}
