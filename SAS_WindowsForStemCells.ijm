run("32-bit");

t=getTitle();
ct=roiManager("Count");
n_objects=ct/3;
window_size=128;
half_size=window_size/2;
for (i=0; i<n_objects; i++)
{
	selectWindow(t);
	roiManager("Select", i*3);
	Stack.getPosition(c,s,f);
	run("Measure");
	x=parseFloat(getResult("X",0));
	y=parseFloat(getResult("Y",0));
	run("Clear Results");
	if (x-half_size<0||x+half_size>=getWidth()||y-half_size<0||y+half_size>=getHeight())
	{
		
	}
	else
	{
		makeRectangle(x-half_size, y-half_size, window_size, window_size);
		IJ.log(s);
		run("Duplicate...", "duplicate slices="+s);
		saveAs("Tiff", "/home/smc/Data/SAS/processed/good/"+t+IJ.pad(i,2)+".tif");
	}
}
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
  run("Close All");
