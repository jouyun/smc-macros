orig=getTitle();
run("Duplicate...", "title=A duplicate");
t=getTitle();
run("Duplicate...", "duplicate channels=2");
tt=getTitle();
run("Grays");
run("Gaussian Blur...", "sigma=3 stack");
//setThreshold(400, 65535);
setThreshold(700, 65535);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=750 max_size=-1");
setThreshold(0.5, 65535);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("16-bit");
run("Divide...", "value=255.000 stack");
setMinAndMax(0, 1);
rename("ClusterMask");

selectWindow(orig);
run("Duplicate...", "title=DAPI duplicate channels=3");
run("Grays");
run("32-bit");
run("Log3D", "sigmax=4.0 sigmay=4.0 sigmaz=1.0");
run("3D Fast Filters","filter=MaximumLocal radius_x_pix=3.0 radius_y_pix=3.0 radius_z_pix=2.0 Nb_cpus=16");
setMinAndMax(0, 65000);
run("8-bit");
setThreshold(40, 255);
run("Convert to Mask", "method=Default background=Dark black");

selectWindow("3D_MaximumLocal");
run("16-bit");
imageCalculator("Multiply create stack", "ClusterMask","3D_MaximumLocal");
selectWindow(t);
run("Split Channels");
run("Merge Channels...", "c1=C1-A c2=C2-A c3=C3-A c4=ClusterMask c5=3D_MaximumLocal create keep");


selectWindow("Result of ClusterMask");
run("32-bit");
run("Z Project...", "projection=[Sum Slices]");
run("Divide...", "value=255");
run("Enhance Contrast", "saturated=0.35");
setMinAndMax(0, 1);
run("Select All");
run("Measure");
setResult("File", nResults-1, orig);

selectWindow("ClusterMask");
run("Z Project...", "projection=[Sum Slices]");
run("Select All");
run("Measure");
volume=getResult("RawIntDen", nResults-1);
setResult("Volume", nResults-2, volume);
IJ.deleteRows(nResults-1, nResults-1);
