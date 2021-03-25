t=getTitle();

run("32-bit");
run("Z Project...", "projection=[Average Intensity]");
tt=getTitle();
selectWindow(t);
close();
selectWindow(tt);
run("Duplicate...", "title=A duplicate channels=1");
selectWindow(tt);
run("add channel", "target=A");
run("Enhance Contrast", "saturated=0.35");

run("Subtract Background...", "rolling=50 stack");
rename(t);
Stack.setChannel(1);
run("Duplicate...", "title=A");
s=sz=4;
rename("Base");
run("LoG 3D", "sigmax="+s+" sigmay="+s+" displaykernel=0 volume=1");
while (isOpen("LoG of Base")==false)
{
	wait(1000);
}
run("Invert");
run("Find Maxima...", "noise=2 output=[Single Points]");


selectWindow(t);
run("32-bit");
run("Compute 3D Blob Statistics Round", "mask=[LoG of Base Maxima] first=12 lateral=4 threshold=1500");
selectWindow("Base");
close();
selectWindow("LoG of Base");
close();
selectWindow("LoG of Base Maxima");
close();
selectWindow(t);