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
parent_dir=File.getParent(source_dir);
tmp_dir=parent_dir+File.separator+"tmp"+File.separator;
worm_dir=parent_dir+File.separator+"Worms"+File.separator;
IJ.log(""+tmp_dir);
File.makeDirectory(tmp_dir);
File.makeDirectory(worm_dir);
base_name=File.getName(first_file);

space=0;
current=0;
last=0;
temp=indexOf("abcdef", "g");
IJ.log(base_name);

while (indexOf(substring(base_name,current,lengthOf(base_name)),"_")>-1)
{
	last=current;
	IJ.log(substring(base_name,current,lengthOf(base_name)));
	current=indexOf(substring(base_name,current,lengthOf(base_name)),"_")+current+1;
}
space=indexOf(substring(base_name,current,lengthOf(base_name))," ")+current+1;
IJ.log("Found it: "+substring(base_name,last,current-1)+","+substring(base_name,current,space-1)+","+space);
width=parseInt(substring(base_name,last, current-1));
height=parseInt(substring(base_name,current,space-1));






number_images=width*height;

run("Image Sequence...", "open=["+first_file+"] number="+number_images+" starting=1 increment=1 scale=100 file=.tiff sort");
t=getTitle();
zslices=nSlices/number_images-1;
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+(nSlices/number_images)+" frames="+number_images+" display=Grayscale");
run("Duplicate...", "title=A duplicate slices="+(1)+" frames=1-"+number_images);
selectWindow(t);
run("Z Project...", "start=2 stop="+(zslices+1)+" projection=[Max Intensity] all");
rename("B");

run("Concatenate...", "  title=C image1=A image2=B image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytzc channels=2 slices=1 frames="+number_images+" display=Grayscale");
selectWindow(t);
close();
selectWindow("C");
runMacro("SaveMultipageImageSequence.ijm", tmp_dir);

run("merge objects in tiles", "snr=15 hit=100000 border=100 in=40000 x="+width+" y="+height+" path="+tmp_dir);

current_worm=0;
for (j=1; j<100; j++)
{
	ttitle="Fused_"+j;
	if (isOpen(ttitle))
	{
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
		
	}
}
selectWindow("C");
close();