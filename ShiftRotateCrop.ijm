t=getTitle();
setBatchMode(false);
//for (i=0; i<1000; i++)
number_turns=99;
Stack.getDimensions(w,h,c,s,f);
for (i=0; i<number_turns; i++)
{
	selectWindow(t);
	run("Duplicate...", "title=New duplicate");
	angle=floor(random*360)-180;
	x_shift=floor(random*500-250);
	y_shift=floor(random*500-250);
	run("Rotate... ", "angle="+angle+" grid=1 interpolation=Bilinear stack");
	run("Translate...", "x="+x_shift+" y="+y_shift+" interpolation=Bilinear stack");
}

run("Concatenate...", "all_open title=[Concatenated Stacks]");
rename(t);

makeRectangle(256, 256, 512, 512);
run("Crop");
/*run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices="+(number_turns+1)+" frames="+f+" display=Grayscale");
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames="+(f*number_turns)+" display=Grayscale");
*/

saveAs("Tiff", "/n/projects/smc/public/STN/19-6-3b_ali_level_fullsize/Training/"+t+"_RotShift.tif");
//saveAs("Tiff", "/n/projects/smc/public/STN/NucleiDLTest/alignedFullRes_slices300-400/"+t+"_RotShift.tif");
//run("Save As Tiff", "save=/n/core/micro/nro/lo2296/smc/MuscleFibers/DL/"+t+"_RotShift.tif");
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