
run("Gaussian Blur...", "sigma=12 stack");
run("Invert", "stack");
run("Subtract Background...", "rolling=1000 stack");
setThreshold(0.6433, 20.0000);
run("Convert to Mask", "method=Default background=Dark black");
run("Fill Holes", "stack");
run("Erode", "stack");
run("Analyze Particles...", "size=2000-Infinity show=Masks stack");
run("Invert LUT");