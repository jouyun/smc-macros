increment=2;
rows=1;
Stack.getPosition(channel, slice, frame);

start=slice;
name=getTitle();
Stack.setSlice(start);
run("Reduce Dimensionality...", "channels keep");
rename("A");
for (i=start+increment; i<start+increment*4; i+=increment)
{
     selectWindow(name);
     Stack.setSlice(i);
     run("Reduce Dimensionality...", "channels keep");
     rename("B");
     run("Combine...", "stack1=A stack2=B combine");    
     rename("A");
}
if (rows>1)
{
	selectWindow(name);
	Stack.setSlice(start+increment*4);
	run("Reduce Dimensionality...", "channels keep");
	rename("C");
	for (i=start+increment*5; i<start+increment*8; i+=increment)
	{
	     selectWindow(name);
	     Stack.setSlice(i);
	     run("Reduce Dimensionality...", "channels keep");
	     rename("D");
	     run("Combine...", "stack1=C stack2=D");    
	     rename("C");
	}
	run("Combine...", "stack1=A stack2=C combine");
}
Stack.setSlice(9);
run("Enhance Contrast", "saturated=0.35");
Stack.setSlice(9);
