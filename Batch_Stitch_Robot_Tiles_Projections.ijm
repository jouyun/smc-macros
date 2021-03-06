channel_for_stitching=2;
pixel_size=0.8;
mask_channel=2;

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
for (m=0; m<list.length; m++)
{
	if (File.isDirectory(source_dir+list[m]))
	{
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
					//run("Stitch Robot nd2", "directory="+source_dir+list[m]+" plate="+plate+" well="+well+" object="+object+" channel=4");
					run("Stitch Robot nd2 Projections", "directory="+source_dir+list[m]+" plate="+plate+" well="+well+" object="+object+" override pixel="+pixel_size);
					wait(10000);
					tt=getTitle();
					IJ.log(tt);
					run("Save As Tiff", "save=["+candidate_name+"]");
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
run("Quit");