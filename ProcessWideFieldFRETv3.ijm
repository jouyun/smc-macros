Peak_Intensity=130;
Growing_Fraction=0.5;
Autofluorescence_Threshold=30;

//Usually
//Autofluorescence_Threshold=150;

selectImage(1);
a=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);

run("Concatenate...", "all_open title="+a);
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames=2 display=Grayscale");

run("32-bit");
run("Gaussian Blur...", "sigma=1 stack");
run("Z Project...", "projection=[Average Intensity] all");
run("Subtract Background...", "rolling=3 stack");

run("Duplicate...", "title="+a+"_processed"+" duplicate channels=1");
run("StackReg", "transformation=[Rigid Body]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=1 display=Grayscale");

//*****************Try to correct for photobleaching of the autofluorescence*********************//
/*pb=getTitle();
run("Duplicate...", "title=A duplicate channels=1");
run("Duplicate...", "title=AAA");
selectWindow(pb);
run("Duplicate...", "title=B duplicate channels=2");
run("Duplicate...", "title=BBB");
selectWindow("AAA");
setThreshold(Autofluorescence_Threshold, 65000);
run("Convert to Mask");

selectWindow("BBB");
setThreshold(Autofluorescence_Threshold, 65000);
run("Convert to Mask");

imageCalculator("AND create", "AAA","BBB");
rename("Mask");

imageCalculator("Multiply create 32-bit", "A","Mask");
rename("AMasked");
run("Divide...", "value=255");
run("Select All");
run("Measure");

imageCalculator("Multiply create 32-bit", "B","Mask");
rename("BMasked");
run("Divide...", "value=255.000");
run("Select All");
run("Measure");
selectWindow(pb);
Stack.setChannel(2);
B=getResult("RawIntDen", nResults-1);
A=getResult("RawIntDen", nResults-2);

selectWindow(pb);
Stack.setChannel(2);
run("Multiply...", "value="+(A/B)+" slice");
IJ.log("Ratio: "+(A/B));*/
//**************End of photobleaching correction*************************//


Stack.setChannel(1);
run("Find Maxima...", "noise="+Peak_Intensity+" output=[Point Selection]");
tt=getTitle();
run("seeded multipoint adaptive region grow", "background=0 drop="+Growing_Fraction+" minimum=-150 quantify minimum=5 maximum=20");

selectWindow(tt);
run("Properties...", "channels=2 slices=1 frames=1 unit=micron pixel_width=1 pixel_height=1 voxel_depth=0.3000000");
selectWindow("Img");
run("32-bit");
selectWindow(tt);
run("add channel", "target=Img");
setMinAndMax(-46.8476, 942.0787);
run("Make Composite", "display=Composite");
Stack.setActiveChannels("101");
run("Green");
