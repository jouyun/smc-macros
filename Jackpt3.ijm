run("Crop");
t=getTitle();

run("32-bit");
run("Percentile Threshold", "percentile=30 snr=8");
imageCalculator("Multiply create", t,"Result");
rename(t+"Results");
run("Find Maxima...", "noise=1 output=[Count]");
