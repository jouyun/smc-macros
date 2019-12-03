t=getTitle();
lst=getList("image.titles");
Dialog.create("Choose other image");
Dialog.addChoice("Other image", lst);
Dialog.show();
choice=Dialog.getChoice();
selectWindow(choice);
Stack.getDimensions(width, height, channels, slices, frames);
selectWindow(t);
Stack.getDimensions(widthB, heightB, channelsB, slicesB, framesB);

initx=floor(widthB/2-width/2);
inity=floor(heightB/2-height/2);
makeRectangle(initx, inity, width, height);
run("Crop");


initz=floor(slicesB/2-slices/2);
IJ.log(""+initz);
if (channelsB>1) run("Duplicate...", "duplicate slices="+initz+"-"+(initz+slices-1));
else run("Duplicate...", "duplicate range="+initz+"-"+(initz+slices-1));