name=getArgument;
if (name=="")
{
    source_dir = getDirectory("Source Directory");
}
else
{
    source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
	if (endsWith(source_list[n], ".tif"))
	{
		
		open(source_dir+source_list[n]);
		Stack.getDimensions(width, height, channels, slices, frames);
		run("Grays");
		Stack.setSlice(Math.floor(slices/2));
		Stack.setChannel(2);
		run("Magenta");
		setMinAndMax(0, 1);
		//run("Brightness/Contrast...");
		run("In [+]");
		run("In [+]");
		run("In [+]");
		run("In [+]");

		waitForUser;
		Dialog.create("Example Dialog");
		items = newArray("New York", "London", "Paris", "Tokyo");
		Dialog.addRadioButtonGroup("Cities", items, 2, 2, "Paris");
	  	Dialog.show();
		type = Dialog.getRadioButton();
		IJ.log(type);
		close();
	}
}
