t=getTitle();
ct=roiManager("count");
while(ct>0)
{
	roiManager("select",0);
	roiManager("Delete");
	ct=roiManager("count");
}
run("Select All");

/*run("Duplicate...", "duplicate channels=4");
tmp=getTitle();
run("Z Project...", "projection=[Max Intensity]");
tmp2=getTitle();
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=20");
run("Analyze Particles...", "size=1000000-Infinity add");
selectWindow(t);
roiManager("Select", 0);
run("Crop");
selectWindow(tmp);
close();
selectWindow(tmp2);
close();
selectWindow("Result");
close();
ct=roiManager("count");
while(ct>0)
{
	roiManager("select",0);
	roiManager("Delete");
	ct=roiManager("count");
}*/


selectWindow(t);
run("Magenta");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1100");

run("Duplicate...", "duplicate channels=1");
tmp=getTitle();
run("Z Project...", "projection=[Max Intensity]");
tmp2=getTitle();
run("32-bit");
run("Percentile Threshold", "percentile=10 snr=100");
run("Analyze Particles...", "size=20-Infinity add");

selectWindow(tmp);
close();
selectWindow(tmp2);
close();
selectWindow("Result");
close();
selectWindow(t);
run("Filter ROIs Zoom");