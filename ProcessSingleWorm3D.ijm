// 5 2 2000

xy_blur=5.0;
z_blur=2.0;
thresh=8000;
SNR_worm=20;
SNR_peaks=50;

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
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);
roiManager("reset");

t=getTitle();

//********************DAPI*****************************
selectWindow(t);
run("Duplicate...", "title=DAPI duplicate channels=3");
run("Grays");
run("Z Project...", "projection=[Max Intensity]");
ttt=getTitle();
run("32-bit");
run("Percentile Threshold", "percentile=30 snr="+SNR_worm);
selectWindow("Result");
run("Fill Holes");
run("Open");

run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=[Count Masks]");

rename("duh");
run("Mask Largest");

setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");

for (i=0; i<0; i++)
{
	run("Erode");
}
rename("Mask");
selectWindow("Result");
close();
selectWindow("Mask");

run("Analyze Particles...", "size=30000-Infinity circularity=0.00-1.00 show=Nothing add");
ct=roiManager("count");

if (ct>0)
{
	selectWindow(t);
	roiManager("select", 0);
	run("Crop");
	run("Select All");


	
	//**********************PIWI****************************
	selectWindow(t);
	run("Duplicate...", "title=piwi duplicate channels=2");
	tt=getTitle();
	run("Log3D", "sigmax="+xy_blur+" sigmay="+xy_blur+" sigmaz="+z_blur);
	run("3D Fast Filters","filter=MaximumLocal radius_x_pix="+xy_blur+" radius_y_pix="+xy_blur+" radius_z_pix="+z_blur+" Nb_cpus=20");
	selectWindow("3D_MaximumLocal");
	setAutoThreshold("Default dark");
	setThreshold(thresh, 1000000000000000000000000000000.0000);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark black");
	run("16-bit");
	//run("Gaussian Blur 3D...", "x=8 y=8 z=1");
	run("Enhance Contrast", "saturated=0.35");
	run("Divide...", "value=255.000 stack");
	run("Z Project...", "projection=[Sum Slices]");
	run("Select All");
	run("Measure");
	setResult("Label", nResults-1, current_file);

	//DAPI
	selectWindow(t);
	roiManager("select", 0);
	run("Measure");
	run("Select All");

	
	//****************H3P*******************************************
	selectWindow(t);
	run("Duplicate...", "title=H3P duplicate channels=1");
	run("Grays");
	run("Z Project...", "projection=[Max Intensity]");
	run("Gaussian Blur...", "sigma=2 slice");
	roiManager("select", 0);
	run("Find Maxima...", "noise="+SNR_peaks+" output=[Count]");
	
	area=getResult("Area", nResults-2);
	setResult("MaskArea", nResults-3, area);
	count=getResult("Count", nResults-1);
	setResult("Count", nResults-3, count);
	IJ.deleteRows(nResults-2, nResults-1);
}