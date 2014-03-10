title=getTitle();
run("Duplicate...", "title=B duplicate range=1-225");
run("Concatenate...", "  title=A image1="+title+" image2=B image3=[-- None --]");
run("Stack to Hyperstack...", "order=xytzc channels=2 slices=1 frames=225 display=Grayscale");
rename(title);