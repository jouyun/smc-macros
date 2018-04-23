t=getTitle();

for (x=0; x<41; x++)
{
	for (y=0; y<31; y++)
	{
		selectWindow(t);
		x_offset=1+x*32;
		y_offset=1+y*32;
		makeRectangle(x_offset,y_offset, 64,64);
		run("Duplicate...", "title="+IJ.pad(x_offset,2)+"_"+IJ.pad(y_offset,2));		
	}
}

