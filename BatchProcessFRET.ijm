name=getArgument;
if (name=="")
{
     source_dir = getDirectory("Source Directory");
}
else
{
     source_dir=name;
}
IJ.log(source_dir);
setBatchMode(false);
list = getFileList(source_dir);
base_name="NDExp_Point";
for (f=0; f<list.length/2; f++)
{
	cur_base_name=base_name+IJ.pad(f,4)+"_Seq";
	run("Bio-Formats Importer", "open=["+source_dir+File.separator+cur_base_name+IJ.pad(2*f,4)+".nd2"+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats Importer", "open=["+source_dir+File.separator+cur_base_name+IJ.pad(2*f+1,4)+".nd2"+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	runMacro("/n/projects/smc/Fiji_2016.app/macros/ProcessWideFieldFRETv3.ijm", "");
	run("Close All");
}

