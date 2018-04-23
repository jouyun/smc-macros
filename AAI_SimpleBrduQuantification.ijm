roiManager("Add");
run("Gaussian Blur...", "sigma=.5 stack");
run("Find Maxima...", "noise=15000 output=Count");
run("Grays");
//waitForUser
setSlice(2);
run("Grays");
run("Find Maxima...", "noise=20000 output=Count");
//waitForUser
setSlice(3);
run("Grays");
run("Find Maxima...", "noise=10000 output=Count");
//waitForUser
