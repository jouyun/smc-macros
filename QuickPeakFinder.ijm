lateral=4.0;
axial=2;
threshold=4000;

roiManager("reset");
t=getTitle();
run("32-bit");
run("Log3D", "sigmax="+lateral+" sigmay="+lateral+" sigmaz="+axial);
run("3D Fast Filters","filter=MaximumLocal radius_x_pix=2.0 radius_y_pix=2.0 radius_z_pix=2.0 Nb_cpus=16");
selectWindow("3D_MaximumLocal");
rename("Unthresh");
run("Duplicate...", "title=Thresh duplicate");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(threshold, 10000000000000000000000000000000000.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
run("Merge Channels...", "c1="+t+" c2=Unthresh c3=Thresh create");
run("In [+]");
run("In [+]");
run("In [+]");
run("Magenta");
Stack.setChannel(2);
run("Green");
roiManager("Show All");
roiManager("Show None");

