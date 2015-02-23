rename("Base");

//Fix the x drift

//Run this block first, then draw a line segment 
run("TransformJ Rotate", "z-angle=0.0 y-angle=-90 x-angle=0.0 interpolation=linear background=0.0 adjust");
rename("BasePrimaryRotation");
selectWindow("Base");
run("TransformJ Rotate", "z-angle=0.0 y-angle=0 x-angle=90 interpolation=linear background=0.0 adjust");
Stack.getDimensions(width, height, channels, slices, frames);
run("Z Project...", "projection=[Average Intensity] all");
run("Properties...", "channels=1 slices="+frames+" frames=1 unit=p pixel_width=1.0000000 pixel_height=1.0000000 voxel_depth=0.0000000");
rename("tmp");
run("TransformJ Rotate", "z-angle=0.0 y-angle=0 x-angle=-90 interpolation=linear background=0.0 adjust");
rename("CorrectionMap");
selectWindow("tmp");
close();
selectWindow("Base rotated");
close();
selectWindow("CorrectionMap");


//makeLine(172,2,55,91,152,93,122,127,56,172,106,173,21,231,70,232,29,279,124,280,33,350,167,351,170,356,61,446);

//Now run this block
run("Fix Z Drift Manually", "target=[BasePrimaryRotation]");
rename("Corrected");
run("TransformJ Rotate", "z-angle=0.0 y-angle=90 x-angle=0 interpolation=linear background=0.0 adjust");


//Run this block third, then draw a line segment 
run("TransformJ Rotate", "z-angle=0.0 y-angle=0 x-angle=-90.0 interpolation=linear background=0.0 adjust");
rename("BasePrimaryRotation");
selectWindow("Base");
run("TransformJ Rotate", "z-angle=0.0 y-angle=90 x-angle=0 interpolation=linear background=0.0 adjust");
Stack.getDimensions(width, height, channels, slices, frames);
run("Z Project...", "projection=[Average Intensity] all");
run("Properties...", "channels=1 slices="+frames+" frames=1 unit=p pixel_width=1.0000000 pixel_height=1.0000000 voxel_depth=0.0000000");
rename("tmp");
run("TransformJ Rotate", "z-angle=0.0 y-angle=-90 x-angle=0 interpolation=linear background=0.0 adjust");
rename("CorrectionMap");
selectWindow("tmp");
close();
selectWindow("Base rotated");
close();
selectWindow("CorrectionMap");


//makeLine(172,2,55,91,152,93,122,127,56,172,106,173,21,231,70,232,29,279,124,280,33,350,167,351,170,356,61,446);

//Now run this block
run("Fix Z Drift Manually", "target=[BasePrimaryRotation]");
rename("Corrected");
run("TransformJ Rotate", "z-angle=0.0 y-angle=0 x-angle=90 interpolation=linear background=0.0 adjust");
