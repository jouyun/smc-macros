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
open(current_file);
run("32-bit");

Stack.getDimensions(w,h,c,s,f);

run("Make Windows", "window=256 z=1 staggered?");
saveAs("Raw Data", current_file+".raw");
run("Make Image From Windows", "width="+w+" height="+h+" slices=1 staggered?");
run("Make Composite", "display=Composite");
run("Save As Tiff", "save=["+current_file+"_resized.tif] imp=NewImg");
run("Close All");
