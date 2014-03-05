title=getTitle();

for (i=0; i<3; i++)
{
	selectWindow(title);
	run("Duplicate...", "title=A duplicate channels=1-2 slices=1-15");
	selectWindow("A");
	run("Hyperstack to Stack");
	run("Deinterleave", "how=2");
	selectWindow("A #1");
	roiManager("Select", i);
	run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
	rename("A");
	selectWindow("A #2");
	roiManager("Select", i);
	run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
	rename("B");
	run("Concatenate", "  title=[Concatenated Stacks] image_1=[A] image_2=[B] image_3=[-- None --]");
	rename(title+i+".tif");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=1 display=Grayscale");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	run("Previous Slice [<]");
	run("Channels Tool... ");
	Stack.setDisplayMode("color");
	run("Blue");
	Stack.setChannel(2);
	run("Green");
	Stack.setChannel(1);
	run("Blue");
	Stack.setDisplayMode("composite");
	selectWindow("A #1");
	close();
	selectWindow("A #2");
	close();
	selectWindow(title+i+".tif");
	saveAs("Tiff", "F:\LD ER Shift\\"+title+i+".tif");
	close();
}	