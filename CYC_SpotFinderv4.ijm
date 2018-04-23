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


//////************CHANGE ME TO WHATEVER FOLDER YOUR IMAGES ARE IN*************/
tmp_dir="S:\\micro\\mg2\\cyc\\smc\\20170815_SP5_TestImages\\";

//If already processed comment out these three
t=getTitle();
backsub_file=tmp_dir+t+"_backsub.tif";
unthreshed_file=tmp_dir+t+"_unthreshed.tif";
processed_file=tmp_dir+t+"_processed.tif";


if (File.exists(backsub_file))
{
	selectWindow(t);
	rename("old");
	open(backsub_file);
	rename(t);
}
else
{
	run("32-bit");
	//run("Scale Ramp Zstack", "background=0 final=.01");	
	run("Subtract Background...", "rolling=100 stack");
	t=getTitle();
	run("Save As Tiff", "save="+backsub_file);
	
}

run("Duplicate...", "duplicate channels=2");
rename("Base");

if (File.exists(unthreshed_file))
{
	open(unthreshed_file);
	rename("Unthreshed Points");
}
else
{
	//For 20X 2.5 will miss fewer but have a lot more guys double counted, 3 will miss more but have fewer false positives
	
	//For An use i=4
	i=3.5;
	s=sx=sy=i;
	//s=sx=sy=12;
	sz=0.8;
	run("LoG 3D", "sigmax="+s+" sigmay="+s+" sigmaz="+sz+" displaykernel=0 volume=1");
	
	while (isOpen("LoG of Base")==false)
	{
		wait(1000);
	}
	run("Invert", "stack");
	
	rename("LoG");
	run("3D Fast Filters","filter=MaximumLocal radius_x_pix=4.0 radius_y_pix=4.0 radius_z_pix=2.0 Nb_cpus=32");
	run("Replace Zero With Noise", "baseline=-200 spread=-3000");
	//run("Threshold...");
	setOption("BlackBackground", true);
	setAutoThreshold("Default dark");
	
	ttt=getTitle();
	run("Duplicate...", "title=Unthresh duplicate");
	run("32-bit");
	run("Merge Channels...", "c6=Base c4=Unthresh create keep");
	rename("Unthreshed Points");
	run("Save As Tiff", "save="+unthreshed_file);
	rename("Unthreshed Points");
}

run("Duplicate...", "duplicate channels=1");

setThreshold(0, 64000.0000);
run("Convert to Mask", "method=Default background=Dark black");
rename("Mask");


selectWindow("Mask");

run("Duplicate...", "title=T duplicate");
run("32-bit");

run("Merge Channels...", "c2=Base c4=T create keep");

rename("Notated Points");
//selectWindow("LoG");
//close();
selectWindow("Base");
close();
selectWindow("T");
close();
selectWindow(t);



run("Arrange Channels...", "new=213");
run("Compute 3D Blob Statistics Round", "mask=Mask first=10 lateral=3 threshold=00000000");
//run("Compute 3D Blob Statistics Round", "mask=Mask first=8 lateral=1 threshold=0");
t=getTitle();
Stack.setDisplayMode("composite");
Stack.setActiveChannels("011");
Stack.setChannel(2);
run("Magenta");
setMinAndMax(0, 50);
Stack.setChannel(3);
run("Green");
setMinAndMax(18,18);


run("Save As Tiff", "save="+processed_file);

saveAs("Results", t+".csv");
run("Close All");
