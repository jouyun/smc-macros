Stack.getDimensions(width, height, channels, slices, frames);
t=getTitle();
if (width==2048)
{
	run("Scale...", "x=.36 y=.36 z=1.0 width=737 height=737 depth=9 interpolation=Bicubic average create title=T");
	rename("T");
	selectWindow(t);
	close();
	selectWindow("T");
	rename(t);
}
run("Smooth", "stack");
run("Z Project...", "projection=[Average Intensity]");
rename("T");
selectWindow(t);
close();
selectWindow("T");
rename(t);
