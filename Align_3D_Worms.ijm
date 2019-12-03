/*name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}*/

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

open(current_file);

original=getTitle();
//run("Scale...", "x=.125 y=.125 z=1.0 width=546 height=712 depth=45 interpolation=Bilinear average create title=Worm1-1.tif");
//scaled=getTitle();
run("32-bit");
//run("Trim In Z Automatically");
trimmed=getTitle();
//run("Z Project...", "projection=[Max Intensity]");
z_projected=getTitle();
setSlice(4);

//run("Percentile Threshold", "percentile=10 snr=6");
run("Duplicate...", "title=DAPI duplicate channels=3");
run("Percentile Threshold", "percentile=10 snr=18");
setOption("BlackBackground", true);
run("Dilate");
run("Erode");
run("Erode");
run("Erode");
run("Analyze Particles...", "  show=[Count Masks]");

run("Mask Largest");
run("8-bit");
run("Fill Holes");
run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated skewness limit display redirect=None decimal=3");
//run("Analyze Particles...", "size=1000-Infinity display clear add");
run("Analyze Particles...", "size=100000-Infinity display clear add");

if (nResults>0)
{
	x=getResult("XM", nResults-1);
	y=getResult("YM",nResults-1);
	theta=getResult("Angle", nResults-1);
	Major=getResult("Major", nResults-1);
	Minor=getResult("Minor", nResults-1);
	
	width=getWidth();
	height=getHeight();
	
	tx=floor(width/2-x);
	ty=floor(height/2-y);
	close();
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
	run("Scale...", "x=- y=- z=1.0 width=4000 height=1200 depth="+channels+" interpolation=Bilinear average create");
	
	Stack.setChannel(1);
	setMinAndMax(0, 680);
	Stack.setChannel(2);
	setMinAndMax(100, 2000);
	Stack.setChannel(3);
	setMinAndMax(100, 240);
	if (name!="")
	{
		//saveAs("Tiff", name+"_large_aligned.tif");
		run("Save As Tiff", "save="+name+"_large_aligned.tif");
	}
}