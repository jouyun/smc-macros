//setBatchMode(true);
title=getTitle();
open("C:\\Users\\smc\\Desktop\\Fork Finder Mask.tif");
rename("Accumulated");

for (i=1; i<18; i++)
{
	open("C:\\Users\\smc\\Desktop\\Fork Finder Mask.tif");
	run("Rotate... ", "angle="+(i*10)+" grid=0 interpolation=Bicubic");
	rename("Result");

	run("Concatenate...", "  title=[Concatenated Stacks] image1=Accumulated image2=Result image3=[-- None --]");
	rename("Accumulated");	
}


