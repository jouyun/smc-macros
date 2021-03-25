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
start_plate=10;
stop_plate=50;
done_one=false;

for (p=start_plate; p<stop_plate; p++)
{
	folder_template="plate "+p;
	for (n=0; n<source_list.length; n++)
	{
		plate_dir=source_dir+source_list[n];
		if (indexOf(plate_dir, folder_template)>1)
		{
			plate_dir_list=getFileList(plate_dir);
			if (lengthOf(plate_dir_list)<2)
			{
				sub_plate_dir=plate_dir+plate_dir_list[0];
				tiff_dir=plate_dir+"Tiffs"+File.separator;
				File.makeDirectory(tiff_dir);
				sub_plate_list=getFileList(sub_plate_dir);
				for (m=0; m<lengthOf(sub_plate_list); m++)
				{
					fname=sub_plate_dir+sub_plate_list[m];
					run("Bio-Formats Importer", "open=["+fname+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
					saveAs("Tiff", tiff_dir+File.getName(fname)+".tif");
					close();
				}
			}
			setBatchMode(false);
			//Folders and Tiffs created
	
			IJ.log(plate_dir);
			run("Image Sequence...", "open=[/home/smc/fast/Data/Plates/011017 nikon plate 47/Tiffs/] sort");
			s=nSlices/2/384;
			run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices="+s+" frames=384 display=Composite");
			run("Z Project...", "projection=[Average Intensity] all");
			run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=4 frames=96 display=Composite");
			rename("Base");
			selectWindow("Tiffs");
			close();
			selectWindow("Base");
			
	
			//Get the control
			for ( j=0; j<6; j++)
			{
				selectWindow("Base");
				run("Duplicate...", "duplicate frames="+(j*12+1));
				rename("B");
				if (j>0) run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
				else rename("A");
			}
			for ( j=0; j<6; j++)
			{
				selectWindow("Base");
				run("Duplicate...", "duplicate frames="+(j*12+7));
				rename("B");
				run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
			}
			rename("Control");
			
			//Get the mutant
			which_mutant=1;
			
			for (j=0; j<6; j++)
			{
				selectWindow("Base");
				run("Duplicate...", "duplicate frames="+(j*12+1+which_mutant));
				rename("B");
				if (j>0) run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
				else rename("A");
			}
			for (j=0; j<6; j++)
			{
				selectWindow("Base");
				run("Duplicate...", "duplicate frames="+(j*12+7+which_mutant));
				rename("B");
				run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
			}
			rename("Mutant");
	
			//Merge
			run("Combine...", "stack1=Control stack2=Mutant");
			rename("ListB");
			run("Green");
			run("Enhance Contrast", "saturated=0.35");
			Stack.setChannel(2);
			run("Red");
			run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=4 frames=12 display=Composite");
			selectWindow("Base");
			close();
			selectWindow("ListB");
			for (i=0; i<12; i++)
			{
				Stack.setFrame(i+1);
				label="Plate_"+IJ.pad(p,3)+" Sample_"+IJ.pad(i+1,2);
				IJ.log(label);
				setMetadata("Label", label);
			}
			rename("ListB");
			//return("");
			if (done_one) run("Concatenate...", "  title=ListA image1=ListA image2=ListB image3=[-- None --]");
			else rename("ListA");
			done_one=true;
			//return("");

		}

		
	}
}