title=getTitle();
'dirname=getDirectory("Select a source Directory for aligned images");
dirname="C:\\Users\\smc\\Desktop\\Photobleaching_Dec2011\\hjSi29_12192011_aligned\\"
full_name=dirname+""+title+".tif";
IJ.log(full_name);
open(full_name);
title=getTitle();

Stack.setChannel(1);
run("Reduce Dimensionality...", "  frames keep");
rename("B");

roiManager("Select", 1);
run("Plot Z-axis Profile");
Plot.getValues(x, bleach_a);


selectWindow("B");
roiManager("Select", 0);
run("Plot Z-axis Profile");
Plot.getValues(x, norm_a);
close();

selectWindow("B");
close();

selectWindow(title);
Stack.setChannel(2);
run("Reduce Dimensionality...", "  frames keep");
rename("B");

roiManager("Select", 1);
run("Plot Z-axis Profile");
Plot.getValues(x, bleach_b);


selectWindow("B");
roiManager("Select", 0);
run("Plot Z-axis Profile");
Plot.getValues(x, norm_b);
close();

selectWindow("B");
close();


selectWindow(title);

f = File.open("C:\\Data\\Processed\\"+title+".csv"); // display file open dialog

for (i=0; i<x.length; i++)
      print(f, x[i]+","+ bleach_a[i]+","+norm_a[i]+","+ bleach_b[i]+","+norm_b[i]);
      
File.close(f)

roiManager("Select", 0);
roiManager("Delete");
roiManager("Select", 0);
roiManager("Delete");
