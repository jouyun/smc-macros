setBatchMode(true);
for (i=0; i<1000; i++)
{

selectWindow("CurrentGuess");
height=getHeight();
//runMacro("U:\\smc\\FiJi.app\\macros\\FP.ijm");
run("Forward Project", "number=360 angle=1");
rename("D");
imageCalculator("Subtract create 32-bit", "Data","D");
selectWindow("Result of Data");
selectWindow("D");
close();
selectWindow("Result of Data");
run("Select All");
run("Set Measurements...", "area mean standard min centroid center fit integrated redirect=None decimal=3");
run("Measure");
rename("A");
//runMacro("U:\\smc\\FiJi.app\\macros\\BP.ijm");
run("Back Project", "angle=1 new="+height);
rename("B");
imageCalculator("Add create 32-bit", "CurrentGuess","B");
selectWindow("Result of CurrentGuess");
selectWindow("B");
close();
selectWindow("Result of CurrentGuess");
selectWindow("CurrentGuess");
close();
selectWindow("Result of CurrentGuess");
selectWindow("A");
close();
selectWindow("Result of CurrentGuess");
saveAs("Tiff", "C:\\Data\\CurrentPhantomGuess"+IJ.pad(i,4)+".tif");
rename("CurrentGuess");
}