//How thick do you want the outline?
thickness=5;

//If too much is being outlined raise this number, if too little is being outlined lower it
//1.5-5 is the range I've found useful
threshold=2.0;

run("Duplicate...", "title=A");
run("32-bit");
run("Gaussian Blur...", "sigma=10");
setAutoThreshold("Default dark");
//run("Threshold...");
run("Percentile Threshold", "percentile=10 snr="+threshold);
run("Fill Holes");
rename("B");
run("Duplicate...", "title=C");
for (i=0; i<thickness; i++)
{
	run("Dilate");	
}

imageCalculator("Subtract create", "C","B");
rename("D");
selectWindow("A");
close();
selectWindow("B");
close();
selectWindow("C");
close();
selectWindow("D");
