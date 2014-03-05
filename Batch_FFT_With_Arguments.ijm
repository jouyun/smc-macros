arg=getArgument;
setBatchMode(true);
uend=lastIndexOf(arg, "_");
dend=lastIndexOf(arg, "-");
base_filename=substring(arg, 0, uend);
IJ.log(base_filename);
first_frame=parseInt(substring(arg, uend+1, dend));
last_frame=parseInt(substring(arg, dend+1, lengthOf(arg)));
IJ.log(""+first_frame+" "+last_frame);
for (i=first_frame; i<=last_frame; i++)
{
	IJ.log("Working on:  "+ i+ " last index: "+last_frame);
	runMacro("FFT_With_Arguments", base_filename+IJ.pad(i,4)+".tif");
}
