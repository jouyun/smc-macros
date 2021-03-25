current_file=getArgument;

if (current_file=="")
{
	current_file = File.openDialog("Source Worm");
}
else
{
	//current_file=name;
}
open(current_file);
t=getTitle();
run("Make Composite");
Stack.setDisplayMode("grayscale");
run("Duplicate...", "title=A channels=1-3");

run("Grays");
run("32-bit");
run("Invert");
run("Subtract Background...", "rolling=50");
run("Percentile Threshold", "percentile=10 snr=20");
run("Fill Holes");
old_res=nResults;
run("Analyze Particles...", "size=2000-30000 show=Masks display exclude");
run("Invert LUT");
new_res=nResults;
if (old_res==new_res-1)
{
setResult("Label", nResults-1, t);
}
else
{
	IJ.log(t+" had error:  " +(new_res-old_res)+" candidates");
	for (i=0; i<new_res-old_res; i++)
	{
		setResult("Label", nResults-i-1, t+"_"+i);
	}
}
saveAs("Tiff", current_file+"_mask.tif");
run("Close All");
			