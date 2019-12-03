Stack.getDimensions(width, height, channels, slices, frames);
if (channels!=9)
{
	run("Stack to Hyperstack...", "order=xyzct channels=9 slices=96 frames=1 display=Grayscale");
}
