tmp_dir=getArgument;

if (tmp_dir=="")
{
     tmp_dir = getDirectory("Source Directory");
}
else
{
     //current_file=name;
}

//makeRectangle(424, 424, 1200, 1200);
//makeRectangle(262, 1156, 734, 658);
//run("Crop");

t=getTitle();

backsub_file=tmp_dir+t+"_backgroundp.tif";
median_file=tmp_dir+t+"_medianp.tif";

if (File.exists(backsub_file))
{
	selectWindow(t);
	close();
	open(backsub_file);
	rename("Img");
}
else
{
	Stack.setChannel(2);
	run("Subtract Background...", "rolling=300 stack");
	run("Trim In Z Automatically", "fraction=0.005");
	run("Make Composite", "display=Grayscale");
	run("Split Channels");
	selectWindow("C1-Img");
	run("Scale Ramp Zstack", "background=0 final=0.3");
	selectWindow("C2-Img");
	run("Scale Ramp Zstack", "background=0 final=0.3");
	selectWindow("C3-Img");
	run("Scale Ramp Zstack", "background=0 final=20 exponential?");
	run("Merge Channels...", "c1=C1-Img c2=C2-Img c3=C3-Img create");

	run("Save As Tiff", "save="+backsub_file);
	rename("Img");
}
/*
if (File.exists(median_file))
{
	open(median_file);
	rename("Median");
}
else
{
	run("Duplicate...", "duplicate channels=1-2");
	run("Median...", "radius=10 stack");
	run("Save As Tiff", "save="+median_file);
	rename("Median");
}

run("Split Channels");
imageCalculator("Multiply create 32-bit stack", "C1-Median","C2-Median");

	//makeRectangle(424, 424, 1200, 1200);
	//run("Crop");


setOption("BlackBackground", true);
//setThreshold(145000, 65535000000);
setThreshold(200000, 65535000000);

run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=2000 max_size=-1");

selectWindow("Seg");
run("32-bit");
selectWindow("Img");

	//makeRectangle(424, 424, 1200, 1200);
	//run("Crop");


run("add channel", "target=Seg");
run("Arrange Channels...", "new=4123");
Stack.setChannel(1);
run("Separate Out 3D Objects");
for (i=0; i<100; i++)
{
	tmp="Object"+(i+1);
	if (isOpen(tmp))
	{
		selectWindow(tmp);
		run("Split Channels");
		selectWindow("C1-"+tmp);
		run("Divide...", "value="+(i+1)+" stack");
		run("Merge Channels...", "c1=C1-"+tmp+" c2=C2-"+tmp+" c3=C3-"+tmp+" c4=C4-"+tmp+" create");
		rename(tmp);
		for (j=1; j<5; j++)
		{
			Stack.setChannel(j);
			run("Enhance Contrast", "saturated=0.35");
		}
		
		run("Save As Tiff", "save="+tmp_dir+t+"_"+tmp+"p.tif");
	}
}
*/