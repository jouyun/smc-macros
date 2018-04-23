t=getTitle();
run("32-bit");
run("Subtract Background...", "rolling=15 slice");
run("Gaussian Blur...", "sigma=1");
run("fix multipoint maxima", "size=5");
run("seeded multipoint adaptive region grow", "background=0 drop=.7 minimum=-150 minimum=5 maximum=20");
run("Analyze Particles...", "display clear add");
run("Clear Results");
selectWindow(t);
