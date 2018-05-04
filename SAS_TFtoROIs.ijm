for (i=9; i<19; i++)
{
	run("Raw...", "open=/home/smc/Data/SAS/DeepLearn/tile"+i+"_output.raw width=64 height=64 number=129642");
	run("32-bit");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=64821 display=Grayscale");
	
	run("Make Image From Windows", "width=1024 height=1344 slices=51 staggered?");
	
	run("Duplicate...", "duplicate channels=2");
	setThreshold(100.0000, 255.0000);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Dilate", "stack");
	rename("A");
	
	run("3D Simple Segmentation", "low_threshold=128 min_size=600 max_size=-1");
	run("32-bit");
	
	open("/home/smc/Data/SAS/DeepLearn/Mouse 2 bone 2 tiffs and rois/bone 2 081516 tile "+i+".tif");
	
	run("add channel", "target=Seg");
	//run("Channels Tool...");
	run("Make Composite", "display=Composite");
	run("Green");
	setMinAndMax(0, 500);
	Stack.setChannel(3);
	run("Magenta");
	setMinAndMax(0, 1500);
	Stack.setChannel(5);
	run("Grays");
	Stack.setActiveChannels("10111");
	Stack.setActiveChannels("10101");
	//run("Brightness/Contrast...");
	saveAs("Tiff", "/home/smc/Data/SAS/DeepLearn/Tile"+i+"_merged.tif");
	run("Close All");

}