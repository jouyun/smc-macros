
name=getArgument;
if (name=="")
{
	source = getDirectory("Source Directory");	
}
else
{
	source=name;
}


setBatchMode(true);
open(source);
source_dir=File.getParent(source);
lines_to_reconstruct=1;

angle_spacing=0.2;
height=1024;
rename("A");
run("Back Project", "angle="+angle_spacing+" new="+height);

saveAs("Tiff", source+"_OPT.tif");
close();
selectWindow("A");
close();