setSlice(nSlices);
mainT=getTitle();
main_dir=getDirectory("Choose a Directory");
analysis_file=main_dir+mainT+".csv";
f = File.open(analysis_file); // display file open dialog
roiManager("Deselect");
run("Duplicate...", "title=ABC");
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=8");
run("Open");
run("Fill Holes");
title=getTitle();
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=[Count Masks]");
run("Mask Largest");
setAutoThreshold("Default dark");
run("Convert to Mask");
t=getTitle();
selectWindow(title);
close();
selectWindow("ABC");
close();
selectWindow(t);
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing add");
selectWindow(t);
close();
/*selectWindow(t);
roiManager("Select", 0);
setSlice(nSlices);
setBackgroundColor(0, 0, 0);
run("Clear", "slice");
roiManager("Deselect");
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing add");
g=getTitle();
selectWindow(t);*/
//close();
//selectWindow(g);

selectWindow(mainT);
run("Clear Results");
for (i=1; i<=nSlices; i++)
{
	roiManager("Select", 0);
	setSlice(i);
	run("Measure");
	Bright=getResult("Mean", nResults-1);
	BrightArea=getResult("Area", nResults-1);
	BrightInt=getResult("IntDen", nResults-1);
	roiManager("Select", 1);
	setSlice(i);
	run("Measure");
	Back=getResult("Mean", nResults-1);
	BackArea=getResult("Area", nResults-1);
	BackInt=getResult("IntDen", nResults-1);
	roiManager("Select", 2);
	setSlice(i);
	run("Measure");
	Nucleus=getResult("Mean", nResults-1);
	NucleusArea=getResult("Area", nResults-1);
	NucleusInt=getResult("IntDen", nResults-1);
	BrightC=Bright-Back;
	NucleusC=Nucleus-Back;
	print(f, ""+i+","+ Bright+","+Nucleus+","+ Back+","+BrightC+","+NucleusC+","+BrightArea+","+NucleusArea+","+(BrightC*BrightArea/(NucleusC*NucleusArea))+","+(BrightArea/NucleusArea));
}
File.close(f);