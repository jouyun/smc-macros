title=getTitle();
run("Z Project...", "start=1 stop=14113 projection=Median");
imageCalculator("Subtract create 32-bit stack", title,"MED_"+title);
selectWindow("Result of "+title);
//run("Threshold...");
setAutoThreshold("Otsu");
run("Convert to Mask", "calculate");
run("MTrack2 ", "minimum=10 maximum=999999 maximum_=30 minimum_=2 save display show show show save=[C:\\Data\\AMM\\First Real Data\\trackresults2.txt]");

