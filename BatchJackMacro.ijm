name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(true);
source_list = getFileList(source_dir);
analysis_file=source_dir+"Analysis.csv";
f = File.open(analysis_file); // display file open dialog
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		worm_dir=source_dir+source_list[n]+"Images"+File.separator;
		//worm_dir=source_dir+source_list[n]+"\\";
		list=getFileList(worm_dir);
		for (m=0; m<list.length; m++) 
		{
			setBatchMode(true);
			run("Clear Results");
			if (endsWith(list[m],"mask.tif")==0)
			{
				runMacro("JackMacro.ijm", worm_dir+list[m]);
				for (i=0; i<nResults; i++)
				{
					print(f, worm_dir+","+ list[m]+","+getResult("Major", i)+","+ getResult("Minor",i));
				}
			}
			
		}
	}
}
File.close(f);