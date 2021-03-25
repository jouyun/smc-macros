channel_for_stitching=3;
//pixel_size=1.56;
pixel_size=0.78;
//pixel_size=0.39;
mask_channel=1;

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
setBatchMode(false);
list = getFileList(source_dir);
IJ.log(list[0]);

//Cleanup file names
for (m=0; m<list.length; m++)
{
	if (File.isDirectory(source_dir+list[m]))
	{
		IJ.log(source_dir+list[m]);
		sub_list=getFileList(source_dir+list[m]);
		for (n=0; n<sub_list.length; n++)
		{
 		    if (indexOf(sub_list[n],"Count")>0)
 		    {
 		    	cur_file=source_dir+list[m]+sub_list[n];
 		    	IJ.log(cur_file);
 		    	//IJ.log("NDExp_"+substring(sub_list[n],0,36)+substring(sub_list[n],lengthOf(sub_list[n])-11,lengthOf(sub_list[n])));
 		    	p_start=indexOf(sub_list[n], "Plate");
 		    	new_file=source_dir+list[m]+"NDExp_"+substring(sub_list[n],p_start,36+p_start)+substring(sub_list[n],lengthOf(sub_list[n])-11,lengthOf(sub_list[n]));
 		    	IJ.log(new_file);
 		    	File.rename(cur_file, new_file);
 		    	
 		    }
		}
	}
}
list = getFileList(source_dir);
IJ.log(list[0]);

for (m=0; m<list.length; m++)
{
	if (File.isDirectory(source_dir+list[m]))
	{
		IJ.log(source_dir+list[m]);
		sub_list=getFileList(source_dir+list[m]);
		for (n=0; n<sub_list.length; n++)
		{
 		    if (endsWith(sub_list[n],".csv"))
      		{
		      	//Find plate/well/object
				pE=indexOf(sub_list[n], "_");
				pString=substring(sub_list[n], lengthOf("Plate"), pE);
				plate=parseFloat(pString);
		
				wB=pE+lengthOf("Well")+1;
				wE=indexOf(sub_list[n], "_", wB);
				wString=substring(sub_list[n], wB, wE);
				well=parseFloat(wString);
		
				oB=wE+lengthOf("Object")+1;
				oE=indexOf(sub_list[n],  "_", oB);
				oString=substring(sub_list[n], oB, oE);
				object=parseFloat(oString);
		
				IJ.log("Plate: "+plate);
				IJ.log("Well: "+well);
				IJ.log("Object: "+object);
		
				//Put something in to check to see if already done, if so, skip it
				candidate_name=source_dir+list[m]+"Plate"+IJ.pad(plate,3)+"_Well"+well+"_Object"+object+".tif";
				projection_name=candidate_name+"_projection.tif";
				mask_name=candidate_name+"_mask.tif";
				IJ.log(candidate_name);
				if (!File.exists(candidate_name))
				{
					IJ.log("directory="+source_dir+list[m]+" plate="+plate+" well="+well+" object="+object+" channel="+channel_for_stitching+" override pixel="+pixel_size+" fusion=[Max. Intensity]");
					run("Stitch Robot nd2v3", "directory="+source_dir+list[m]+" plate="+plate+" well="+well+" object="+object+" channel="+channel_for_stitching+" override pixel="+pixel_size+" fusion=[Max. Intensity]");
					Stack.getDimensions(width, height, channels, slices, frames);
/*run("Scale...", "x=.5 y=.5 z=.5 width=1024 height=1022 depth=63 interpolation=Bilinear average create");
rename("Scaled");
run("Duplicate...", "duplicate slices=1-40");		
rename("Duped");
selectWindow("Img");
close();
selectWindow("Scaled");
close();
selectWindow("Duped");
rename("Img");		*/	
					if (frames>1 && frames<30)
					{
						run("Flip Horizontally", "stack");
						run("Flip Vertically", "stack");
						selectWindow("Img");
						run("Duplicate...", "title=ASDF duplicate channels="+channel_for_stitching);
						selectWindow("ASDF");
						run("Z Project...", "projection=[Max Intensity] all");
						selectWindow("MAX_ASDF");
						run("Save Multipage Image Sequence", "path="+source_dir+list[m]);
						run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+source_dir+list[m]+" layout_file=out.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
						//return("");
						selectWindow("Img");
						Stack.getDimensions(width, height, channels, slices, frames);
						run("Hyperstack to Stack");
						run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels*slices)+" slices=1 frames="+frames+" display=Grayscale");
						run("Save Multipage Image Sequence", "path="+source_dir+list[m]);
						run("Close All");
						run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory="+source_dir+list[m]+" layout_file=out.registered.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
						run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels)+" slices="+slices+" frames="+1+" display=Grayscale");
					}
					
					run("Save As Tiff", "save=["+candidate_name+"]");
					run("Z Project...", "projection=[Max Intensity]");
					saveAs("Tiff", projection_name);
					run("Close All");
				}
				if (!File.exists(projection_name))
				{
					open(candidate_name);
					run("Z Project...", "projection=[Max Intensity]");
					saveAs("Tiff", projection_name);
					run("Close All");
				}
	  		}
      }
      for (i=0; i<100; i++)
	  {
			tmp=source_dir+list[m]+"Img"+IJ.pad(i,4)+".tif";
			if (File.exists(tmp)) File.delete(tmp);
	  }
	}
}
//run("Quit");					