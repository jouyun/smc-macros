slices=15;

Stack.getPosition(channel, slice, cur_frame);
my_slice=slice;
t=getTitle();

if (isOpen("ROI Manager"))
{
	selectWindow("ROI Manager");
	run("Close");
}
run("Stack to Hyperstack...", "order=xyzct channels=5 slices="+slices+" frames=1 display=Grayscale");

selectWindow(t);

run("Gaussian Blur...", "sigma=1 stack");
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
run("Subtract Background...", "rolling=3 stack");
tmp=getTitle();
selectWindow(t);
close();
selectWindow(tmp);
rename(t);

slice=my_slice;
A_title="A"+(cur_frame);
//run("Duplicate...", "title="+A_title+" duplicate channels=1 slices="+slice+" frames="+cur_frame);
run("Duplicate...", "title="+A_title+" duplicate channels=1");
run("Channels Tool...");
run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");

selectWindow(t);
B_title="B"+(cur_frame);
//run("Duplicate...", "title="+B_title+" duplicate channels=4 slices="+slice+" frames="+cur_frame);
run("Duplicate...", "title="+B_title+" duplicate channels=4");
run("Channels Tool...");
run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");
selectWindow(t);
close();

run("Concatenate...", "  title=asdf image1="+A_title+" image2="+B_title+" image3=[-- None --]");
run("StackReg", "transformation=[Rigid Body]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=1 display=Grayscale");
run("Find Maxima...", "noise=750 output=[Point Selection]");
rename(t);
//run("seeded multipoint adaptive region grow", "background=2000 drop=.5 minimum=-150 quantify minimum=5 maximum=20");
run("seeded multipoint adaptive region grow", "background=0 drop=.5 minimum=-150 quantify minimum=5 maximum=20");
return("");
run("32-bit");
rename("Mask");
close();
selectWindow(t);
return("");
//run("Merge Channels...", "c2="+A_title+" c3="+B_title+" c4=Mask create");
//rename("Final"+cur_frame);
