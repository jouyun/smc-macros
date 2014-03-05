//opens dialog box to choose raw file
run("Raw...", "");
//obtains the path for the directory where the raw file is saved and will use this same directory for saving the files to be created
dir = getInfo("image.directory")
raw = getTitle()
tot = nSlices
print (tot);
//dialog box: enter the number of z slices into the value for stacks (default value=200)
stack = getNumber("z slices per stack", 200)
//dialog box: enter the number of views (default=8) assumes 360 total rotation of sample
views = getNumber("Views", 8)
angle = 360 / views
//max is the max value for i (since i begins at 0, the max value is always 1 less than 2*views.  the 2* is due to the fact that there are 2 channels for each view (red and green typically)
max = 2 * views -1
for (i=0; i<=max; i++) {
	j = i - 1;
	f = 1 + i * stack;
	l = stack + i * stack;
	selectWindow(raw);
	//using slice keeper to pull out data for one channel at a time
	run("Slice Keeper", "first=f last=l increment=1");
	//saving the data for one channel into the same folder of the raw file
	selectWindow(raw + " kept stack");
	//the if/else statement is required for the different naming required to separate the 2 channels (usually a sample channel and a beads channel)
	if (i % 2 == 0) {
		ang = (i - i / 2) * angle;
		//adding zeros to make all numbers 3 digits in the saved name
		aaa = IJ.pad(ang,3);
		saveAs("Tiff", dir + "s_angle_" + aaa + ".tiff");
	} else {
		ang = (j - j/2) * angle;
		aaa = IJ.pad(ang,3);
		saveAs("Tiff", dir + "b_angle_" + aaa + ".tiff");
	}
	close();
}
selectWindow(raw);
close();
