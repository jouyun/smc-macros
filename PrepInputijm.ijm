name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
setBatchMode(false);

process_dir=source_dir+"Data"+File.separator;
model_dir=source_dir+"NewModels"+File.separator;
inference_dir=source_dir+"Data_input"+File.separator;
output_dir=source_dir+"Data_output"+File.separator;
final_dir=source_dir+"Final"+File.separator;

File.makeDirectory(inference_dir);
File.makeDirectory(output_dir);
File.makeDirectory(final_dir);

IJ.log(process_dir);

config_file=source_dir+"Network.txt";
f=File.openAsString(config_file);
lines=split(f, "\n");
x_dim=parseInt(lines[2]);
model_no=IJ.log(lines[5]);

/*process_list = getFileList(process_dir);
IJ.log(process_list[0]);
for (n=0; n<process_list.length; n++)
{
	cur_file=process_dir+process_list[n];
	IJ.log(cur_file);
	open(cur_file);
	Stack.getDimensions(width, height, channels, slices, frames);

	x=(floor((width-1)/x_dim)+1)*x_dim;
	y=(floor((height-1)/x_dim)+1)*x_dim;

	run("Canvas Size...", "width="+x+" height="+y+" position=Center zero");
	run("32-bit");	
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+(slices*frames)+" frames=1 display=Color");
	
	run("Make Windows", "window="+x_dim+" z=1 staggered?");
	//run("Make Composite", "display=Grayscale");
	infile_name=process_list[n];
	saveAs("Tiff", inference_dir+infile_name);
	run("Close All");

}

////*****************CALL WEBPAGE*********************************
run("open URL", "url="+"http://volta:8080/infer?path="+source_dir);


//*************************PROCESS RESULT***************************
wait(40000);*/

output_list = getFileList(output_dir);
for (n=0; n<output_list.length; n++)
{
	cur_file=process_dir+output_list[n];
	IJ.log(cur_file);
	open(cur_file);
	Stack.getDimensions(width, height, channels, slices, frames);
	x=(floor((width-1)/x_dim)+1)*x_dim;
	y=(floor((height-1)/x_dim)+1)*x_dim;
	close();

	cur_file=output_dir+output_list[n];
	IJ.log(cur_file);
	open(cur_file);
	//run("Bio-Formats Importer", "open="+cur_file+" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	Stack.getDimensions(widthb, heightb, channelsb, slicesb, framesb);
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channelsb+" slices="+(1)+" frames="+(slicesb*framesb)+" display=Composite");

	border=10;
	makeRectangle(border, border, x_dim-2*border, x_dim-2*border);
	run("Clear Outside", "stack");
	run("Make Image From Windows", "width="+x+" height="+y+" slices="+(slices*frames)+" staggered?");
	run("Make Composite", "display=Composite");
	Stack.setChannel(channelsb-1);
	setMinAndMax(0, 1.0);
	Stack.setChannel(channelsb);
	setMinAndMax(0, 1.0);

	Stack.getDimensions(widthb, heightb, channelsb, slicesb, framesb);
	makeRectangle(floor((widthb-width)/2), floor((heightb-height)/2), width,height);
	run("Crop");

	infile_name=output_list[n];
	saveAs("Tiff", final_dir+infile_name);
	run("Close All");

}
