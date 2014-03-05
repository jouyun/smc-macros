title=getTitle();
f = File.open("C:\\Data\\"+title+".csv"); // display file open dialog
n = roiManager("count");
for (i=0; i<n; i++)
{
	roiManager("Select", i);
	run("Plot Z-axis Profile");
	Plot.getValues(x, bleach_a);
	close();	
	out="";
	for (j=0; j<x.length; j++)
	{
		out=out+bleach_a[j]+",";
	}
	print (f,out);
}
File.close(f);

