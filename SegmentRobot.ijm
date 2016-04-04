run("32-bit");
run("Percentile Threshold", "percentile=10 snr=8");
setOption("BlackBackground", true);
//run("Fill Holes");

run("Analyze Particles...", "size=100000-2000000 show=Masks display exclude clear add");

selectWindow("Mask of Result");
rename("Segmented");
run("Invert LUT");
selectWindow("Fused");
close();
selectWindow("Result");
close();
selectWindow("Segmented");
