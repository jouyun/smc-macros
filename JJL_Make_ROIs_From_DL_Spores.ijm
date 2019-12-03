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

if (isOpen("ROI Manager"))
{
    selectWindow("ROI Manager");
    run("Close");
}

//********************************************
//Run spores
//********************************************
run("Raw...", "open="+current_file+" width=256 height=256 offset=0 number=100000 little-endian");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=9 display=Grayscale");
run("32-bit");
rt=getTitle();
run("Make Image From Windows", "width=512 height=512 slices=1 staggered?");
run("Make Composite", "display=Grayscale");


if (isOpen("ROI Manager"))
{
    selectWindow("ROI Manager");
    run("Close");
}

t=getTitle();
run("Duplicate...", "title=Outlines duplicate channels=2");
setMinAndMax(0, 256);
run("8-bit");
selectWindow(t);
run("Duplicate...", "title=Masks duplicate channels=3");
setMinAndMax(0, 256);
run("8-bit");
imageCalculator("Subtract create stack", "Masks","Outlines");
setThreshold(127, 255);
run("Convert to Mask", "method=Default background=Dark black");
run("Analyze Particles...", "size=10-Infinity show=Masks stack");
run("Invert LUT");
run("Dilate", "stack");
run("Dilate", "stack");
run("Watershed", "stack");
run("Analyze Particles...", "size=10-Infinity show=Nothing add stack");
roiManager("Save", substring(current_file, 0, lengthOf(current_file)-4)+".zip");
run("Close All");

//********************************************
//Run spore sac
//********************************************

run("Raw...", "open="+substring(current_file, 0, lengthOf(current_file)-4)+"b.raw width=256 height=256 offset=0 number=100000 little-endian");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=9 display=Grayscale");
run("32-bit");
rt=getTitle();
run("Make Image From Windows", "width=512 height=512 slices=1 staggered?");
run("Make Composite", "display=Grayscale");


if (isOpen("ROI Manager"))
{
    selectWindow("ROI Manager");
    run("Close");
}

//setThreshold(28, 255);
run("Duplicate...", "title=A duplicate channels=3");
setThreshold(20, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Analyze Particles...", "size=5-Infinity show=Masks stack");
run("Invert LUT");
run("Duplicate...", "duplicate");
run("Dilate", "stack");
run("Dilate", "stack");
run("Watershed", "stack");
run("Analyze Particles...", "size=5-Infinity add stack");
roiManager("Save", substring(current_file, 0, lengthOf(current_file)-4)+"b.zip");