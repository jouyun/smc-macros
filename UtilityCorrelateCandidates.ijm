Stack.getDimensions(width, height, channels, slices, frames);
t=getTitle();
for (i=0; i<frames; i++)
{
	selectWindow(t);
	Stack.setFrame(i+1);
	run("Duplicate...", "title=A channels=1-2 slices=1-3 frames=1-41");
	run("Split Channels");
	selectWindow("C1-A");
	selectWindow("C2-A");
	run("Calculate Spatial Correlation", "first=C1-A second=C2-A");
	selectWindow("C1-A");
	close();
	selectWindow("C2-A");
	close();	
}
