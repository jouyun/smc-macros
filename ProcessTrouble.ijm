current="3A9";
open("D:\\smc\\Adler Planatarian\\Trouble\\"+current+".tif");
title=getTitle();
runMacro("S:\\Microscopy\\USERS\\SMC\\Fiji.app\\macros\\ProcessWormPluginv2.ijm");
selectWindow("Log");
saveAs("Text", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-Results.txt");
selectWindow("TempImg");
saveAs("Tiff", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-processed.tif");
close();
selectWindow(title);
close();

current="6-9C";
open("D:\\smc\\Adler Planatarian\\Trouble\\"+current+".tif");
title=getTitle();
runMacro("S:\\Microscopy\\USERS\\SMC\\Fiji.app\\macros\\ProcessWormPluginv2.ijm");
selectWindow("Log");
saveAs("Text", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-Results.txt");
selectWindow("TempImg");
saveAs("Tiff", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-processed.tif");
close();
selectWindow(title);
close();

current="unc22";
open("D:\\smc\\Adler Planatarian\\Trouble\\"+current+".tif");
title=getTitle();
runMacro("S:\\Microscopy\\USERS\\SMC\\Fiji.app\\macros\\ProcessWormPluginv2.ijm");
selectWindow("Log");
saveAs("Text", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-Results.txt");
selectWindow("TempImg");
saveAs("Tiff", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-processed.tif");
close();
selectWindow(title);
close();

current="8-11E";
open("D:\\smc\\Adler Planatarian\\Trouble\\"+current+".tif");
title=getTitle();
runMacro("S:\\Microscopy\\USERS\\SMC\\Fiji.app\\macros\\ProcessWormPluginv2.ijm");
selectWindow("Log");
saveAs("Text", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-Results.txt");
selectWindow("TempImg");
saveAs("Tiff", "D:\\smc\\Adler Planatarian\\Trouble\\"+current+"-processed.tif");
close();
selectWindow(title);
close();