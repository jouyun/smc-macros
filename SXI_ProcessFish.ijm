roiManager("reset");
t=getTitle();
run("Make Composite");
run("Next Slice [>]");
run("Next Slice [>]");
run("Delete Slice", "delete=channel");
run("Scale...", "x=.5 y=.5 z=1.0 width=960 height=720 depth=2 interpolation=Bilinear average create");
run("Canvas Size...", "width=1024 height=1024 position=Top-Left zero");
run("32-bit");
run("Make Windows", "window=512 z=1 staggered?");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames=9 display=Grayscale");

//run("Make Composite", "display=Composite");
//run("Unet", "number=1 scale=255 select=/n/projects/Fiji/Fiji.app/tensorflow/frozen_FatFish.pb");
run("Unet", "number=1 scale=255 select=U:\\Fiji\\Fiji.app\\tensorflow\\frozen_FatFishv2.pb");
while (isOpen("Img")==false)
{
	wait(1000);
}
selectWindow("Img");
run("Make Image From Windows", "width=1024 height=1024 slices=1 staggered?");
makeRectangle(0, 0, 960, 720);
run("Crop");
run("Scale...", "x=- y=- z=1.0 width=1920 height=1440 depth=2 interpolation=Bilinear average create");

setThreshold(0.3282, 1000000000000000000000000000000);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "add");
selectWindow(t);
roiManager("Show All");