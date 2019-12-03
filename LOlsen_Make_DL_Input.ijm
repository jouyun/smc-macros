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

run("Make Windows", "window=512 z=1 staggered?");
saveAs("Raw Data", substring(current_file, 0, lengthOf(current_file)-4)+".raw");
run("Make Image From Windows", "width="+w+" height="+h+" slices=1 staggered?");
run("Close All");
