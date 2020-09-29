
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
name=current_file;
roiManager("reset");

open(current_file);

run("Properties...", "channels=3 slices=1 frames=1 unit=pix pixel_width=1 pixel_height=1 voxel_depth=1");
original=getTitle();
run("Measure");

//run("Scale...", "x=.125 y=.125 z=1.0 width=546 height=712 depth=45 interpolation=Bilinear average create title=Worm1-1.tif");
//scaled=getTitle();
run("32-bit");
//run("Trim In Z Automatically");

x=getResult("X", nResults-1);
y=getResult("Y",nResults-1);
theta=getResult("Angle", nResults-1);
lth=getResult("Length", nResults-1);

Major=lth;
Minor=lth*0.6;
width=getWidth();
height=getHeight();

tx=floor(width/2-x);
ty=floor(height/2-y);
trimmed=original;
selectWindow(trimmed);

if (getWidth()>getHeight()) max_size=getWidth();
else max_size=getHeight();
run("Canvas Size...", "width="+1.2*max_size+" height="+1.2*max_size+" position=Center zero");
selectWindow(trimmed);
run("Translate...", "x="+tx+" y="+ty+" interpolation=Bilinear enlarge stack");
selectWindow(trimmed);

run("Rotate... ", "angle="+theta+" grid=1 interpolation=Bilinear enlarge stack");
selectWindow(trimmed);

width=getWidth();
height=getHeight();
scale=1.2;
IJ.log("width, Major, height, Minor: "+width+","+Major+","+height+","+Minor);
if (width>scale*Major||height>scale*Minor)
{
	makeRectangle(width/2-Major*scale/2, height/2-Minor*scale/2, scale*Major, scale*Minor);
	run("Crop");
}
width=getWidth();
height=getHeight();
if (width%2>0)
{
	makeRectangle(0, 0, width-1, height);
	run("Crop");
}
if (height%2>0)
{
	makeRectangle(0, 0, width, height-1);
	run("Crop");
}

width=getWidth();
height=getHeight();
run("Enhance Contrast", "saturated=0.35");
Stack.getDimensions(width, height, channels, slices, frames);
run("Scale...", "x=- y=- z=1.0 width=1200 height=750 depth="+channels+" interpolation=Bilinear average create");

Stack.setChannel(1);
setMinAndMax(339, 47529);
Stack.setChannel(2);
setMinAndMax(5531, 94028);
if (channels>2)
{
	Stack.setChannel(3);
	setMinAndMax(5900, 177909);
}

if (name!="")
{
	//saveAs("Tiff", name+"_large_aligned.tif");
	run("Save As Tiff", "save="+name+"_large_aligned.tif");
}
