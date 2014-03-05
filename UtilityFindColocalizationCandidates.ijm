print("\\Clear");
run("32-bit");
run("Subtract Background...", "rolling=50 stack");
selection_thresh=0.2;
Stack.setChannel(2);
run("find colocalization candidates 3D", "threshold=1000 minimum=80 selection="+selection_thresh);
run("Channels Tool...");
run("Make Composite", "display=Composite");
run("Green");
Stack.setChannel(2);
run("Magenta");
Stack.setSlice(2);
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");

/*
 * 
run("Duplicate...", "title=A channels=1-2 slices=1-3 frames=1-41");
run("Split Channels");
selectWindow("C1-A");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
selectWindow("C2-A");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("Calculate Spatial Correlation", "first=C1-A second=C2-A");
selectWindow("C1-A");
close();
selectWindow("C2-A");
close();
selectWindow("Recorder");

 */