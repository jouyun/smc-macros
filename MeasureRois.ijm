run("Clear Results");
m=roiManager("count");
for (i=0; i<m; i++)
{
roiManager("select", i);
run("Measure");
}