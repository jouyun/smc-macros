n=roiManager("Count");
for (i=0; i<n; i++)
{
	roiManager("Select", i);
	setForegroundColor(255, 255, 255);
	run("Fill", "slice");
}