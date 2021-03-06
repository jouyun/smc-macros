
channel_to_stitch_to=2;
slice_to_stitch_to=1;

channel_to_mask_on=2;
slice_to_mask_on=1;


/*channel_to_stitch_to=1;
slice_to_stitch_to=1;

channel_to_mask_on=1;
slice_to_mask_on=1;*/




other_channel=1;
//stitch_channel_blend="[Linear Blending]";
stitch_channel_blend="[Max. Intensity]";
//other_channel_blend="[Linear Blending]";
other_channel_blend="[Max. Intensity]";
pct_overlap=20;

SNR=8;
do_z_project=true;

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
//setBatchMode(false);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++)
{
          setBatchMode(false);
          idx=lengthOf(list[m])-1;
          list[m]=substring(list[m],0,idx);
          file_path=source_dir+list[m]+File.separator;
          current_file=file_path+list[m]+".mvd2";
          IJ.log(current_file);    

          if (File.exists(current_file+".tif"))
          {
               open(current_file+".tif");
               infos=getMetadata("Info");
          }
          else
          {
               run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
               title=getTitle();  //OLD WAY
               Stack.getDimensions(width, height, channels, slices, frames);
               p_title=getTitle();
               infos=getMetadata("Info");

	       		if (do_z_project)
         		{
         			run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
         			setMetadata("Info", infos);
         			z_title=getTitle();
         			selectWindow(p_title);
         			close();
         			p_title=z_title;
         		}
         		
               selectWindow(p_title);
               saveAs("Tiff", current_file+".tif");
		}

          Stack.getDimensions(width, height, channels, slices, frames);
          tt=getTitle();

          //20 is good for coloc

          run("Paste Channel To Front", "channel="+channel_to_stitch_to+" slice="+slice_to_stitch_to);
          setMetadata("Info", infos);
          
          p_title=getTitle();
          selectWindow(tt);
          close();
          selectWindow(p_title);         
          new_directory=file_path+"Worms"+File.separator;
          tmp_directory=file_path+"tmp"+File.separator;
          IJ.log(new_directory);
          File.makeDirectory(new_directory);
          File.makeDirectory(tmp_directory);

			run("Stitch PE Data", "path="+file_path);
			number_worms=parseFloat(call("splugins.Stitch_PE_Data.getResult"));
          for (j=1; j<=number_worms; j++)
          {
				selectWindow("Worm"+j);		
Stack.getDimensions(wi, he, ch, sl, fr);						
IJ.log(getTitle()+","+wi+","+he+","+ch+","+sl+","+fr);
IJ.log("deleting");
               run("Delete Slice");
IJ.log("made it through");               
               IJ.log("Channels,slices: "+channels+","+slices);
               run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels)+" slices="+slices+" frames="+1+" display=Grayscale");
          }
         
          for (j=1; j<=number_worms; j++)
          {
               selectWindow("Worm"+j);
               Stack.setSlice(slices);
               //If acquired fast will have to delete an extra slice here
               //run("Delete Slice", "delete=slice");

               //Cropping code, can be disabled
               run("Duplicate...", "duplicate channels="+channel_to_mask_on+" slices="+slice_to_mask_on);
               ttt=getTitle();
               run("32-bit");
               run("Percentile Threshold", "percentile=10 snr="+SNR);
               run("Fill Holes");
               run("Open");
               run("Analyze Particles...", "size=100000-Infinity display clear add");
               selectWindow("Result");
               close();
               selectWindow(ttt);
               close();
               selectWindow("Worm"+j);

               if (roiManager("count")>0)
               {
               	roiManager("Select", 0);
               	run("Crop");
               	//End cropping code
               	saveAs("Tiff", new_directory+"Worm"+j+".tif");
               }
               
               //run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices=1 frames=1 display=Grayscale");
               
               close();
          }
          selectWindow(p_title);
          close();
          tmps_list = getFileList(tmp_directory);
          for (k=0; k<tmps_list.length; k++)
          {
               //wst=File.delete(tmp_directory+tmps_list[k]);
          }
}
run("Close All");
//run("Quit");
