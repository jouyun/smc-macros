run("Duplicate...", "title=Base duplicate");
run("32-bit");
s=18;
sz=s/2;
run("LoG 3D", "sigmax="+s+" sigmay="+s+" sigmaz="+sz+" displaykernel=0 volume=1");
while (isOpen("LoG of Base")==false)
{
	wait(1000);
}
selectWindow("LoG of Base");
run("Invert", "stack");
run("3D Fast Filters","filter=MaximumLocal radius_x_pix=8.0 radius_y_pix=8.0 radius_z_pix=4.0 Nb_cpus=32");
selectWindow("3D_MaximumLocal");
run("Merge Channels...", "c2=3D_MaximumLocal c6=Base create");
selectWindow("Composite");
setMinAndMax(1, 1);
//selectWindow("LoG of Base");
//close();
selectWindow("Composite");
run("In [+]");
run("In [+]");
Stack.setSlice(16);
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.35");
