name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
IJ.log(source_dir);
setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
		setBatchMode(true);
		idx=lengthOf(list[m])-1;
		list[m]=substring(list[m],0,idx);
		file_path=source_dir+list[m]+File.separator;
		current_file=file_path+list[m]+".mvd2";
		IJ.log(current_file);	

		new_directory=file_path+"Worms"+File.separator;
		IJ.log(new_directory);
		File.makeDirectory(new_directory);
		
		run("Close All");
		setBatchMode(true);
		run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default open_all_series view=Hyperstack stack_order=XYCZT");
		ctr=0;
		last_idx=0;
		flags=newArray(nImages);
		C=nImages;
		for (i=0; i<C; i++)
		{
			selectImage(i+1);
			t=getTitle();
			if (indexOf(t, "tile")>0) 
			{
				flags[i]=false;
			}
			else
			{
				flags[i]=true;
			}
			rename("A"+i);
		}
		last_idx=-1;
		last_flag=false;
		ctr=0;
		for (i=0; i<C; i++)
		{
			if (flags[i]&&(last_flag==false))
			{
				last_idx=i;
				last_flag=true;
			}
			else
			{
				if (flags[i]&&last_flag)
				{
					last_flag=false;
					IJ.log("First: "+last_idx+" Second: "+i);
					run("Concatenate...", "  title=B image1=A"+last_idx+" image2=A"+i+" image3=[-- None --]");
					run("Max Project With Reference At Front", "channels=2 frames=1");
					saveAs("Tiff", new_directory+"Worm"+(ctr+1)+".tif");
					ctr++;
				}
					
			}
		}
		run("Close All");
}
run("Close All");
run("Quit");