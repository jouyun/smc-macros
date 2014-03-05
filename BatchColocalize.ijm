
dirname=getDirectory("Select a source Directory");
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
		run("Split Channels");
		selectWindow("C2-"+file_list[i]);
		rename("B");
		selectWindow("C1-"+file_list[i]);
		rename("A");

		run("Colocalization Threshold", "channel_1=A channel_2=B use=None channel=[Red : Green] show show include");
		selectWindow("A");
		close();
		selectWindow("B");
		close();

	}
}

