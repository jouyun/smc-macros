t=getTitle();
run("Duplicate...", "title=B duplicate");
run("Select All");
setBackgroundColor(0, 0, 0);
run("Clear", "stack");
run("Duplicate...", "title=C duplicate");

run("Merge Channels...", "c1=["+t+"] c2=B c3=C create");


count=roiManager("Count");


setForegroundColor(255, 255, 255);
for (i=0; i<count; i++)
{
	setForegroundColor(255, 255, 255);
    roiManager("Select", i);
    Stack.setChannel(2);
    run("Draw", "slice");
    Stack.setChannel(3);
    run("Fill", "slice");
    setForegroundColor(0,0,0);
    run("Draw", "slice");
}
setForegroundColor(255, 255, 255);