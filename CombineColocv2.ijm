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

//*********************MASK OUT ONLY THE DAPI POSITIVE SIGNAL*************************
run("Duplicate...", "duplicate channels=7");
run("Gaussian Blur...", "sigma=20");
run("Percentile Threshold", "percentile=30 snr=8");
run("Divide...", "value=255.000");
run("32-bit");
rename("DAPIMask");
imageCalculator("Multiply create stack", t,"DAPIMask");
tt=getTitle();
selectWindow(t);
close();
selectWindow(tt);
rename(t);


Stack.setChannel(1);
run("Green");
setMinAndMax(94.18, 400.43);
Stack.setChannel(2);
run("Grays");
setMinAndMax(150, 150);
Stack.setChannel(3);
run("Green");
setMinAndMax(100.32, 450.16);
Stack.setChannel(4);
run("Grays");
setMinAndMax(140,140);
Stack.setChannel(5);
run("Green");
setMinAndMax(105.14, 530.94);
//setMinAndMax(105.14, 530.94);
Stack.setChannel(6);
run("Grays");
setMinAndMax(105,105);
//setMinAndMax(82, 83);

run("8-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=7 slices=1 frames=1 display=Grayscale");
for (i=0; i<7; i++)
{
	Stack.setChannel(i+1);
	run("Enhance Contrast", "saturated=0.35");
}

run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-4)+"_spots.tif]");
//First channel
run("Duplicate...", "title=A duplicate channels=2 frames=1");
setAutoThreshold("Default dark");
run("Convert to Mask");

//Second channel
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=4 frames=1");
setAutoThreshold("Default dark");
run("Convert to Mask");

//Third channel
selectWindow(t);
run("Duplicate...", "title=C duplicate channels=6 frames=1");
setAutoThreshold("Default dark");
run("Convert to Mask");

//First and second
run("Concatenate...", "  title=AB keep image1=A image2=B image3=[-- None --]");
run("Dilate", "stack");
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
run("Concatenate...", "  title=BC keep image1=B image2=C image3=[-- None --]");
run("Dilate", "stack");
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
run("Concatenate...", "  title=AC keep image1=A image2=C image3=[-- None --]");
run("Dilate", "stack");
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
run("Concatenate...", "  title=ABC keep image1=A image2=B image3=C image4=[-- None --]");
run("Dilate", "stack");
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

run("Concatenate...", "  title=Final image1=A image2=B image3=C image4=BothAB image5=BothBC image6=BothAC image7=AllABC image8=[-- None --]");
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
selectWindow(t);
run("32-bit");
run("Concatenate...", "  image1="+t+" image2=Final image3=[-- None --]");


run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-4)+"_colocalization.tif]");
