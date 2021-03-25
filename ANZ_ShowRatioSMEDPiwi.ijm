t=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);

lat_scale=0.015625*4;
z_scale=0.5;


fname=File.openDialog("Choose CSV");
run("Create Image From CSV", "find="+fname);
selectWindow("Img");
run("Duplicate...", "title=Piwi duplicate channels=2");
selectWindow("Img");
run("Duplicate...", "title=SMED duplicate channels=3");

selectWindow("Piwi");
setThreshold(200.0000, 65535.0000);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
run("Divide...", "value=255 stack");
selectWindow("SMED");
setThreshold(200.0000, 65535.0000);
run("Convert to Mask", "method=Default background=Dark black");
run("32-bit");
run("Divide...", "value=255.000 stack");

imageCalculator("Multiply create 32-bit stack", "Piwi","SMED");
selectWindow("Result of Piwi");
rename("MaskedSMED");
selectWindow("Piwi");
run("Scale...", "x="+lat_scale+" y="+lat_scale+" z="+z_scale+" width=81 height=50 depth=13 interpolation=Bilinear average process create");
run("Multiply...", "value="+(1/lat_scale/lat_scale/z_scale)+" stack");

selectWindow("MaskedSMED");
run("Scale...", "x="+lat_scale+" y="+lat_scale+" z="+z_scale+" width=81 height=50 depth=13 interpolation=Bilinear average process create");
run("Multiply...", "value="+(1/lat_scale/lat_scale/z_scale)+" stack");

imageCalculator("Divide create stack", "MaskedSMED-1","Piwi-1");
run("Replace NAN", "replacement=-1");


run("Scale...", "x=- y=- z=- width="+width+" height="+height+" depth="+slices+" interpolation=Bilinear average process create");
rename("C");
/*selectWindow("Piwi-1");
run("Scale...", "x=- y=- z=- width="+width+" height="+height+" depth="+slices+" interpolation=Bilinear average process create");
rename("D");
imageCalculator("Add create stack", "D","E");
rename("C");*/

selectWindow(t);
run("Duplicate...", "title=A duplicate channels=2");
run("32-bit");
selectWindow(t);
run("Duplicate...", "title=B duplicate channels=3");
run("32-bit");

run("Merge Channels...", "c1=A c2=B c3=C create");
selectWindow("Composite");
run("Magenta");
Stack.setChannel(2);
run("Green");
