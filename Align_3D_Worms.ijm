name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}
original=getTitle();
//run("Scale...", "x=.125 y=.125 z=1.0 width=546 height=712 depth=45 interpolation=Bilinear average create title=Worm1-1.tif");
//scaled=getTitle();
run("32-bit");
run("Trim In Z Automatically");
trimmed=getTitle();
run("Z Project...", "projection=[Max Intensity]");
z_projected=getTitle();
setSlice(2);

//run("Percentile Threshold", "percentile=10 snr=6");
run("Percentile Threshold", "percentile=10 snr=35");
setOption("BlackBackground", true);
run("Dilate");
run("Erode");
run("Set Measurements...", "area mean standard min centroid center perimeter bounding fit shape integrated skewness limit display redirect=None decimal=3");
//run("Analyze Particles...", "size=1000-Infinity display clear add");
run("Analyze Particles...", "size=1000000-Infinity display clear add");

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
run("Translate...", "x="+tx+" y="+ty+" interpolation=Bilinear enlarge stack");

run("Rotate... ", "angle="+theta+" grid=1 interpolation=Bilinear enlarge stack");

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
selectWindow(original);
close();
//selectWindow(scaled);
//close();
selectWindow(z_projected);
close();
selectWindow(trimmed);
run("Make Composite", "display=Grayscale");
Stack.getDimensions(a,b,c,d,e);
Stack.setSlice(floor(d/2));
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(c);
run("Enhance Contrast", "saturated=0.35");
if (name!="")
{
	saveAs("Tiff", name+"_large_aligned.tif");
}
