/*name=getArgument;
if (name=="")
{
	
}
else
{
	open(name);
}


setBatchMode(true);*/
run("Set Measurements...", "area mean standard min centroid center bounding fit integrated display redirect=None decimal=3");
nROIS=roiManager("count");
for (i=0; i<nROIS; i++)
{
	roiManager("select", i);
	run("Measure");
	BX=getResult("BX", nResults-1);
	BY=getResult("BY",nResults-1);
	wid=getResult("Width", nResults-1);
	hei=getResult("Height", nResults-1);
	theta=getResult("Angle", nResults-1);
	width=getWidth();
	height=getHeight();
	tx=width/2-(BX+wid/2);
	ty=height/2-(BY+hei/2);
	run("Translate...", "x="+tx+" y="+ty+" interpolation=None ");
	run("Rotate... ", "angle="+theta+" grid=1 interpolation=None enlarge ");
}
roiManager("reset");
run("Tiff...");