name=getArgument;
if (name=="")
{
	source_dir=getDirectory("Source Directory");
}
else
{
	source_dir=name;
}

list = getFileList(source_dir);
IJ.log(list[0]);
for (m=0; m<list.length; m++) 
{
	runMacro("Parse_Out_Points.ijm", source_dir+list[m]+"\\tiffs\\");
}
