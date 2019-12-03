//Boilerplate file loading
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
open(current_file);
Stack.setChannel(4);
run("Trim In Z Automatically", "fraction=0.5");
run("Make Composite", "display=Grayscale");
Stack.getDimensions(width, height, channels, slices, frames);
loops=round(slices/5);
for (i=0; i<loops; i++)
{
	selectWindow("Img");
	run("Z Project...", "start="+(i*5+1)+" stop="+minOf(slices,(i+1)*5)+" projection=[Max Intensity]");
	run("Save As Tiff", "save=["+File.getParent(current_file)+File.separator+"Fused-"+i+".tif]");
	
}
