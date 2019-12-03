Stack.getDimensions(width, height, channels, slices, frames);
run("Properties...", "channels="+channels+" slices="+slices+" frames=1 unit=µm pixel_width=1 pixel_height=1 voxel_depth=1");
Stack.getPosition(channel, slice, frame);
run("Measure");
x=floor(getResult("X"));
y=floor(getResult("Y"));
//z=getResult("Slice");
z=slice;
Stack.getDimensions(width, height, channels, slices, frames);
xshift=floor(width/2)-x;
yshift=floor(height/2)-y;
zshift=floor(slices/2)-z;

IJ.log(""+xshift);
IJ.log(""+yshift);
IJ.log(""+zshift);
//run("TransformJ Translate", "x-distance="+xshift+" y-distance="+yshift+" z-distance="+zshift+" interpolation=Linear background=0.0");
run("Translate XYZ", "x="+xshift+" y="+yshift+" z="+zshift);
