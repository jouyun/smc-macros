t=getTitle();
run("Duplicate...", "title=B duplicate");
run("Next Slice [>]");
run("Select All");
setBackgroundColor(0, 0, 0);
run("Clear", "stack");


count=roiManager("Count");


setForegroundColor(255, 255, 255);
for (i=0; i<count; i++)
{
    roiManager("Select", i);
    //run("Fill", "slice");
    run("Draw", "slice");
}
