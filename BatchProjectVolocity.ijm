name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	
		idx=lengthOf(list[m])-1;
		list[m]=substring(list[m],0,idx);
		file_path=source_dir+list[m]+"\\";
		current_file=file_path+list[m]+".mvd2";
		IJ.log(current_file);	

		if (File.exists(current_file+".tif"))
		{
		}
		else
		{
			run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
			/*title=getTitle();  //OLD WAY
			Stack.getDimensions(width, height, channels, slices, frames)
			run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity] all");
			p_title=getTitle();
			selectWindow(title);
			close();*/

			//New way
			v=newArray(10,1000);
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
			p_title=getTitle();
			//END NEW WAY
			
		
			selectWindow(p_title);
			saveAs("Tiff", current_file+".tif");

		}
}