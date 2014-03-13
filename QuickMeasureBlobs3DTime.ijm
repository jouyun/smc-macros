Stack.getDimensions(width, height, channels, slices, frames);
for (i=0; i<frames; i++)
{
     Stack.setFrame(i+1);
     run("Clear Results");
     selectWindow("Merged");
     run("find blob 3D tester", "threshold=200 minimum=80 selection=-1");
     close();
     saveAs("Results", "C:\\Data\\SMC\\Results5Dilations\\Results_"+IJ.pad(i+1,3)+".csv");
    
}