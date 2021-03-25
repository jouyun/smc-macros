Stack.getDimensions(width, height, channels, slices, frames);
run("Clear Results");
Stack.setChannel(1);
for (i=0; i<frames; i++)
{
     Stack.setFrame(i+1);
     run("Find Maxima...", "noise=10 output=Count");    
}
