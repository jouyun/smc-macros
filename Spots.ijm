// 5 2 2000

xy_blur=2.0;
z_blur=1;

thresh=10000.0;
rename("Original");
t=getTitle();
run("32-bit");
run("Gaussian Blur...", "sigma=1 stack");
run("Subtract Background...", "rolling=40");
run("Log3D", "sigmax="+xy_blur+" sigmay="+xy_blur+" sigmaz="+z_blur);
run("3D Fast Filters","filter=MaximumLocal radius_x_pix="+xy_blur+" radius_y_pix="+xy_blur+" radius_z_pix="+z_blur+" Nb_cpus=20");
selectWindow("3D_MaximumLocal");
setMinAndMax(183.31, 1603670.62);
run("Duplicate...", "title=LocalMax duplicate");
setAutoThreshold("Default dark");
setThreshold(thresh, 1000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
//run("Gaussian Blur 3D...", "x=8 y=8 z=1");
run("Enhance Contrast", "saturated=0.35");

run("Merge Channels...", "c2=LocalMax c3=3D_MaximumLocal c6="+t+" create");
Stack.setChannel(1);
run("Green");
Stack.setChannel(3);
run("Magenta");
