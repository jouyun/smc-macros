//setTool("dropper");
lines_to_reconstruct=3;
angles=1800;
angle_spacing=0.2;
rename("A");
for (j=0; j<lines_to_reconstruct; j++)
{
	selectWindow("A");
	//Stack.setSlice(j+1);
	run("Back Project");
	selectWindow("Img");
	for (i=0; i<angles; i++)
	{
 	    	Stack.setSlice(i+1);
	     	run("Rotate... ", "angle="+(i*angle_spacing)+" grid=1 interpolation=Bilinear slice");
	}
	
	run("Z Project...", "start=1 stop="+angles+" projection=[Average Intensity]");
	rename("B");
	selectWindow("Img");
	close();
	selectWindow("B");
	//saveAs("Tiff", "D:\\smc\\OPT_Sequence\\A"+IJ.pad(j,3)+".tif");
	//close();
}
