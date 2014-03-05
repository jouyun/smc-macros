
title=getTitle();
Stack.setChannel(1);
run("Reduce Dimensionality...", "  frames keep");
rename("A");
run("TestPlugin ", "transformation=[Rigid Body]");
selectWindow(title);
Stack.setChannel(2);
run("Reduce Dimensionality...", "  frames keep");
rename("B");
run("align from file", "transformation=[Rigid Body]");
selectWindow(title);
Stack.getDimensions(w, h, c, s, f);
selectWindow("A");
run("Concatenate...", "stack1=A stack2=B title=[Concatenated Stacks]");
run("Stack to Hyperstack...", "order=xyztc channels=2 slices="+s+" frames="+f+" display=Grayscale");
rename(title+".tif");