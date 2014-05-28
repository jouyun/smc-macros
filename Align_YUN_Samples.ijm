name=getArgument;
setBatchMode(false);
if (name=="")
{
	//source_dir = getDirectory("Source Directory");	
	main_dir = getDirectory("Source Directory");	
	sync_frame=71;
	IJ.log(main_dir);
	open(main_dir+"MAX_out.tif");
	max_ID=getImageID();
	rename("MAX_out.tif");
	open(main_dir+"out.tif");
	rename("out.tif");
}
else
{
	tend=lastIndexOf(name, "/");
	main_dir=substring(name, 0, tend+1);
	IJ.log(main_dir);
	open(main_dir+"MAX_out.tif");
	max_ID=getImageID();
	rename("MAX_out.tif");
	open(main_dir+"out.tif");
	rename("out.tif");
	sync_frame=parseInt(substring(name, tend+1, lengthOf(name)));
	IJ.log(""+sync_frame);
}

selectWindow("MAX_out.tif");
max_ID=getImageID();
selectWindow("out.tif");
Stack.getDimensions(width, height, channels, slices, frames);
IJ.log("channels:  "+channels+" slices:  "+slices+" frames:  "+frames);
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels*slices)+" slices=1 frames="+frames+" display=Grayscale");
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
run("Hyperstack to Stack");
main_ID=getImageID();

selectImage(main_ID);
rename("A");
selectImage(max_ID);
rename("B");
run("Concatenate...", "  title=out_aligned.tif image1=A image2=B image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytzc channels="+(channels*slices+1)+" slices=1 frames="+frames+" display=Grayscale");

Stack.setChannel((channels*slices+1));
Stack.setFrame(sync_frame);
IJ.log(""+Stack.isHyperStack);
run("multichannel stackreg", "transformation=[Rigid Body] temp="+main_dir);
Stack.setChannel((channels*slices+1));

run("Hyperstack to Stack");
increment=channels*slices+1;
for (i=frames; i>0; i--)
{
	setSlice(i*increment);
	run("Delete Slice","");
}
run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels)+" slices="+slices+" frames="+frames+" display=Grayscale");
IJ.log(""+nSlices);
//run("Delete Slice", "delete=channel");
IJ.log(""+Stack.isHyperStack);
run("Hyperstack to Stack");
IJ.log(""+nSlices);
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+frames+" display=Composite");
run("Green");
Stack.setChannel(2);
run("Magenta");
saveAs("Tiff", main_dir+"out_aligned.tif");


