
dirname=getDirectory("Select a source Directory");
dest_name=getDirectory("Select a dest Directory");
IJ.log("running on:  "+dirname);
file_list=getFileList(dirname);
for (i=0; i<lengthOf(file_list); i++)
{
	if (File.isDirectory(dirname+file_list[i])) 
	{
		'newdir=substring(file_list[i], 0, lengthOf(file_list[i])-1)+"\\";
		'IJ.log("directory:  " +dirname+newdir);
		'convert_directory(""+dirname+newdir);
	}
	else
	{
		open(dirname+file_list[i]);
		//run("Hyperstack to Stack");
		//run("Deinterleave", "how=2");
		//selectWindow(file_list[i]+" #2");
		//rename("B");
		run("StackReg", "transformation=[Rigid Body]");
		//selectWindow(file_list[i]+" #1");
		//rename("A");
		//Stack.getDimensions(w, h, c, s, f);
		//IJ.log( "order=xyztc channels=2 slices=1 frames="+f+" display=Grayscale");
		//run("StackReg", "transformation=[Rigid Body]");
		//run("Concatenate", "  title=[Concatenated Stacks] image_1=[A] image_2=[B] image_3=[-- None --]");
		//run("Stack to Hyperstack...", "order=xyztc channels=2 slices=1 frames="+s+" display=Grayscale");
		saveAs("Tiff", dest_name+file_list[i]+".tif");
		close();
	}
}

