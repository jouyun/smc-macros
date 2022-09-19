run("Clear Results");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape integrated stack display redirect=None decimal=3");
run("Options...", "iterations=1 count=1 black do=Nothing");
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
open(current_file);

t=getTitle();

run("LoG 3D", "sigmax=3.5 sigmay=3.5 displaykernel=0");
while (isOpen("LoG of "+t)==false)
{
    wait(1000);
}
tt=getTitle();
run("Duplicate...", "title=LoG");
selectWindow(tt);
setThreshold(2.7000, 1000000000000000000000000000000.0000);
run("Convert to Mask");
run("Watershed");
run("Ultimate Points");

run("Find Maxima...", "prominence=1 output=[Single Points]");
rename("Big");
run("Duplicate...", "title=Big2");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
setThreshold(1.0000, 1000000000000000000000000000000.0000);
run("Convert to Mask");

//Make an enlarged mask of the big ones to use to throw out false small ones
selectWindow("LoG of "+t);
close();
selectWindow("Big");
run("32-bit");
run("Gaussian Blur...", "sigma=2");
setThreshold(0.2000, 1000000000000000000000000000000.0000);
run("Convert to Mask");

//Find smaller spots
selectWindow(t);
run("LoG 3D", "sigmax=1.5 sigmay=1.5 displaykernel=0");
while (isOpen("LoG of "+t)==false)
{
    wait(1000);
}
run("Find Maxima...", "prominence=10 output=[Single Points]");
rename("Small");
run("32-bit");
run("Gaussian Blur...", "sigma=1");
setThreshold(1.0000, 1000000000000000000000000000000.0000);
run("Convert to Mask");

//Throw out small ones that were also big ones
imageCalculator("Subtract create", "Small","Big");
selectWindow("Result of Small");
rename("SResult");
run("Erode");
run("Dilate");
run("Merge Channels...", "c2=SResult c4="+t+" c6=Big2 create");
run("Yellow");

saveAs("Tiff", substring(current_file, 0, lengthOf(current_file)-4)+"_colored.tif");