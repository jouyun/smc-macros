arg=getArgument;
//arg="C:\\Data\\SMC\\tmp\\_0-0";
setBatchMode(true);
uend=lastIndexOf(arg, "_");
dend=lastIndexOf(arg, "-");
base_filename=substring(arg, 0, uend);
IJ.log(base_filename);
first_frame=parseInt(substring(arg, uend+1, dend));
last_frame=parseInt(substring(arg, dend+1, lengthOf(arg)));
IJ.log(""+first_frame+" "+last_frame);

source_dir=base_filename;
source_list = getFileList(source_dir);
Array.sort(source_list);
for (n=first_frame; n<=last_frame; n++)
{


	worm_dir=source_dir+source_list[n]+"Worms\\";
	list=getFileList(worm_dir);
	for (m=0; m<list.length; m++) 
	{
		logs=runMacro("ProcessSingleWorm.ijm", worm_dir+list[m]);
		comm=indexOf(logs,",");
		if (comm!=-1)
		{
			peaks=substring(logs,0,comm);
			area=substring(logs, comm+1,lengthOf(logs));
		}
		else 
		{
		}      		
	}
}

