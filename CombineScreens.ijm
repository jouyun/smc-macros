
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
source_list = getFileList(source_dir);

max_plates=10;
max_wells=4;
max_objects=20;

max_width=0;
max_height=0;

for (p=0; p<max_plates; p++)
{
	for (w=0; w<max_wells; w++)
	{
		already_got_one=false;
		for (ob=0; ob<max_objects; ob++)
		{
			file_name=source_dir+"Plate"+IJ.pad(p,3)+"_Well"+IJ.pad(w+1,1)+"_Object"+ob+".tif_projection.tif_large_aligned.tif";
			IJ.log(file_name);
			if (File.exists(file_name))
			{
				open(file_name);
				rename("B");
				if (already_got_one)
				{
					run("Combine...", "stack1=A stack2=B combine");
					rename("A");
				}
				else 
				{
					rename("A");
					already_got_one=true;
				}
			}
		}
		if (already_got_one)
		{
			Stack.getDimensions(width, height, channels, slices, frames);
			if (width>max_width) max_width=width;
			if (height>max_height) max_height=height;
			setMinAndMax(50, 1200);
			run("Save As Tiff", "save="+source_dir+"Plate"+IJ.pad(p,3)+"_Well"+IJ.pad(w+1,1)+"_combined.tif");
			run("Close All");
		}
	}
}


already_got_one=false;
for (p=0; p<max_plates; p++)
{
	for (w=0; w<max_wells; w++)
	{
		file_name=source_dir+"Plate"+IJ.pad(p,3)+"_Well"+IJ.pad(w+1,1)+"_combined.tif";
		if (File.exists(file_name))
		{
			open(file_name);
			run("Canvas Size...", "width="+max_width+" height="+max_height+" position=Top-Center zero");
			Stack.getDimensions(width, height, channels, slices, frames);
			for (c=0; c<channels; c++)
			{
				Stack.setChannel(c+1);
				setMetadata("Label", "Plate"+IJ.pad(p,3)+"_Well"+IJ.pad(w+1,1)+"_combined.tif");
			}
		}
	}
}

run("Concatenate...", "all_open open");
run("Save As Tiff", "save="+source_dir+"Summary.tif");
run("Close All");