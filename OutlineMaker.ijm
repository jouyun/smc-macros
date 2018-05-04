t=getTitle();
count=roiManager("Count");
Stack.getDimensions(width, height, channels, slices, frames);

for (ff=0; ff<frames; ff++)
{
	have_done=false;
	for (i=0; i<count; i++)
	{
		selectWindow(t);
		roiManager("Select", i);
		Stack.getPosition(c,s,f);
		if (f==(ff+1))
		{
			newImage("New", "8-bit black", 128, 128, 2);
			roiManager("Select", i);

			setSlice(1);
			setBackgroundColor(0, 0, 0);
			setForegroundColor(255, 255, 255);
			run("Fill", "slice");

			setSlice(2);
			setBackgroundColor(0, 0, 0);
			setForegroundColor(255, 255, 255);
			run("Fill", "slice");
			run("Fill Holes", "slice");
			setForegroundColor(0,0,0);
			run("Fill", "slice");
			if (have_done==false)
			{
				rename("Old");
				have_done=true;
			}
			else
			{
				run("Concatenate...", "  title=Old image1=Old image2=New image3=[-- None --]");
			}
		}
	}
	
	selectWindow("Old");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+(nSlices/2)+" frames=1 display=Grayscale");
	if (nSlices>2)
	{
		run("Z Project...", "projection=[Max Intensity]");
		rename("tmp");
		selectWindow("Old");
		close;
		selectWindow("tmp");
		rename("Old");
	}
	rename("Frame"+ff);
}