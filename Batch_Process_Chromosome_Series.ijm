name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}
run("Clear Results");
img_name="img_000000000__000.tif";
run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
setBatchMode(false);
source_list = getFileList(source_dir);
max_X=0;
max_Y=0;
for (n=0; n<source_list.length; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		fidx=indexOf(source_list[n],"_");
		sidx=fidx+1+indexOf(substring(source_list[n], fidx+1, lengthOf(source_list[n])),"_");
		X=parseInt(substring(source_list[n], fidx+1, sidx));
		Y=parseInt(substring(source_list[n], sidx+1,lengthOf(source_list[n])-1));
			
		if (X>max_X) max_X=X;
		if (Y>max_Y) max_Y=Y;
	}
}
IJ.log("X: "+max_X+" Y: "+max_Y);	

//for (n=0; n<source_list.length; n++)
for (n=0; n<50; n++)
{
	if (File.isDirectory(source_dir+source_list[n])==1)
	{
		file_path=source_dir+source_list[n]+img_name;
		open(file_path);
		info=getImageInfo();
		IJ.log(source_list[n]);
		Xidx=indexOf(info, "XPositionUm")+16;
		Xend=Xidx+1+indexOf(substring(info, Xidx+1,lengthOf(info)), ",");
		Yidx=indexOf(info, "YPositionUm")+16;
		Yend=Yidx+1+indexOf(substring(info, Yidx+1,lengthOf(info)), ",");
		//myX=substring(info, Xidx,Xend-1);
		//myY=substring(info, Yidx,Yend-1);
		myX=parseFloat(substring(info, Xidx,Xend-1));
		myY=parseFloat(substring(info, Yidx,Yend-1));
		IJ.log("X: "+myX+" Y: "+myY);
		res=nResults;
		runMacro("Process_Chromosome_Series.ijm");
		IJ.log(""+nResults);
		for (i=res; res<nResults; i++)
		{
			setResult("XStage",i, myX);
			setResult("YStage",i, myY);
		}
		run("Close All");
		
		  //"XYStage-X_um": "-24145.6000",
	}
}
