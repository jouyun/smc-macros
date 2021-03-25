i=1;
run("Concatenate...", "  title=[Concatenated Stacks] image1=A image2=B image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytcz channels=2 slices=1 frames=195 display=Color");
makeRectangle(197, 201, 643, 721);
run("Crop");
saveAs("Tiff", "D:\\smc\\SPIM\\05312012 LIA\\Second"+i+".tif");
close();
