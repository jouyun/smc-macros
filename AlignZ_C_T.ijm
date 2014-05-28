Stack.getDimensions(width, height, channels, slices, frames);
Stack.getPosition(channel, slice, frame); 
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels*slices+" slices=1 frames="+frames+" display=Color");
Stack.setPosition((slice-1)*channels+channel, 1, frame);
run("multichannel stackreg", "transformation=Translation");
run("Hyperstack to Stack");
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+frames+" display=Color");