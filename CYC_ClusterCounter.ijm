t=getTitle();
Stack.getDimensions(w,h,c,s,f);
run("Properties...", "channels="+c+" slices="+s+" frames=1 unit=um pixel_width=0.1612500 pixel_height=0.1612500 voxel_depth=1.0000000");

run("Duplicate...", "title=EDM duplicate channels=1");
setThreshold(1, 1E100);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Distance Map", "map=EDT image=EDM mask=EDM threshold=1");
selectWindow(t);
run("add channel", "target=EDT");
selectWindow(t);
close();
selectWindow("Img");
rename(t);




run("Duplicate...", "duplicate channels=4");
//run("Log3D", "sigmax=3.0 sigmay=3.0 sigmaz=1.0");
//run("3D Fast Filters","filter=MaximumLocal radius_x_pix=4.0 radius_y_pix=4.0 radius_z_pix=2.0 Nb_cpus=16");
run("Log3D", "sigmax=3.0 sigmay=3.0 sigmaz=1.0");
run("3D Fast Filters","filter=MaximumLocal radius_x_pix=8.0 radius_y_pix=8.0 radius_z_pix=2.0 Nb_cpus=16");

setThreshold(1, 1E100);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
run("Divide...", "value=255 stack");

selectWindow("3D_MaximumLocal");
selectWindow(t);
run("add channel", "target=3D_MaximumLocal");
run("Make Composite", "display=Composite");
for (i=1; i<6; i++)
{
	Stack.setChannel(i);
	run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(1);
run("Magenta");
Stack.setChannel(5);
run("Grays");
Stack.setChannel(2);
run("Green");

Stack.setActiveChannels("11101");
selectWindow(t);
close();
selectWindow("Img");
rename(t);

run("Duplicate...", "title=A duplicate channels=1");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=6");
imageCalculator("Multiply create stack", "A","B");
rename("MaskedPoints");
selectWindow(t);
run("add channel", "target=MaskedPoints");
selectWindow(t);
close();
selectWindow("Img");
rename(t);
run("Compute 3D Point statistics", "mask=1 point=7");

//run("Close All");

