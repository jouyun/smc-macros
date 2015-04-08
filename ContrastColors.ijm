Stack.getDimensions(width, height, channels, slices, frames);
if (channels>1)
{
	Stack.setChannel(1);
	run("Magenta");
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(3);
}
else
{
	run("Enhance Contrast", "saturated=0.35");
}
