setBatchMode(true);
title=getTitle();
open("C:\\Users\\smc\\Desktop\\Fork Finder Mask.tif");
run("Rotate... ", "angle="+(0*10)+" grid=0 interpolation=Bicubic");
run("FD Math...", "image1=["+title+"] operation=Correlate image2=[Fork Finder Mask.tif] result=Result do");
rename("Accumulated");
selectWindow("Fork Finder Mask.tif");
close();

for (i=1; i<18; i++)
{
	open("C:\\Users\\smc\\Desktop\\Fork Finder Mask.tif");
	run("Rotate... ", "angle="+(i*10)+" grid=0 interpolation=Bicubic");
	run("FD Math...", "image1=["+title+"] operation=Correlate image2=[Fork Finder Mask.tif] result=Result do");

	run("Concatenate...", "  title=[Concatenated Stacks] image1=Accumulated image2=Result image3=[-- None --]");
	rename("Accumulated");	
	selectWindow("Fork Finder Mask.tif");
	close();
}

Stack.getDimensions(width, height, channels, slices, frames);

for (j=1; j<20; j++)
{
	selectWindow(title);
	Stack.setSlice(j+1);
	for (i=0; i<18; i++)
	{
		open("C:\\Users\\smc\\Desktop\\Fork Finder Mask.tif");
		run("Rotate... ", "angle="+(i*10)+" grid=0 interpolation=Bicubic");
		run("FD Math...", "image1=["+title+"] operation=Correlate image2=[Fork Finder Mask.tif] result=Result do");
	
		run("Concatenate...", "  title=[Concatenated Stacks] image1=Accumulated image2=Result image3=[-- None --]");
		rename("Accumulated");	
		selectWindow("Fork Finder Mask.tif");
		close();
	}
}
selectWindow("Accumulated");
saveAs("Tiff", "C:\\Users\\smc\\Desktop\\Accumulated.tif");