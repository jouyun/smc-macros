channels=2;
slices=50;
max_frames=30000;
frames=0;

name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");	
}
else
{
	source_dir=name;
}


setBatchMode(true);
list = getFileList(source_dir);
count=0;
for (m=0; m<list.length; m++)
{
if (endsWith(list[m], ".raw"))
{
	count++;
	good_one=list[m];
}
}


base_mask=substring(good_one, 0, lengthOf(good_one)-5);
current_mask=base_mask+"1.raw";
IJ.log("Number files:  "+count);
IJ.log("["+source_dir+current_mask+"]");
IJ.log(current_mask);
run("Raw...", "open=["+source_dir+current_mask+"] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number="+(max_frames*channels*slices)+" gap=0 little-endian");
Stack.getDimensions(w, h, ch, sl, fr);
if (slices%(channels*slices)!=0)
{
	last_good=floor(sl/(channels*slices));
	run("Slice Remover", "first="+(last_good*100+1)+" last="+sl+" increment=1");
}
rename(base_mask);
Stack.getDimensions(width, height, bchannels, bslices, tframes);
IJ.log(""+bchannels+" "+bslices+" "+tframes);
frames=frames+bslices/slices/channels;


for (m=1; m<count; m++) {
	sync_frame=frames+1;
	current_mask=base_mask+(m+1)+".raw";
	IJ.log(current_mask);
	run("Raw...", "open=["+source_dir+current_mask+"] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number="+(max_frames*channels*slices)+" gap=0 little-endian");
	Stack.getDimensions(w, h, ch, sl, fr);
	if (slices%(channels*slices)!=0)
	{
		last_good=floor(sl/(channels*slices));
		run("Slice Remover", "first="+(last_good*100+1)+" last="+sl+" increment=1");
	}
	
	tmp_title=getTitle();
	Stack.getDimensions(width, height, bchannels, bslices, tframes);
	frames=frames+bslices/slices/channels;

	run("Concatenate...", "  title="+base_mask+" image1="+base_mask+" image2="+tmp_title+" image3=[-- None --]");
}
IJ.log("Frames: "+frames);
run("Stack to Hyperstack...", "order=xyzct channels="+channels+" slices="+slices+" frames="+frames+" display=Composite");
Stack.setChannel(1);
run("Green");
Stack.setChannel(2);
run("Magenta");
Stack.setChannel(1);
run("Properties...", "channels="+channels+" slices="+slices+" frames="+frames+" unit=micron pixel_width=0.2 pixel_height=0.2 voxel_depth=1 frame=[60 sec] origin=0,0");
saveAs("Tiff", source_dir+base_mask+".tif");
mt=getTitle();
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
run("Reduce Dimensionality...", "  frames");
run("Enhance Contrast", "saturated=0.35");
selectWindow("MAX_out.tif");
saveAs("Tiff", source_dir+"\\MAX_out.tif");
close();
selectWindow(mt);
close();
