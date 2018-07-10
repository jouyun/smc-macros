run("Gaussian Blur...", "sigma=1 stack");
run("Subtract Background...", "rolling=50 stack");
run("32-bit");
run("find blob 3D mask subspots", "threshold=6000 minimum=500 max=30000 segment=2 quantify=1 filter=3");
run("Close All");
