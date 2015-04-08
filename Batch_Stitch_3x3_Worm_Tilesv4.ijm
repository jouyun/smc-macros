
channel_to_stitch_to=3;
other_channel=1;
stitch_channel_blend="[Linear Blending]";
//stitch_channel_blend="[Max. Intensity]";
other_channel_blend="[Linear Blending]";
//other_channel_blend="[Max. Intensity]";

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
//setBatchMode(false);
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
               //New way
               /*v=newArray(10,1000);
               number_imgs=0;
               main_idx=0;
               number_images=nImages;
               for (i=1; i<=number_images; i++) {
                       selectImage(i);
                       v[i-1]=getTitle();
                       number_imgs++;
                       if (Stack.isHyperStack)
                       {
                            main_idx=i-1;
                            print(v[i-1]);
                       }
               }
               selectWindow(v[main_idx]);
               Stack.getDimensions(width, height, channels, slices, frames);

               selectWindow(v[main_idx]);
               run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
               rename("LR");
               selectWindow(v[main_idx]);
               close();
               selectWindow("LR");
               number_added=0;
               if (number_imgs>1)
               {
                    for (i=0; i<number_imgs; i++)
                    {
                         if (i!=main_idx)
                         {
                              selectWindow(v[i]);
                              print(v[i]);
                              mtitle=getTitle();
                              gtitle=getTitle();
                              gstart=indexOf(gtitle, "point")+6;
                              gend=indexOf(substring(gtitle,gstart)," ")+gstart;
                              point=parseInt(substring(gtitle, gstart, gend));
                              gstart=indexOf(gtitle, "tile")+5;
                              gend=indexOf(substring(gtitle,gstart),")")+gstart;
                              tilenum=parseInt(substring(gtitle, gstart, gend));
                              run("Duplicate...", "title=BB");
                              selectWindow(mtitle);
                              run("Delete Slice");
                              run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
                              rename("AA");
                              selectWindow(mtitle);
                              close();
                              run("Concatenate...", "  title=[M] open image1=AA image2=BB image3=[-- None --]");
                              Stack.setDimensions(2,1,1);
                              insert_idx=(point-1)*x_dim*y_dim+tilenum-1+number_added;
                              selectWindow("LR");
                              run("Duplicate...", "title=[L] duplicate channels=1-2 frames=1-"+insert_idx);
                              selectWindow("LR");
                              run("Duplicate...", "title=[R] duplicate channels=1-2 frames="+(insert_idx+1)+"-"+(frames+number_added));
                              selectWindow("LR");
                              close();
                              run("Concatenate...", "  title=LR open image1=L image2=M image3=R image4=[-- None --]");
                              number_added++;
                         }
                    }
               }
               p_title=getTitle();*/
               //END NEW WAY
              
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
               run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i="+((j-1)*x_dim*y_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               //Entering crazy town, now suddenly left and up
               //run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Left & Up] grid_size_x="+x_dim+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i="+((j-1)*x_dim*y_dim)+" directory=["+tmp_directory+"] file_names="+chan_title+"{iiii}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               //run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+1+" grid_size_y="+y_dim+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Stripe{i}.tif output_textfile_name=TileConfiguration_"+j+".txt fusion_method="+stitch_channel_blend+" regression_threshold=0.3 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
               if (getHeight<1500)
               {
                    close();
                    middle_index=floor(y_dim/2);
                    open(tmp_directory+"Stripe"+middle_index+".tif");
                    IJ.log("bungled one");
               }
               run("Delete Slice");
               run("Stack to Hyperstack...", "order=xyczt(default) channels="+(channels)+" slices="+slices+" frames="+1+" display=Grayscale");
               rename("Worm"+j+".tif");
          }
         
          for (j=1; j<=number_worms; j++)
          {
               selectWindow("Worm"+j+".tif");
               Stack.setSlice(slices);
               //run("Delete Slice", "delete=slice");
               run("Duplicate...", "duplicate channels="+channel_to_stitch_to+" slices=1");
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
               run("Crop");
               //run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices=1 frames=1 display=Grayscale");
               saveAs("Tiff", new_directory+"Worm"+j+".tif");
               close();
          }
          selectWindow(p_title);
          close();
          tmps_list = getFileList(tmp_directory);
          for (k=0; k<tmps_list.length; k++)
          {
               wst=File.delete(tmp_directory+tmps_list[k]);
          }
}
run("Close All");
run("Quit");
