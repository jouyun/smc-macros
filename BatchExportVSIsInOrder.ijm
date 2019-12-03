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
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".vsi"))
    {
        IJ.log(fname);
		run("Export VSI InOrder", "choose=["+fname+"] zoom=2");
        run("Close All");
    }
}