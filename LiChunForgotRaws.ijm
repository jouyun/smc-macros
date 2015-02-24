first_file=getArgument;
if (first_file=="")
{
     first_file=File.openDialog("Pick one");
}
else
{
     //current_file=name;
}


source_dir = File.getParent(first_file);
//parent_dir=File.getParent(source_dir);
parent_dir=source_dir;
worm_dir=parent_dir+File.separator+"Worms"+File.separator;

File.makeDirectory(worm_dir);
base_name=File.getName(first_file);




open(first_file);

t=getTitle();
zslices=nSlices-1;
run("Duplicate...", "title=A");
selectWindow(t);

run("Z Project...", "start=2 stop="+(zslices+1)+" projection=[Max Intensity] all");
rename("B");
run("Concatenate...", "  title=C image1=A image2=B image3=[-- None --]");
selectWindow(t);
close();
selectWindow("C");

current_worm=0;
	ttitle=getTitle();
	selectWindow(ttitle);
	run("32-bit");
	selectWindow(ttitle);
	run("Duplicate...", "duplicate channels=1 slices=1");
	temp=getTitle();
	run("Percentile Threshold", "percentile=10 snr=15");
	run("Fill Holes");
	run("Open");
	run("Analyze Particles...", "size=100000-Infinity display clear add");
	num=roiManager("count");
	for (i=0; i<num; i++)
	{
		selectWindow(ttitle);
		roiManager("Select", i);
		run("Duplicate...", "title=Worm"+(i+1)+".tif duplicate channels=1-4");
		saveAs("Tiff", worm_dir+"Worm"+IJ.pad(current_worm,4)+".tif");
		close();
		current_worm++;
	}
	selectWindow("Result");
	close();
	selectWindow(ttitle);
	close();
	selectWindow(temp);
	close();
		