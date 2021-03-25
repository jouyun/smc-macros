run("Combine...", "stack1=Source-Spectral stack2=Target-Spectral combine");
rename("Spectral");
selectWindow("Source-RGB");
saveAs("Tiff", "D:\\Source-RGB.tif");
selectWindow("Target-RGB");
saveAs("Tiff", "D:\\Target-RGB.tif");
selectWindow("Source-RGB.tif");
close();
selectWindow("Target-RGB.tif");
close();
open("D:\\Source-RGB.tif");
open("D:\\Target-RGB.tif");
run("Combine...", "stack1=Source-RGB.tif stack2=Target-RGB.tif combine");
rename("RGB");
run("Make Composite", "display=Composite");