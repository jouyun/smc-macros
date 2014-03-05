base_name=getTitle();
direc=getDirectory("Choose a Directory");
Stack.getDimensions(width, height, channels, slices, frames);
for (i=1; i<=slices; i++)
{
	selectWindow(base_name);
	Stack.setSlice(i);
	Stack.setChannel(1);
	run("Reduce Dimensionality...", "  frames keep");
	rename("A");
	selectWindow(base_name);
	Stack.setSlice(i);
	Stack.setChannel(2);
	run("Reduce Dimensionality...", "  frames keep");
	rename("B");
	selectWindow("A");
	run("FileStackReg2 ");
	selectWindow("B");
	run("FileStackReg2 ");	
	run("Concatenate...", "  title=[Concatenated Stacks] image1=A image2=B image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xytcz channels=2 slices=1 frames="+frames+" display=Color");
	'makeRectangle(197, 201, 643, 721);
	'run("Crop");
	if (i<10) saveAs("Tiff", direc+"\\data_0"+i+".tif");
	else saveAs("Tiff", direc+"\\data_"+i+".tif");
	close();
}
