fstr=File.openAsString("S:/micro/asa/cgh/lem/20210401_3PO_IMARE_Rootletin_Triple/Mapper.csv");
lines=split(fstr, "\n");
Stack.getDimensions(width, height, channels, slices, frames);
for (f=1; f<lines.length; f++)
//for (f=1; f<33; f++)
{
		//IJ.log(lines[f]);
		cur=split(lines[f], ",");
		for (j=0; j<channels; j++)
		{
			Property.setSliceLabel(cur[1]+"_"+cur[2], (f-1)*channels+j+1);
			IJ.log(cur[1]+"_"+cur[2]);
		}
}
		
		