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

current_dir=File.getParent(current_file);
resized_name=File.getName(current_file);
//raw_name=substring(current_file, 0, lengthOf(current_file)-12)+"_output.raw";
raw_name=current_file;

IJ.log(raw_name);


run("Raw...", "open="+raw_name+" image=8-bit width=512 height=512 number=1296420 little-endian");
t=getTitle();
Stack.getDimensions(w,h,c,s,f);
run("32-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=49 display=Grayscale");
makeRectangle(20, 20, 470, 470);
run("Clear Outside", "stack");
run("Make Image From Windows", "width=2048 height=2048 slices=1 staggered?");
//run("Brightness/Contrast...");
run("Make Composite", "display=Composite");
run("Split Channels");
selectWindow("C1-NewImg");
selectWindow("C2-NewImg");
selectWindow("C1-NewImg");
run("Multiply...", "value=1.250");
imageCalculator("Subtract create", "C2-NewImg","C1-NewImg");
selectWindow("Result of C2-NewImg");
setAutoThreshold("Default");
//run("Threshold...");
setThreshold(128.0000, 1000000000000000000000000000000.0000);
run("Convert to Mask");
run("Analyze Particles...", "  show=Outlines");

run("32-bit");
rename("Outlines");
IJ.log(resized_name);
IJ.log("/n/core/micro/nro/lo2296/smc/MuscleFibers/"+substring(resized_name, 0, lengthOf(resized_name)-11)+".tif");
open("/n/core/micro/nro/lo2296/smc/MuscleFibers/"+substring(resized_name, 0, lengthOf(resized_name)-11)+".tif");
tt=getTitle();
run("32-bit");
run("Merge Channels...", "c1="+tt+" c2=C1-NewImg c3=C2-NewImg c4=Outlines create");
Stack.setActiveChannels("1011");
Stack.setActiveChannels("1001");
run("Magenta");
run("Grays");
Stack.setActiveChannels("0001");
Stack.setActiveChannels("1001");
Stack.setChannel(4);
Stack.setDisplayMode("grayscale");
run("Invert", "slice");
Stack.setDisplayMode("composite");
saveAs("Tiff", substring(current_file, 0, lengthOf(current_file)-11)+"_annotated.tif");

