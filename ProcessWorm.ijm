tmp=getTitle();
run("Invert");

run("Split Channels");
selectWindow("C3-"+tmp);
rename("B");
selectWindow("C2-"+tmp);
rename("G");
selectWindow("C1-"+tmp);
rename("R");
imageCalculator("Average create 32-bit", "R","G");
rename("AvgGR");
imageCalculator("Subtract create 32-bit", "AvgGR","B");
rename("InSitu");
selectWindow("AvgGR");
close();
selectWindow("B");
setAutoThreshold("Default dark");
run("Convert to Mask");
rename("WormMask");
run("Set Measurements...", "area mean centroid center fit integrated redirect=None decimal=3");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=Masks clear");
rename("tmp");
selectWindow("WormMask");
close();
selectWindow("tmp");
rename("WormMask");
print(nResults);
number_worms=nResults;
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
rename("Regions");
selectWindow("WormMask");
run("Set Measurements...", "area mean centroid center fit integrated redirect=None decimal=3");
run("Analyze Particles...", "size=100000-Infinity circularity=0.00-1.00 show=Nothing display clear");
run("Planaria Analyze", "region=Regions mask=WormMask in=InSitu");
rename("MaskedInSitu");
selectWindow("R");
close();
selectWindow("Regions");
close();
selectWindow("G");
close();

selectWindow("WormMask");
run("Find Connected Regions", "allow_diagonal display_image_for_each regions_for_values_over=100 minimum_number_of_points=100 stop_after=-1");
print(""+getImageID()+"\n");
print(""+number_worms+"\n");
last_img=getImageID();
selectImage(last_img);
rename("A");
selectImage(last_img+1);
rename("B");
run("Concatenate...", "  title=[A] image1=A image2=B image3=[-- None --]");
for (i=last_img+2; i<(last_img+number_worms); i++)
{
	print (last_img+"\n");
	print (i+"\n");
	selectImage(i);
	rename("B");
	run("Concatenate...", "  title=[A] image1=A image2=B image3=[-- None --]");
}
rename("WormMaskStack");
//run("Calculator Plus", "i1=InSitu i2=G operation=[Scale: i2 = i1 x k1 + k2] k1=1 k2=10000 create");
//rename("tmp");
//imageCalculator("Multiply create 32-bit", "tmp","WormMask");
//rename("MaskedInSitu");
//selectWindow("tmp");
//close();
selectWindow("MaskedInSitu");

run("Duplicate...", "title=InSituMask");
//setAutoThreshold("MaxEntropy dark");
setThreshold(0, 1.00);
run("Convert to Mask");
run("Invert");
run("Erode");
run("Erode");
run("Erode");
run("Erode");
run("Dilate");
run("Dilate");
run("Dilate");
imageCalculator("XOR create 32-bit", "WormMask","InSituMask");
rename("InSituInvMask");
imageCalculator("Multiply create 32-bit", "MaskedInSitu","InSituMask");
rename("Pharynx");
imageCalculator("Multiply create 32-bit", "MaskedInSitu","InSituInvMask");
rename("NonPharynx");
selectWindow("InSitu");
close();
selectWindow("MaskedInSitu");
close();

run("Set Measurements...", "integrated redirect=None decimal=3");
imageCalculator("Multiply create 32-bit stack", "WormMaskStack","NonPharynx");
rename("NonPharynxStack");
imageCalculator("Multiply create 32-bit stack", "WormMaskStack","Pharynx");
rename("PharynxStack");
imageCalculator("Multiply create 32-bit stack", "WormMaskStack","InSituMask");
rename("InSituMaskStack");
imageCalculator("Multiply create 32-bit stack", "WormMaskStack","InSituInvMask");
rename("InSituInvMaskStack");
x = newArray(number_worms);
run("Clear Results");
//IJ.deleteRows(1, 100)
for (i=0; i<number_worms; i++)
{
	selectWindow("InSituMaskStack");
	setSlice(i+1);
	run("Measure");

	selectWindow("PharynxStack");
	setSlice(i+1);
	run("Measure");
	
	selectWindow("InSituInvMaskStack");
	setSlice(i+1);
	run("Measure");	
	
	selectWindow("NonPharynxStack");
	setSlice(i+1);
	run("Measure");	

	pharynxarea=getResult("IntDen", i*4+0);
	pharynxtotal=getResult("IntDen", i*4+1);
	nonpharynxarea=getResult("IntDen", i*4+2);
	nonpharynxtotal=getResult("IntDen", i*4+3);
	print("Fraction of worm in pharynx:  "+ pharynxarea/(pharynxarea+nonpharynxarea)+"\n");
	print("Average intensity in pharynx vs nonpharynx:  "+(pharynxtotal/pharynxarea)/(nonpharynxtotal/nonpharynxarea) +"\n");
	
	x[i]=getResult("IntDen", i*4+1);
}
selectWindow("InSituInvMaskStack");
selectWindow("NonPharynxStack");
close();
selectWindow("InSituInvMaskStack");
close();
selectWindow("PharynxStack");
close();
selectWindow("InSituMaskStack");
close();
selectWindow("Pharynx");
close();
selectWindow("NonPharynx");
close();
selectWindow("InSituMask");
close();
selectWindow("InSituInvMask");
selectWindow("WormMaskStack");
close();
selectWindow("InSituInvMask");
close();
selectWindow("WormMask");
close();
		