if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
setSlice(1);
t=getTitle();
run("Enhance Contrast", "saturated=0.35");
run("Duplicate...", "title=Mask");
run("Gaussian Blur...", "sigma=2 stack");
run("Subtract Background...", "rolling=150 stack");
run("32-bit");
//run("Percentile Threshold", "percentile=50 snr=150");
run("Percentile Threshold", "percentile=50 snr=60");
run("Fill Holes");
rename(t+"_processed");

run("Analyze Particles...", "size=8000-52000 circularity=0.30-1.00 display add");

selectWindow(t);
run("Duplicate...", "title=Points");
run("Grays");
run("Gaussian Blur...", "sigma=1");
run("Minimum...", "radius=3");
run("Gaussian Blur...", "sigma=2");

ct=roiManager("Count");
for (i=0; i<ct; i++)
{
    roiManager("Select", i);


    run("Measure");
    mean=getResult("Mean", nResults-1);
    setResult("Mean", nResults-ct-1+i, mean);
    IJ.deleteRows(nResults-1, nResults-1);   

    run("Find Maxima...", "noise=30 output=Count");
    pt_count=getResult("Count", nResults-1);
    setResult("Count", nResults-ct-1+i, pt_count);
    IJ.deleteRows(nResults-1, nResults-1);   
}


