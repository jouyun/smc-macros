//run("Duplicate...", "duplicate channels=3");
t=getTitle();
Stack.setChannel(2);
run("Subtract Background...", "rolling=300 stack");
run("Trim In Z Automatically", "fraction=0.005");
run("Make Composite", "display=Grayscale");
run("Split Channels");
selectWindow("C1-Img");
run("Scale Ramp Zstack", "background=0 final=0.3");
selectWindow("C2-Img");
run("Scale Ramp Zstack", "background=0 final=0.3");
selectWindow("C3-Img");
run("Scale Ramp Zstack", "background=0 final=20 exponential?");
run("Merge Channels...", "c1=C1-Img c2=C2-Img c3=C3-Img create");

run("Duplicate...", "duplicate channels=1");
run("Median...", "radius=10 stack");
setOption("BlackBackground", true);
setThreshold(655, 65535);
return("");
run("Convert to Mask", "method=Default background=Dark black");
run("3D Simple Segmentation", "low_threshold=128 min_size=5000 max_size=-1");

selectWindow("Seg");
run("32-bit");
selectWindow("Img");
run("add channel", "target=Seg");
run("Arrange Channels...", "new=4123");
Stack.setChannel(1);
run("Separate Out 3D Objects");
for (i=0; i<100; i++)
{
	tmp="Object"+(i+1);
	if (isOpen(tmp))
	{
		selectWindow(tmp);
		run("Split Channels");
		selectWindow("C1-"+tmp);
		run("Divide...", "value="+(i+1)+" stack");
		run("Merge Channels...", "c1=C1-"+tmp+" c2=C2-"+tmp+" c3=C3-"+tmp+" c4=C4-"+tmp+" create");
		rename(tmp);
		for (j=1; j<5; j++)
		{
			Stack.setChannel(j);
			run("Enhance Contrast", "saturated=0.35");
		}
		
		run("Save As Tiff", "save=S:/micro/mg2/cyc/smc/20180226_3PO_Vasa/Tiffs/"+t+"_"+tmp+".tif");
	}
}
