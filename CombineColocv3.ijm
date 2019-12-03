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


t=getTitle();
run("Clear Results");
Stack.getDimensions(width, height, channels, slices, frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices="+((slices*frames/3))+" frames=3 display=Grayscale");

selectWindow(t);
run("Duplicate...", "title=A duplicate channels=3 frames=1");
setAutoThreshold("Default dark no-reset");
setThreshold(0.1, 1.000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=2 max_size=-1");
selectWindow("Bin");
close();
selectWindow("Seg");
rename(t+"-Ch1");
run("3D Centroid");
run("32-bit");


selectWindow(t);
run("Duplicate...", "title=B duplicate channels=3 frames=2");
setAutoThreshold("Default dark no-reset");
setThreshold(0.1, 1.000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=2 max_size=-1");
selectWindow("Bin");
close();
selectWindow("Seg");
rename(t+"-Ch2");
run("3D Centroid");
run("32-bit");

selectWindow(t);
run("Duplicate...", "title=C duplicate channels=3 frames=3");
setAutoThreshold("Default dark no-reset");
setThreshold(0.1, 1.000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=2 max_size=-1");
selectWindow("Bin");
close();
selectWindow("Seg");
rename(t+"-Ch3");
run("3D Centroid");
run("32-bit");

selectWindow(t);
run("Duplicate...", "title=AA duplicate channels=1 frames=1");
run("Merge Channels...", "c1=AA c2="+t+"-Ch1 create");
selectWindow("Composite");
rename("Ch1-Combined");

selectWindow(t);
run("Duplicate...", "title=BB duplicate channels=1 frames=2");
run("Merge Channels...", "c1=BB c2="+t+"-Ch2 create");
selectWindow("Composite");
rename("Ch2-Combined");

selectWindow(t);
run("Duplicate...", "title=CC duplicate channels=1 frames=3");
run("Merge Channels...", "c1=CC c2="+t+"-Ch3 create");
selectWindow("Composite");
rename("Ch3-Combined");

run("Concatenate...", "  title=Merged open image1=Ch1-Combined image2=Ch2-Combined image3=Ch3-Combined image4=[-- None --]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+((slices*frames/3))+" frames=3 display=Composite");
//run("Channels Tool...");
run("Magenta");
setMinAndMax(100, 200);
Stack.setChannel(2);
//run("Channels Tool...");
run("Yellow");

saveAs("Results", ""+substring(current_file, 0, lengthOf(current_file)-4)+"_3Dspots.csv");

run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-4)+"_3DSeg.tif]");

run("Z Project...", "projection=[Max Intensity] all");
run("Duplicate...", "title=Spots duplicate channels=2");
setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setThreshold(1.0000, 999999.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Ultimate Points", "stack");
setThreshold(1, 100);
run("Convert to Mask", "method=Default background=Dark black");

run("32-bit");
run("Gaussian Blur...", "sigma=1 stack");
run("Enhance Contrast", "saturated=0.35");
setAutoThreshold("Default dark no-reset");
setThreshold(1.1301, 100.0000);
run("Convert to Mask", "method=Default background=Dark black");
selectWindow("Spots");
tt=getTitle();

/*****************Make Colocalization images************************/

//First channel
selectWindow(tt);
run("Duplicate...", "title=AAA duplicate range=1-1");

//Second channel
selectWindow(tt);
run("Duplicate...", "title=BBB duplicate range=2-2");


//Third channel
selectWindow(tt);
run("Duplicate...", "title=CCC duplicate range=3-3");


//First and second
run("Concatenate...", "  title=AB keep image1=AAA image2=BBB image3=[-- None --]");
//run("Dilate", "stack");
run("Grays");
run("Divide...", "value=255 stack");
rename("JointAB");
run("Z Project...", "projection=[Sum Slices]");
setMinAndMax(0, 2);
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(129, 255);
run("Convert to Mask");
rename("BothAB");
//run("Divide...", "value=255");


//Second and third
run("Concatenate...", "  title=BC keep image1=BBB image2=CCC image3=[-- None --]");
//run("Dilate", "stack");
run("Grays");
run("Divide...", "value=255 stack");
rename("JointBC");
run("Z Project...", "projection=[Sum Slices]");
setMinAndMax(0, 2);
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(129, 255);
run("Convert to Mask");
rename("BothBC");
//run("Divide...", "value=255");

//First and third
run("Concatenate...", "  title=AC keep image1=AAA image2=CCC image3=[-- None --]");
//run("Dilate", "stack");
run("Grays");
run("Divide...", "value=255 stack");
rename("JointAC");
run("Z Project...", "projection=[Sum Slices]");
setMinAndMax(0, 2);
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(129, 255);
run("Convert to Mask");
rename("BothAC");
//run("Divide...", "value=255");

//All 3
run("Concatenate...", "  title=ABC keep image1=AAA image2=BBB image3=CCC image4=[-- None --]");
//run("Dilate", "stack");
run("Grays");
run("Divide...", "value=255 stack");
rename("JointABC");
run("Z Project...", "projection=[Sum Slices]");
setMinAndMax(0, 3);
run("8-bit");
setAutoThreshold("Default dark");
setThreshold(180, 255);
run("Convert to Mask");
rename("AllABC");
//run("Divide...", "value=255");
run("Concatenate...", "  title=Final image1=AAA image2=BBB image3=CCC image4=BothAB image5=BothBC image6=BothAC image7=AllABC image8=[-- None --]");
setThreshold(1, 255);
run("Convert to Mask", "method=Default background=Dark black");

for (i=1; i<8; i++)
{
	Stack.setSlice(i);
	run("Ultimate Points", "slice");
}
setThreshold(1, 255);
run("Convert to Mask", "method=Default background=Dark black");

run("Make Composite", "display=Composite");
Stack.setDisplayMode("grayscale");
run("Analyze Particles...", "display clear stack");
saveAs("Results", ""+substring(current_file, 0, lengthOf(current_file)-4)+"_spots.csv");
run("32-bit");
run("Multiply...", "value=1024.000 stack");
run("Gaussian Blur...", "sigma=100 stack");

//run("Scale...", "x=.125 y=.125 z=1.0 width=1888 height=1600 depth=7 interpolation=Bilinear average process create");
//run("Scale...", "x=.125 y=.125 z=1.0 width=236 height=200 depth=7 interpolation=Bilinear average process create");
//run("Multiply...", "value=1024.000 stack");

run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-4)+"_colocalization.tif]");
