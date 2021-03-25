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
    if (endsWith(fname, ".tif"))
    {
        IJ.log(fname);
        {
            runMacro("/n/projects/smc/Fiji_2016.app/macros/VPS_HighMagQuantificationv2.ijm", fname);
        }
        run("Close All");
    }
}