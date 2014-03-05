SNR_worm=10;
start_SNR=30;
range_SNR=30;
setBatchMode(true);
current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite");
open(current_file);
title=getTitle();
run("Invert");
run("32-bit");
run("Duplicate...", "title=tmp");
run("Smooth");
run("Subtract Background...", "rolling=800");
run("Percentile Threshold", "percentile=10 snr="+SNR_worm);
run("Fill Holes");
rename("Mask");
selectWindow("tmp");
close();
selectWindow("Mask");
rename("Premask");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=[Count Masks] display clear add");
rename("duh");
run("Mask Largest");
setAutoThreshold("Default dark");
setThreshold(1, 10000);
run("Convert to Mask");
run("Fill Holes");
rename("Mask");
selectWindow("Premask");
close();
selectWindow("Mask");
run("Analyze Particles...", "size=60000-Infinity circularity=0.00-1.00 show=Nothing display clear add");
print("\\Clear");
my_area=getResult("Area");


selectWindow(title);
run("Subtract Background...", "rolling=50");
run("Smooth");

//Added 10-16 a local contrast enhancer
run("Enhance Local Contrast (CLAHE)", "blocksize=49 histogram=256 maximum=4 mask=Mask");
//run("Enhance Local Contrast (CLAHE)", "blocksize=49 histogram=256 maximum=3 mask=Mask fast_(less_accurate)");
//End addition

//Find maximal process count and its SNR
values=newArray(range_SNR);
SNRs=newArray(range_SNR);
for (i=0; i<range_SNR; i++)
{
	selectWindow(title);
	run("Percentile Threshold With Mask", "region=Mask percentile=10 snr="+(i+start_SNR));
	run("Analyze Particles...", "size=10-Infinity circularity=0.00-1.00 show=Nothing display clear");
	values[i]=nResults;
	SNRs[i]=i+start_SNR;
	selectWindow("Result");
	close();
}
max_protos=0;
max_SNR=0;
for (i=0; i<range_SNR; i++)
{
	if (values[i]>max_protos)
	{
		max_protos=values[i];
		max_SNR=SNRs[i];
	}
	//IJ.log("SNR("+(i+start)+"): "+v[i]);
}
selectWindow(title);
//END find maximal process count and SNR

//Create counting image
run("Percentile Threshold With Mask", "region=Mask percentile=10 snr="+max_SNR);
rename("PrePeaks");
run("Analyze Particles...", "size=10-Infinity circularity=0.00-1.00 show=Masks display clear add");
rename("Peaks");
selectWindow("PrePeaks");
close();
//Finish counting image

//Create area image
selectWindow(title);
run("Percentile Threshold With Mask", "region=Mask percentile=10 snr="+(max_SNR/1.65));
rename("PreArea");
run("Analyze Particles...", "size=10-Infinity circularity=0.00-1.00 show=Masks display clear add");
number_pros=nResults;
avg_pro=0;
for (i=0; i<nResults; i++)
{
	avg_pro=avg_pro+getResult("Area", i);
}
rename("Area");
selectWindow("PreArea");
close();
//Finish area image

//Convert all to 32bit
selectWindow("Peaks");
run("32-bit");
selectWindow("Mask");
run("32-bit");
selectWindow("Area");
run("32-bit");


run("Concatenate...", "  title=Results image1=Mask image2="+title+" image3=Peaks image4=Area image5=[-- None --]");
saveAs("Tiff", current_file+"_smooth_mask.tif");
close();
print("\\Clear");
IJ.log(""+max_protos+","+avg_pro+","+my_area+","+max_SNR);
logs=getInfo("log");
setBatchMode(false);
return logs;