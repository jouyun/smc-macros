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
//run("Properties...", "channels=3 slices=1 frames=1 pixel_width=1 pixel_height=1 voxel_depth=8.0000000");
run("Properties...", "channels=2 slices=1 frames=1 pixel_width=1 pixel_height=1 voxel_depth=8.0000000");
//Get manually annotated center/rotation angle
run("Measure");
angle = getResult("Angle", nResults-1);
x = getResult("X", nResults-1);
y = getResult("Y", nResults-1);
Stack.getDimensions(width, height, channels, slices, frames);
tx = Math.floor(width/2)-x;
ty = Math.floor(height/2)-y;
len = getResult("Perim.", nResults-1);


roiManager("reset");
run("Clear Results");
t=getTitle();
run("Duplicate...", "duplicate channels=1");
//run("Log3D", "sigmax=2.0 sigmay=2.0 sigmaz=2.0");
//run("Find Maxima...", "prominence=5000 output=[Point Selection]");
run("Select All");
run("Measure");
max = getResult("Max", nResults-1);
thresh = max/2700.0*1500.0;
run("Median...", "radius=2 slice");
run("Log3D", "sigmax=3.5 sigmay=3.5 sigmaz=2.0");
rename("Logged");
run("16-bit");
run("Find Maxima...", "prominence="+thresh+" output=[Point Selection]");
roiManager("Add");
selectWindow("Logged");
run("Find Maxima...", "prominence="+thresh+" output=[List]");
selectWindow(t);
run("Split Channels");
//run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=C3-"+t+" c4=Logged create");
run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=Logged create");
Stack.setDisplayMode("grayscale");
roiManager("Show All");


//ALIGN THE WORM
trimmed = getTitle();
//run("Duplicate...", "title=DAPI duplicate channels="+3);
run("Duplicate...", "title=DAPI duplicate channels="+2);
setAutoThreshold("Default dark");
//run("Threshold...");
run("Gaussian Blur...", "sigma=10");
//setThreshold(300.0000, 1000000000000000000000000000000.0000);
setThreshold(280.0000, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated skewness limit display redirect=None decimal=3");

run("Analyze Particles...", "size=60000-Infinity show=[Count Masks]");
run("Mask Largest");
setOption("ScaleConversions", true);
run("8-bit");

run("Analyze Particles...", "size=1000-Infinity display clear add");
//run("Analyze Particles...", "size=60000-Infinity display clear add");

if (nResults>0)
{
	selectWindow(t);
	roiManager("Select", 0);
	run("Clear Outside", "stack");
	run("Select All");
	run("Translate...", "x="+tx+" y="+ty+" interpolation=Bilinear enlarge stack");
	run("Rotate... ", "angle="+angle+" grid=1 interpolation=Bilinear enlarge stack");

	Stack.getDimensions(width, height, channels, slices, frames);
	scalex = 1.2;
	//scaley=0.85;
	scaley=1.0;
	
	makeRectangle(width/2-scalex*len/2, height/2-scaley*(len/2), scalex*len, (scaley*len));
	run("Crop");

	Stack.getDimensions(width, height, channels, slices, frames);
	target_width = 800;
	scale = target_width/width;
	run("Scale...", "x="+scale+" y="+scale+" z=1.0 width=685 height=485 depth=1 interpolation=Bilinear average create");
	
	IJ.log(name);
	if (name!="")
	{
		//saveAs("Tiff", name+"_large_aligned.tif");
		Stack.setDisplayMode("composite");
		Stack.setActiveChannels("1001");
		//run("Channels Tool...");
		run("Green");
		Stack.setChannel(4);
		setMinAndMax(37288, 59510);
		//run("Find Maxima...", "prominence=2500 output=List");

		
		run("Save As Tiff", "save=["+name+"_projected_aligned.tif]");
		Stack.setChannel(4);
		//run("Find Maxima...", "prominence=1 output=List");
		run("Find Maxima...");
		saveAs("Results", ""+name+"_projected_aligned.csv");
	}
}
