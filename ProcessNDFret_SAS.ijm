threshold=500;
tmp = getDirectory("temp");

name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}


list = getFileList(source_dir);
Array.sort(list);

for (m=0; m<(list.length/2); m++)
{
	IJ.log(list[2*m]);
	run("Bio-Formats Importer", "open=["+source_dir+File.separator+list[m*2]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats Importer", "open=["+source_dir+File.separator+list[m*2+1]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	if (isOpen("ROI Manager"))
	{
		selectWindow("ROI Manager");
		run("Close");
	}
	slices=15;
	ttt=getTitle();
	run("Concatenate...", "all_open title="+ttt);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices="+slices+" frames=2 display=Grayscale");
	t=getTitle();
	run("Gaussian Blur...", "sigma=1 stack");
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
	//run("Duplicate...", "duplicate channels=1");
	run("Duplicate...", "duplicate channels=1-2");
	run("Subtract Background...", "rolling=3 stack");
	
	tmp=getTitle();
	selectWindow(t);
	close();
	selectWindow(tmp);
	rename(t);
	
	run("StackRegJ_", "transformation=[Rigid Body]");
	run("Hyperstack to Stack");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=1 display=Grayscale");
	run("Arrange Channels...", "new=1324");
	//run("Find Maxima...", "noise=750 output=[Point Selection]");
	run("Find Maxima...", "noise="+threshold+" output=[Point Selection]");
	rename(t);
	run("32-bit");
	//run("seeded multipoint adaptive region grow", "background=2000 drop=.5 minimum=-150 quantify minimum=5 maximum=20");
	run("seeded multipoint adaptive region grow", "background=0 drop=.5 minimum=-150 quantify minimum=5 maximum=20");
	wait(1000);
	run("Close All");
	
}
