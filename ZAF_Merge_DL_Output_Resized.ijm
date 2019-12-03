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

current_dir=File.getParent(current_file);
resized_name=File.getName(current_file);
raw_name=substring(current_file, 0, lengthOf(current_file)-12)+"_output.raw";

IJ.log(raw_name);

open(current_file);
t=getTitle();
Stack.getDimensions(w,h,c,s,f);
run("Raw...", "open=["+raw_name+"] width=256 height=256 offset=0 number=100000 little-endian");
Stack.getDimensions(ww,hh,cc,ss,ff);
run("32-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames="+(cc*ss*ff/3)+" display=Grayscale");
run("Make Image From Windows", "width="+w+" height="+h+" slices=1 staggered?");
run("Make Composite", "display=Grayscale");
tt=getTitle();
run("Split Channels");
selectWindow(t);
run("Split Channels");
run("Merge Channels...", "c1=[C1-"+t+"] c2=[C1-NewImg] c3=[C2-"+t+"] c4=[C2-NewImg] c5=[C3-"+t+"] c6=[C3-NewImg] c7=[C4-"+t+"] create");
selectWindow(t);
Stack.setDisplayMode("grayscale");
//saveAs("Tiff", substring(current_file, 0, lengthOf(current_file)-12)+"_annotated.tif");

//GET RID OF THIS
run("Canvas Size...", "width="+2048+" height="+2044+" position=Center zero");


run("Save As Tiff", "save=["+substring(current_file, 0, lengthOf(current_file)-12)+"_annotated.tif"+"]");
run("Close All");