t=getTitle();
setBatchMode(true);
//for (i=0; i<1000; i++)
for (i=0; i<100; i++)
{
	selectWindow(t);
	run("Duplicate...", "title=New duplicate");
	angle=floor(random*180);
	x_shift=floor(random*200-100);
	y_shift=floor(random*200-100);
	run("Rotate... ", "angle="+angle+" grid=1 interpolation=Bilinear stack");
	run("Translate...", "x="+x_shift+" y="+y_shift+" interpolation=None stack");
}

run("Concatenate...", "all_open title=[Concatenated Stacks]");
rename(t);

makeRectangle(256, 256, 512, 512);
run("Crop");
saveAs("Tiff", "/home/smc/Data/BRS/DeepLearn/"+t+"_RotShift.tif");
return("");
Stack.getDimensions(w,h,c,s,f);
run("Split Channels");
selectWindow("C2-"+t);
setAutoThreshold("Default dark");


setThreshold(10000, 65535);

setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Skeletonize", "stack");
run("16-bit");
run("Merge Channels...", "c1=C1-"+t+" c2=C2-"+t+" c3=C3-"+t+" create");
saveAs("Tiff", "/home/smc/Data/SMC/CellOutlineTrainingData/"+t+"_Test.tif");
run("Close All");
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }

}