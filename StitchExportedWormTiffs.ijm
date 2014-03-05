name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
base_name=File.getName(File.getParent(source_dir));
IJ.log(base_name);
save_name=File.getParent(source_dir)+File.separator+base_name+".mvd2.tif";
IJ.log(save_name);

run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(false);
source_list = getFileList(source_dir);
IJ.log("Number files:  "+source_list.length);
frames=source_list.length;

run("Image Sequence...", "open=["+source_dir+File.separator+"XY point 1 (raw tile 1).tif] number="+frames+" starting=1 increment=1 scale=100 file=[] sort");
t=getTitle();
run("Max Project With Reference", "channels=2 frames="+frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames="+frames+" display=Grayscale");
run("Duplicate...", "title=A duplicate channels=1 frames=1-"+frames);
selectWindow("Img");
run("Duplicate...", "title=B duplicate channels=2 frames=1-"+frames);
run("Concatenate...", "  title=A image1=B image2=A image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytzc channels=2 slices=1 frames="+frames+" display=Grayscale");
selectWindow("Img");
close();
selectWindow(t);
close();
selectWindow("A");
Stack.setDisplayMode("grayscale");
saveAs("Tiff", save_name);
close();
