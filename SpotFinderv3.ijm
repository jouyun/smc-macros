/*
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
open(current_file);
run("Clear Results");
t=getTitle();
selectWindow(t);
*/

//If already processed comment out these three

run("32-bit");
run("Subtract Background...", "rolling=100 stack");
run("Scale Ramp Zstack", "background=0 final=30 exponential?");
t=getTitle();

run("Duplicate...", "duplicate channels=3");
rename("Base");



//For 20X 2.5 will miss fewer but have a lot more guys double counted, 3 will miss more but have fewer false positives

//For An use i=4
i=3;
s=sx=sy=i;
//s=sx=sy=12;
sz=1.5;
run("LoG 3D", "sigmax="+s+" sigmay="+s+" sigmaz="+sz+" displaykernel=0 volume=1");

while (isOpen("LoG of Base")==false)
{
	wait(1000);
}
run("Invert", "stack");

rename("LoG");
run("3D Fast Filters","filter=MaximumLocal radius_x_pix=4.0 radius_y_pix=4.0 radius_z_pix=4.0 Nb_cpus=32");
run("Replace Zero With Noise", "baseline=-4000 spread=-3000");
//run("Threshold...");
setOption("BlackBackground", true);
setAutoThreshold("Default dark");

ttt=getTitle();
run("Duplicate...", "title=Unthresh duplicate");
run("32-bit");
run("Merge Channels...", "c6=Base c4=Unthresh create keep");
rename("Unthreshed Points");
selectWindow("Unthresh");
close();
selectWindow("3D_MaximumLocal");
setThreshold(750, 64000.0000);
//setThreshold(480, 64000.0000);


selectWindow("3D_MaximumLocal");
run("Convert to Mask", "method=Default background=Dark black");
selectWindow("3D_MaximumLocal");
rename("Mask");


selectWindow("Mask");

run("Duplicate...", "title=T duplicate");
run("32-bit");

run("Merge Channels...", "c2=Base c4=T create keep");

rename("Notated Points");
selectWindow("LoG");
close();
selectWindow("Base");
close();
selectWindow("T");
close();
selectWindow(t);


//Only necessary if don't have 3rd channel
/*run("Duplicate...", "title=AA duplicate channels=1");
selectWindow(t);
run("add channel", "target=AA");
selectWindow("Img");
run("Duplicate...", "title=AA duplicate channels=1");
selectWindow("Img");
run("add channel", "target=AA");*/



//run("Arrange Channels...", "new=132");
run("Compute 3D Blob Statistics Round", "mask=Mask first=12 lateral=3 threshold=100000000");
//run("Compute 3D Blob Statistics Round", "mask=Mask first=8 lateral=1 threshold=0");
t=getTitle();
Stack.setDisplayMode("composite");
Stack.setActiveChannels("101");
run("Magenta");
setMinAndMax(0, 1000);
Stack.setChannel(3);
run("Green");
setMinAndMax(0, 800);

return("");
run("Save As Tiff", "save="+current_file+"_processed.tif");

saveAs("Results", current_file+".csv");
run("Close All");
