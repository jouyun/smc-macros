
tmp_dir=getArgument;

if (tmp_dir=="")
{
     tmp_dir = getDirectory("Source Directory");
}
else
{
     //current_file=name;
}

//tmp_dir="S:\\micro\\asa\\aai\\smc\\20170726_3PO_RetinaQuantification\\20170727_074645_167\\";
//tmp_dir="S:\\micro\\asa\\fgm\\smc\\20170729_Screen\\20170817_3PO_20X\\20170816_093646_990\\";
//tmp_dir="D:\\fgm\\";

//If already processed comment out these three
t=getTitle();
mask_file=tmp_dir+t+"_mask.tif";
projection_file=tmp_dir+t+"_projection.tif";
backsub_file=tmp_dir+t+"_backsub.tif";
unthreshed_file=tmp_dir+t+"_unthreshed.tif";
save_file=tmp_dir+t+"_processed.tif";


rename(t);
IJ.log(t);
IJ.log(backsub_file);

if (File.exists(backsub_file))
{
	selectWindow(t);
	close();
	open(backsub_file);
	rename(t);
}
else
{
	Stack.getDimensions(w, h, c, s, f);
	run("32-bit");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames="+f+" display=Grayscale");
	Stack.setChannel(2);
	run("Arrange Channels...", "new=312");

	run("Trim In Z Automatically", "fraction=.01");
	selectWindow(t);
	close();
	selectWindow("Img");
	rename(t);

	Stack.getDimensions(w, h, c, s, f);
	run("32-bit");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices="+s+" frames="+f+" display=Grayscale");
	run("Make Composite", "display=Composite");
	run("Split Channels");
	selectWindow("C1-"+t);
run("Subtract Background...", "rolling=1000 stack");	
	run("Scale Ramp Zstack", "background=000 final=80 exponential?");
	run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=C3-"+t+" create");
	rename(t);
	
	run("Subtract Background...", "rolling=1000 stack");
	//run("Subtract...", "value=105 stack");
	t=getTitle();
	run("Save As Tiff", "save=["+backsub_file+"]");
	
}

run("Duplicate...", "duplicate channels=1");
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
	i=5;
	s=sx=sy=i;
	//s=sx=sy=12;
	sz=1;
	run("Log3D", "imp=Base sigmax="+i+" sigmay="+i+" sigmaz="+sz);	
	
	rename("LoG");
	run("3D Fast Filters","filter=MaximumLocal radius_x_pix=4.0 radius_y_pix=4.0 radius_z_pix=2.0 Nb_cpus=32");
	setOption("BlackBackground", true);
	setAutoThreshold("Default dark");
/*setThreshold(4084.0850, 400055.4492);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");*/

	ttt=getTitle();
	run("Duplicate...", "title=Unthresh duplicate");
	run("32-bit");
	run("Merge Channels...", "c6=Base c4=Unthresh create keep");
	rename("Unthreshed Points");
	
	run("Save As Tiff", "save=["+unthreshed_file+"]");
	rename("Unthreshed Points");
}

//Multiplying by the mask, can be completely disabled
/*open(mask_file);
rename("P");
imageCalculator("Multiply create 32-bit stack", "Unthreshed Points","P");
rename("Masked");
selectWindow("Unthreshed Points");
close();
selectWindow("P");
close();
selectWindow("Masked");
rename("Unthreshed Points");*/

run("Duplicate...", "duplicate channels=1");

setThreshold(5200, 640000000.0000);
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


run("Pad To Certain Channels", "number=3");
//run("Arrange Channels...", "new=132");
run("Compute 3D Blob Statistics Round", "mask=Mask first=12 lateral=2 threshold=0000000000000");
//run("Compute 3D Blob Statistics Round", "mask=Mask first=8 lateral=1 threshold=0");
t=getTitle();
run("Make Composite", "display=Composite");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("101");
run("Green");
setMinAndMax(0, 1000);
Stack.setChannel(3);
run("Magenta");
setMinAndMax(0, 800);


run("Save As Tiff", "save=["+save_file+"]");

saveAs("Results", backsub_file+".csv");
//run("Close All");
