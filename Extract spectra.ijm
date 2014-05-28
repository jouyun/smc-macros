rois=roiManager("count");
f = File.open("S:\\Microscopy\\USERS\\SMC\\Share\\Brainbow\ data\\rois.txt"); // display file open dialog
print(f, ""+400+"\t"+500+"\t"+600+"\n");
for (i=0; i<rois; i++)
{
	roiManager("Select", i);
	run("Plot Z-axis Profile");
	Plot.getValues(x, b);
	print(f, ""+b[2]+"\t"+b[0]+"\t"+b[1]+"\n");
	close();
}
