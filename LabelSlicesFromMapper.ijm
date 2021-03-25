fstr=File.openAsString("S:/micro/asa/fgm/lem/20210218_3PO/20210218_3PO_IMARE-102875/Mapper.csv");
lines=split(fstr, "\n");
Stack.getDimensions(width, height, channels, slices, frames);
for (f=1; f<lines.length; f++)
//for (f=1; f<33; f++)
{
		//IJ.log(lines[f]);
		cur=split(lines[f], ",");
		for (j=0; j<channels; j++)
		{
			Property.setSliceLabel(cur[1], (f-1)*channels+j+1);
		}
}
		
		