xy_blur=2.0;
z_blur=0.2;

t=getTitle();

thresh1=2000000;
thresh2=2000000;

run("Duplicate...", "duplicate channels=1");
Stack.getDimensions(width, height, channels, slices, frames);
run("Subtract Background...", "rolling=40");
rename("Original");
tt=getTitle();
run("32-bit");
run("Log3D", "sigmax="+xy_blur+" sigmay="+xy_blur+" sigmaz="+z_blur);
tt=getTitle();
for (s=0; s<slices; s++)
{
	selectWindow(tt);
	Stack.setSlice(s+1);
	run("Find Maxima...", "prominence="+thresh1+" output=[Single Points]");
	rename("S"+s);
}
txt="";
for (s=0; s<slices; s++)
{
	txt=txt+"image"+(s+1)+"=S"+s+" ";
}
txt=txt+"image"+(slices+1)+"=[-- None --]";
IJ.log(txt);
run("Concatenate...", "open "+txt);
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slices+" frames=1 display=Grayscale");
run("Analyze Particles...", "  show=[Count Masks] stack");
selectWindow("Count Masks of Untitled");
rename("Spots1CountMask");
selectWindow("Log3D Original");
close();
selectWindow("Untitled");
close();

selectWindow(t);
run("Duplicate...", "duplicate channels=2");
run("Subtract Background...", "rolling=40");
rename("Originals");
tt=getTitle();
run("32-bit");
run("Log3D", "sigmax="+xy_blur+" sigmay="+xy_blur+" sigmaz="+z_blur);
tt=getTitle();
for (s=0; s<slices; s++)
{
	selectWindow(tt);
	Stack.setSlice(s+1);
	run("Find Maxima...", "prominence="+thresh2+" output=[Single Points]");
	rename("S"+s);
}
txt="";
for (s=0; s<slices; s++)
{
	txt=txt+"image"+(s+1)+"=S"+s+" ";
}
txt=txt+"image"+(slices+1)+"=[-- None --]";
IJ.log(txt);
run("Concatenate...", "open "+txt);
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slices+" frames=1 display=Grayscale");
run("Analyze Particles...", "  show=[Count Masks] stack");
selectWindow("Count Masks of Untitled");
rename("Spots2CountMask");


selectWindow(t);
run("Duplicate...", "duplicate channels=3");
run("Gaussian Blur...", "sigma=2 stack");
run("Grays");
Stack.getDimensions(width, height, channels, slices, frames);
run("Scale...", "x=.25 y=.25 z=1.0 width="+(width/2)+" height="+(height/2)+" depth="+slices+" interpolation=Bilinear average process create");
setAutoThreshold("Default dark");
setThreshold(3390, 65535);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
rename("ABC");

run("3D Watershed Split", "binary=ABC seeds=Automatic radius=17");
run("Scale...", "x=4 y=4 z=1.0 width="+width+" height="+height+" depth="+slices+" interpolation=None average process create");
rename("BlobCountMask");


run("Merge Channels...", "c1=BlobCountMask c2=Spots1CountMask c3=Spots2CountMask create");
res=getTitle();
run("Clear Results");
run("Count Objects In Objects", "bigger=1 smaller=2 minimum=5 maximum=1000000");
saveAs("Results", "/n/core/micro/jeg/vps/smc/20190621_780_IMARE-92821_TScells_10IR_pATMgreen_53BP1red/"+t+"_Ch1.csv");
selectWindow(res);
run("Clear Results");
run("Count Objects In Objects", "bigger=1 smaller=3 minimum=5 maximum=1000000");
saveAs("Results", "/n/core/micro/jeg/vps/smc/20190621_780_IMARE-92821_TScells_10IR_pATMgreen_53BP1red/"+t+"_Ch2.csv");

selectWindow(t);
run("Split Channels");
selectWindow(res);
run("Split Channels");
run("Merge Channels...", "c1=[C1-"+t+"] c2=[C2-"+t+"] c3=[C3-"+t+"] c4=C1-Composite c5=C2-Composite c6=C3-Composite create");
saveAs("Tiff", "/n/core/micro/jeg/vps/smc/20190621_780_IMARE-92821_TScells_10IR_pATMgreen_53BP1red/"+t+"_processed.tif");

/*run("32-bit");

run("Enhance Contrast", "saturated=0.35");

run("Merge Channels...", "c2=LocalMax c3=3D_MaximumLocal c6="+t+" create");
Stack.setChannel(1);
run("Green");
Stack.setChannel(3);
run("Magenta");*/
