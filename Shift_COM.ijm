width=getWidth();
height=getHeight();
Stack.getPosition(channel, slice, frame);
run("Measure");
startX=getResult("BX", nResults-1);
lWidth=getResult("Width", nResults-1);
shift=width/2-(startX+lWidth/2);
run("Translate...", "x="+shift+" y="+0+" interpolation=None ");
Stack.setFrame(frame+1);