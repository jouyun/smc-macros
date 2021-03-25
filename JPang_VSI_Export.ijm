name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(true);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n]))
	{
		
		worm_dir=source_dir+source_list[n];
		IJ.log(worm_dir);
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			IJ.log(worm_dir+list[m]);
			if ((endsWith(list[m],".vsi")==1)&&(endsWith(list[m],"Overview.vsi")==0))
			{
				IJ.log("open="+worm_dir+list[m]+" color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
				run("Bio-Formats Importer", "open="+worm_dir+list[m]+" color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
				
				run("Trim In Z Automatically", "fraction=0.5");
				Stack.getDimensions(w,h,c,s,f);
				if (s>1)
				{
					run("Z Project...", "projection=[Max Intensity]");
				}
				Stack.setChannel(3);
				run("Delete Slice", "delete=channel");
				Stack.setChannel(1);
				setMinAndMax(0, 65535);
				run("Blue");
				Stack.setChannel(2);
				setMinAndMax(235.96, 7788.43);
				run("Red");
				Stack.setChannel(3);
				setMinAndMax(16.00, 3475.75);
				run("Green");
				run("Save As Tiff", "save="+source_dir+substring(source_list[n], 0, lengthOf(source_list[n])-1)+".tif");
				Stack.setDisplayMode("composite");
				t=getTitle();
				run("Stack to RGB");
				run("Save As Tiff", "save="+source_dir+substring(source_list[n], 0, lengthOf(source_list[n])-1)+"_RGB.tif");

				selectWindow(t);
				Stack.setActiveChannels("101");
				run("Stack to RGB");
				run("Save As Tiff", "save="+source_dir+substring(source_list[n], 0, lengthOf(source_list[n])-1)+"_GB.tif");

				selectWindow(t);
				Stack.setActiveChannels("110");
				run("Stack to RGB");
				run("Save As Tiff", "save="+source_dir+substring(source_list[n], 0, lengthOf(source_list[n])-1)+"_RB.tif");

				run("Close All");		
				
			}
		}
	}
}
run("Close All");

