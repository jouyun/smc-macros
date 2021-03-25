for (i=1; i<4; i++)
{
	Stack.setChannel(i);
	run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(1);
run("Green");
setMinAndMax(10, 376);
Stack.setChannel(2);
setMinAndMax(10, 3000);
run("Magenta");
Stack.setDisplayMode("grayscale");
Stack.setActiveChannels("110");
Stack.setChannel(1);