current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
fname=current_file;
par=File.getParent(fname)+File.separator;
run("Bio-Formats Importer", "open="+fname+" color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
//run("Scale...", "x=.25 y=.25 z=1.0 width=256 height=336 depth=25 interpolation=Bilinear average create");
rename("Base");
string=getImageInfo();
run("Z Project...", "projection=[Average Intensity] all");
run("Z Project...", "projection=[Average Intensity]");
rename("Zproj");
selectWindow("Base");
run("Duplicate...", "title=AA duplicate channels=1");
selectWindow("Zproj");
run("Duplicate...", "title=aa duplicate channels=1");
imageCalculator("Divide create 32-bit stack", "AA","aa");
selectWindow("Result of AA");
run("Multiply...", "value=20000 stack");
selectWindow("Base");
run("Duplicate...", "title=BB duplicate channels=2");
selectWindow("Zproj");
run("Duplicate...", "title=bb duplicate channels=2");
imageCalculator("Divide create 32-bit stack", "BB","bb");
selectWindow("Result of BB");
run("Multiply...", "value=20000 stack");
run("Merge Channels...", "c2=[Result of AA] c3=[Result of BB]");
selectWindow("Merged");
setMinAndMax(0, 500000);
Stack.setChannel(2);
setMinAndMax(0, 500000);
run("16-bit");
selectWindow("Merged");
Stack.setDisplayMode("grayscale");
selectWindow("Merged");
setMetadata("Info", string);
run("Stitch PE Single Object", "path=D:\\SMC fusion=[Linear Blending] override=1 use if=2");
run("Rotate 90 Degrees Right");
run("Save As Tiff", "save="+current_file+"_stitched.tif imp="+getTitle());