cur_frame=1;
my_slice=11;
Stack.getPosition(channel, slice, cur_frame);
my_slice=slice;
t=getTitle();

if (isOpen("ROI Manager"))
{
	selectWindow("ROI Manager");
	run("Close");
}

selectWindow(t);
Stack.getPosition(channel, slice, frame);
slice=my_slice;
A_title="A"+(cur_frame);
run("Duplicate...", "title="+A_title+" duplicate channels=1 slices="+slice+" frames="+cur_frame);
run("Channels Tool...");
run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");

selectWindow(t);
B_title="B"+(cur_frame);
run("Duplicate...", "title="+B_title+" duplicate channels=4 slices="+slice+" frames="+cur_frame);
run("Channels Tool...");
run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("32-bit");

run("Concatenate...", "  title=asdf image1="+A_title+" image2="+B_title+" image3=[-- None --]");
run("StackReg", "transformation=[Rigid Body]");
run("Stack to Images");

selectWindow(A_title);
run("Find Maxima...", "noise=2000 output=[Point Selection]");
return("");
run("seeded multipoint adaptive region grow", "background=2000 drop=.5 minimum=-150");



run("Analyze Particles...", "size=0-20 show=Masks add");
rename("Mask");
run("Invert LUT");
run("32-bit");

selectWindow("Img");
close();

selectWindow(A_title);


selectWindow(B_title);
run("Merge Channels...", "c2="+A_title+" c3="+B_title+" c4=Mask create");
rename(t+"_measure");
setSlice(1);
num_res=getValue("results.count");
for (i=0; i<num_res; i++)
{
	roiManager("select", i);
	roiManager("Measure");
}

run("Green");

setSlice(2);
run("Green");
for (i=0; i<num_res; i++)
{
	roiManager("select", i);
	roiManager("Measure");
}
rename("Final"+cur_frame);
//run("Concatenate...", "  title=SaveMe image1="+A_title+" image2="+B_title+" image3=Mask image4=[-- None --]");
