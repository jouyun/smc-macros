Stack.getDimensions(width, height, channels, slices, frames);
Stack.getPosition(channel, slice, frame);
frame=103;
for (i=0; i<channels; i++)
{
	for (j=0; j<slices; j++)
	{
		Stack.setChannel(i+1);
		Stack.setSlice(j+1);
		Stack.setFrame(frame);
		run("FileStackReg3 ", "choose=/n/projects/smc/public/YUN/11_20_2012/TransformationMatrices103.txt");	
	}
}
saveAs("Tiff", "/n/projects/smc/public/YUN/11_20_2012/A-drift_corrected.tif");
