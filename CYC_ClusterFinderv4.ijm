run("Duplicate...", "duplicate channels=1");
run("Grays");
t=getTitle();
run("Log3D", "imp="+t+" sigmax="+10+" sigmay="+10+" sigmaz="+5);	

//15
//setThreshold(48996.0000, 1190700.0000);
//10
setThreshold(32705.8877, 605520.2700);

run("Convert to Mask", "method=Default background=Dark black");