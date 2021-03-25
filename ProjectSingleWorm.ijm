


current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
IJ.log(current_file);
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
open(current_file);

//run("Slice Keeper", "first=1 last=64 increment=1");
title=getTitle();

run("Max Project With Reference", "channels=4 frames=1");
selectWindow(title);
close();
selectWindow("Img");
rename(title);
saveAs("Tiff", current_file+"_projected.tif");
