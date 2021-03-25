//Boilerplate file loading
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}

current_dir=File.getParent(current_file);
//open(current_file);
run("Bio-Formats Importer", "open=["+current_file+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

run("Divide...", "value=3 stack");
run("Add...", "value=60 stack");

run("Z Project...", "projection=[Max Intensity] all");

run("Pad To Certain Channels", "number=5");

Stack.getDimensions(w,h,c,s,f);
if (w>h)
{
	new_width=(floor(w/256)+1)*256;
	new_height=(floor(w/256)+1)*256;
}
else 
{
	new_width=(floor(h/256)+1)*256;
	new_height=(floor(h/256)+1)*256;
}
run("Canvas Size...", "width="+new_width+" height="+new_height+" position=Center zero");

t=getTitle();
ttt=getTitle();



run("32-bit");

Stack.getDimensions(w,h,c,s,f);

run("Make Windows", "window=256 z=1 staggered?");
saveAs("Raw Data", current_file+".raw");
run("Make Image From Windows", "width="+w+" height="+h+" slices=1 staggered?");
run("Make Composite", "display=Composite");
run("Save As Tiff", "save=["+current_file+"_resized.tif] imp=NewImg");
run("Close All");