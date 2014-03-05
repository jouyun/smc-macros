file_path=File.openDialog("Choose PEdatabase file");

run("Bio-Formats Importer", "open=["+file_path+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
title=getTitle();
run("Z Project...", "start=1 stop=5 projection=[Max Intensity] all");
p_title=getTitle();
selectWindow(title);
close();
new_directory=File.getParent(file_path)+"\\Worms\\";
IJ.log(new_directory);
File.makeDirectory(new_directory);
selectWindow(p_title);
run("merge objects in tiles", "snr=40 hit=1000 border=100 in=200 x=18 y=18 path=["+new_directory+"]");

selectWindow(p_title);
close();