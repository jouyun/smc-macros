
channel_to_stitch_to=2;
other_channel=1;
stitch_channel_blend="[Linear Blending]";
//stitch_channel_blend="[Max. Intensity]";
other_channel_blend="[Linear Blending]";
//other_channel_blend="[Max. Intensity]";
order="Right & Down                ";
//order="Left & Up";
pct_overlap=20;

SNR=10;
do_z_project=true;

x_dim=2;
y_dim=2;
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
<<<<<<< HEAD
setBatchMode(false);
=======
setBatchMode(true);
>>>>>>> 60e148cad74717762f0afee63ed33abdb2e451cd
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

          if (File.exists(current_file+".tif"))
          {
               open(current_file+".tif");
          }
          else
          {
               run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
               title=getTitle();  //OLD WAY
               Stack.getDimensions(width, height, channels, slices, frames)
               p_title=getTitle();
              
         		if (do_z_project)
         		{
         			run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
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
          run("Paste Channel To Front", "channel="+channel_to_stitch_to+" slice=1");
          
          p_title=getTitle();
          selectWindow(tt);
          close();
          selectWindow(p_title);         
          new_directory=file_path+"Worms"+File.separator;
          tmp_directory=file_path+"tmp"+File.separator;
          IJ.log(new_directory);
          File.makeDirectory(new_directory);
          File.makeDirectory(tmp_directory);

          runMacro("SaveMultipageImageSequence.ijm", tmp_directory);
          number_worms=frames/x_dim/y_dim;
          chan_title="Tiffs";
          for (j=1; j<=number_worms; j++)
          {
               /*for (k=0; k<y_dim; k++)
               {
                    if (k%2==0)
                    {
                         run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x="+x_dim+" grid_size_y="+1+" tile_overlap=20 first_file_index_i="+((j-1)*x_dim*y_dim+k*x_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
                    }
                    else
                    {
                         run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+x_dim+" grid_size_y="+1+" tile_overlap=20 first_file_index_i="+((j-1)*x_dim*y_dim+k*x_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
                    }
                    saveAs("Tiff", tmp_directory+"Stripe"+k+".tif");
                    close();
               }*/
               run("Grid/Collection stitching", "type=[Grid: snake by rows] order=["+order+"] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap="+pct_overlap+" first_file_index_i="+((j-1)*x_dim*y_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               //Entering crazy town, now suddenly left and up
               //run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i="+((j-1)*x_dim*y_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               //run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+1+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Stripe{i}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               
               run("Delete Slice");
               run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels)+" slices="+slices+" frames="+1+" display=Grayscale");
               rename("Worm"+j+".tif");
          }
          for (j=1; j<=number_worms; j++)
          {
               selectWindow("Worm"+j+".tif");
               Stack.setSlice(slices);
               //If acquired fast will have to delete an extra slice here
               //run("Delete Slice", "delete=slice");

               //Cropping code, can be disabled
               /*run("Duplicate...", "duplicate channels="+channel_to_stitch_to+" slices=1");
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
               selectWindow("Worm"+j+".tif");
               roiManager("Select", 0);
               run("Crop");*/
               //End cropping code
               
               //run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices=1 frames=1 display=Grayscale");
               saveAs("Tiff", new_directory+"Worm"+j+".tif");
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
run("Quit");
