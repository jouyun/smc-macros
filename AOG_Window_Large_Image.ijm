//Boilerplate file loading
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
IJ.log(current_file);
current_dir=File.getParent(current_file);
open(current_file);
base_file=substring(current_file, 0, lengthOf(current_file)-4);

t=getTitle();
Stack.getDimensions(w,h,c,s,f);
ww=floor(w/4);
hh=floor(h/4);
for (x=0; x<4; x++)
{
	for (y=0; y<4; y++)
	{
		selectWindow(t);
		makeRectangle(0+x*ww, 0+y*hh, ww, hh);
		run("Duplicate...", "duplicate");
		run("Save As Tiff", "save="+base_file+"_X"+x+"_Y"+y);
		close();
	}
}
