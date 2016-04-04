

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
		if (!File.isDirectory(file_path)) continue
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

          
          new_directory=file_path+"Worms"+File.separator;
          IJ.log(new_directory);
          File.makeDirectory(new_directory);
          //return("");
          for (j=1; j<=frames; j++)
          {
          	selectWindow(tt);
          		run("Duplicate...", "title=A duplicate frames="+j);	
               saveAs("Tiff", new_directory+"Worm"+IJ.pad(j,2)+".tif");
               close();
          }
          selectWindow(tt);
          close();
}
run("Close All");
run("Quit");
