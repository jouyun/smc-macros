i=1;
selectWindow("outro_all.raw");
Stack.setSlice(i);
Stack.setChannel(1);
run("Reduce Dimensionality...", "  frames keep");
rename("A");
selectWindow("outro_all.raw");
Stack.setSlice(i);
Stack.setChannel(2);
run("Reduce Dimensionality...", "  frames keep");
rename("B");
selectWindow("A");
run("MultiStackReg");
selectWindow("B");
run("MultiStackReg");
