
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
my_title=getTitle();
run("Rotate 90 Degrees Right");
run("32-bit");
source_dir=File.getParent(source);
open("C:\\Data\\SMC\\8192-8192-Hann-Rho.tif");
filter_title=getTitle();
selectWindow(my_title);
run("Custom Filter...", "filter="+filter_title);
saveAs("Tiff", source+"_filtered.tif");
close();
selectWindow(filter_title);
close();