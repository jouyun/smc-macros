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

//tmp_dir="S:\\micro\\asa\\aai\\smc\\20170726_3PO_RetinaQuantification\\20170727_074645_167\\";
tmp_dir="D:\\SMC\\AAI\\";

//If already processed comment out these three
t=getTitle();
backsub_file=tmp_dir+t+"_backsub.tif";
unthreshed_file=tmp_dir+t+"_unthreshed.tif";
save_file=tmp_dir+t+"_processed.tif";

run("Duplicate...", "title=B duplicate");
selectWindow(t);
run("Duplicate...", "title=C duplicate");
run("Merge Channels...", "c1="+t+" c2=B c3=C create");
rename(t);

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
	run("Scale Ramp Zstack", "background=100 final=30 exponential?");
	run("Subtract Background...", "rolling=100 stack");
	t=getTitle();
	run("Save As Tiff", "save="+backsub_file);
	
}

run("Duplicate...", "duplicate channels=3");
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
	i=3;
	s=sx=sy=i;
	//s=sx=sy=12;
	sz=1;
run("Log3D", "imp=Base sigmax="+i+" sigmay="+i+" sigmaz="+sz);	
	
	rename("LoG");
	run("3D Fast Filters","filter=MaximumLocal radius_x_pix=4.0 radius_y_pix=4.0 radius_z_pix=2.0 Nb_cpus=32");
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

setThreshold(4000, 640000.0000);
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



//run("Arrange Channels...", "new=132");
run("Compute 3D Blob Statistics Round", "mask=Mask first=10 lateral=3 threshold=00000000");
//run("Compute 3D Blob Statistics Round", "mask=Mask first=8 lateral=1 threshold=0");
t=getTitle();
Stack.setDisplayMode("composite");
Stack.setActiveChannels("101");
run("Magenta");
setMinAndMax(0, 1000);
Stack.setChannel(3);
run("Green");
setMinAndMax(0, 800);


run("Save As Tiff", "save="+save_file);
/*
saveAs("Results", current_file+".csv");
run("Close All");*/
