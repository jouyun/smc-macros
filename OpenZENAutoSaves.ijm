source_dir = getDirectory("Source Directory");
//setBatchMode(true);
list = getFileList(source_dir);
IJ.log(list[0]);
open(source_dir+"\\"+list[0]);
Stack.getDimensions(width, height, channels, slices, frames);
title=getTitle();
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
tt=getTitle();
selectWindow(title);
close();
selectWindow(tt);
rename(title);
for (j=1;j<list.length; j++)
{
		open(source_dir+"\\"+list[j]);
		Stack.getDimensions(width, height, channels, slices, frames);
		tmp_title=getTitle();
		run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
		tt=getTitle();
		selectWindow(tmp_title);
		close();
		selectWindow(tt);
		rename(tmp_title);
		run("Concatenate...", "  title="+title+" image1="+title+" image2="+tmp_title+" image3=[-- None --]");
}

