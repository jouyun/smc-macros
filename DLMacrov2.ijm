name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
training_file=source_dir+"Training.tif";
validation_file=source_dir+"Validation.tif";
annotated_file=substring(training_file, 0, lengthOf(training_file)-4)+"_annotated.tif";
validation_annotated_file=substring(validation_file, 0, lengthOf(validation_file)-4)+"_annotated.tif";
rot_shift_file=substring(training_file,0,lengthOf(training_file)-4)+"_RotShift.tif";
config_file=source_dir+"Network.txt";

base_scaler=32;
baseline_noise=0.53;
window_size=512;

f=File.open(config_file);
print(f, ""+base_scaler+"\n"+baseline_noise+"\n");
File.close(f);
//********************MAKE TRAINING ANNOTATED FILE**************************************
if (!File.exists(annotated_file))
{
	roiManager("reset");
	open(training_file);
	run("Select All");
	open(source_dir+"Training.zip");
	
	t=getTitle();
	run("32-bit");
	run("Duplicate...", "title=B duplicate channels=1");
	run("Select All");
	setBackgroundColor(0, 0, 0);
	run("Clear", "stack");
	run("Duplicate...", "title=C duplicate channels=1");
	
	selectWindow(t);
	run("add channel", "target=B");
	selectWindow("Img");
	run("Make Composite", "display=Composite");
	run("add channel", "target=B");
	run("Make Composite", "display=Composite");
	rename("tmp");
	tmp=getTitle();
	selectWindow(t);
	close();
	selectWindow("tmp");
	rename(t);
	
	count=roiManager("Count");
	
	setForegroundColor(255, 255, 255);
	Stack.getDimensions(width, height, channels, slices, frames);
	for (i=0; i<count; i++)
	{
		setForegroundColor(255, 255, 255);
	    roiManager("Select", i);
	    Stack.setChannel(channels-1);
	    run("Draw", "slice");
	    Stack.setChannel(channels);
	    run("Fill", "slice");
	    setForegroundColor(0,0,0);
	    run("Draw", "slice");
	}
	setForegroundColor(255, 255, 255);

	Stack.getDimensions(width, height, channels, slices, frames);
	x=(floor((width-1)/window_size)+1)*window_size;
	y=(floor((height-1)/window_size)+1)*window_size;
	run("Canvas Size...", "width="+x+" height="+y+" position=Center zero");
	run("32-bit");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+(slices*frames)+" frames=1 display=Color");
	
	//saveAs("Tiff", annotated_file);
	run("Save As Tiff", "save=["+annotated_file+"]");
	run("Close All");
}
//********************MAKE VALIDATION ANNOTATED FILE**************************************
if (!File.exists(validation_annotated_file))
{
	roiManager("reset");
	open(validation_file);
	run("Select All");
	open(source_dir+"Validation.zip");
	
	t=getTitle();
	run("32-bit");
	run("Duplicate...", "title=B duplicate channels=1");
	run("Select All");
	setBackgroundColor(0, 0, 0);
	run("Clear", "stack");
	run("Duplicate...", "title=C duplicate channels=1");
	
	selectWindow(t);
	run("add channel", "target=B");
	selectWindow("Img");
	run("Make Composite", "display=Composite");
	run("add channel", "target=B");
	run("Make Composite", "display=Composite");
	rename("tmp");
	tmp=getTitle();
	selectWindow(t);
	close();
	selectWindow("tmp");
	rename(t);
	
	count=roiManager("Count");
	
	setForegroundColor(255, 255, 255);
	Stack.getDimensions(width, height, channels, slices, frames);
	for (i=0; i<count; i++)
	{
		setForegroundColor(255, 255, 255);
	    roiManager("Select", i);
	    Stack.setChannel(channels-1);
	    run("Draw", "slice");
	    Stack.setChannel(channels);
	    run("Fill", "slice");
	    setForegroundColor(0,0,0);
	    run("Draw", "slice");
	}
	setForegroundColor(255, 255, 255);

	run("32-bit");
	Stack.getDimensions(width, height, channels, slices, frames);
	x=(floor((width-1)/window_size)+1)*window_size;
	y=(floor((height-1)/window_size)+1)*window_size;
	run("Canvas Size...", "width="+x+" height="+y+" position=Center zero");
	run("32-bit");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+(slices*frames)+" frames=1 display=Color");
	
	run("Make Windows", "window="+window_size+" z=1 staggered?");
	run("Make Composite", "display=Composite");
	
	//saveAs("Tiff", validation_annotated_file);
	run("Save As Tiff", "save=["+validation_annotated_file+"]");
	run("Close All");
}
//********************DO ROTATIONS AND TRANSLATIONS FOR TRAINING**************************************
if (!File.exists(rot_shift_file))
{
	open(annotated_file);
	ttt=getTitle();

	run("32-bit");
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+(slices*frames)+" frames=1 display=Color");
	
	minimum_ratio=minOf(width/window_size, height/window_size);
	if (minimum_ratio>3.5)
	{
		run("Make Windows", "window="+(2*window_size)+" z=1 staggered?");
		run("Make Composite", "display=Composite");
		tt=getTitle();
		selectWindow(ttt);
		close();
		selectWindow(tt);
	}
	else
	{
		tt=ttt;
	}
	
	Stack.getDimensions(width, height, channels, slices, frames);
	mem_size=width*height*channels*slices*frames*4/1024/1024/1024/minimum_ratio/minimum_ratio;
	
	number_turns=floor(8/mem_size);
	number_turns=minOf(100, number_turns);
	
	run("Select All");
	setBatchMode(false);
	//for (i=0; i<1000; i++)
	Stack.getDimensions(w,h,c,s,f);
	shifters=window_size/4;
	if (minimum_ratio>1.5)
	{
		shifters=4*shifters;
	}
	IJ.log(""+shifters);
	for (i=0; i<number_turns; i++)
	{
		selectWindow(tt);
		run("Duplicate...", "title=New duplicate");
		angle=floor(random*360)-180;
		x_shift=floor(random*shifters-shifters/2);
		y_shift=floor(random*shifters-shifters/2);
		run("Rotate... ", "angle="+angle+" grid=1 interpolation=Bilinear stack");
		run("Translate...", "x="+x_shift+" y="+y_shift+" interpolation=Bilinear stack");
	}
	
	run("Concatenate...", "all_open title=[Concatenated Stacks]");
	
	run("Canvas Size...", "width="+window_size+" height="+window_size+" position=Center");
	run("Save As Tiff", "save=["+rot_shift_file+"]");
}
//run("open URL", "url="+"http://volta:8080/train?path="+source_dir);

