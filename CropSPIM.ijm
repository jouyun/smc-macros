name=getArgument;
if (name=="")
{
	
}
else
{
	run("Image Sequence...", "open="+name+" number=10000 starting=1 increment=1 scale=100 file=[] or=[] sort");
}


title=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+(slices/2)+" frames=1 display=Grayscale");
Stack.getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=tmp duplicate channels=1-2 slices="+round(0.25*slices)+"-"+round(0.75*slices));
selectWindow(title);
close();
selectWindow("tmp");
run("Set Measurements...", "area mean min center bounding median redirect=None decimal=3");
rename(title);
Stack.getDimensions(width, height, channels, slices, frames);
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
rename("MAX");
Stack.setChannel(2);
run("Delete Slice", "delete=channel");
run("Subtract Background...", "rolling=50 create");
run("Clear Results");

run("Select All");
run("Measure");
med=getResult("Median",0);
setThreshold((med+10), 50000);
run("Convert to Mask");
run("Set Measurements...", "area mean min center bounding median redirect=None decimal=3");
run("Analyze Particles...", "size=40000-Infinity circularity=0.00-1.00 show=Nothing display clear");
BX=getResult("BX",0);
BY=getResult("BY",0);
wid=getResult("Width",0);
hei=getResult("Height",0);
xc=BX+round(wid/2);
yc=BY+round(hei/2);
frac=1.1;
selectWindow(title);
makeRectangle(xc-round(frac*wid/2), yc-round(frac*hei/2), round(wid*frac), round(hei*frac));
run("Crop");
selectWindow("MAX");
close();
selectWindow(title);
