
name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}
setBatchMode(false);
list = getFileList(source_dir);
for (m=0; m<list.length; m++)
{
    if (File.isDirectory(source_dir+list[m]))
    {
    	run("Collect Garbage");
        IJ.log(source_dir+list[m]);
        asdf=source_dir+list[m];
        IJ.log(substring(asdf, 0, lengthOf(asdf)-1)+".tif");
		run("Stitch Nikon Data", "channel=4 fusion=[Intensity of random input tile] choose=["+source_dir+list[m]+"]");
        run("Save As Tiff", "save=["+substring(asdf, 0, lengthOf(asdf)-1)+".tif]");
        run("Z Project...", "projection=[Max Intensity]");
        saveAs("Tiff", substring(asdf, 0, lengthOf(asdf)-1)+"_MAX.tif");
        run("Close All");
    }
}
