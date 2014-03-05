Stack.getDimensions(width, height, channels, slices, frames);
n = roiManager("count");
newImage("Untitled", "8-bit Black", width, height, n);
for (i=0; i<n; i++)
{
	roiManager("Select",i);
	Stack.setSlice(i+1);
	run("Fill", "slice");
	setBackgroundColor(255, 255, 255);
}