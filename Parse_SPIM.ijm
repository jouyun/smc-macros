idx=0;
for (i=0; i<13; i++)
{
	run("Raw...", "open=[D:\\smc\\05022012 Liang\\out_230PM.raw] image=[16-bit Unsigned] width=1004 height=1002 offset="+idx+" number=100 gap=0 little-endian");
	run("Stack to Hyperstack...", "order=xyzct channels=2 slices=50 frames=1 display=Grayscale");
	saveAs("Tiff", "D:\\smc\\05022012 Liang\\Series\\out_"+i+".tif");
	close();	
	idx=idx+201201600;
	print("open=[D:\\smc\\05022012 Liang\\out_230PM.raw] image=[16-bit Unsigned] width=1004 height=1002 offset="+idx+" number=100 gap=0 little-endian");
}
