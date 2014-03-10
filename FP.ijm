title=getTitle();
step_size=0.2;
for (i=0; i<1800; i++)
{
	selectWindow(title);
	run("Duplicate...", "title=Aba duplicate");
	run("Rotate... ", "angle="+(i*step_size)+" grid=1 interpolation=Bilinear stack");
	run("Reslice [/]...", "output=1 start=Top avoid");
	t=getTitle();
	run("Z Project...", "start=1 stop="+3000+" projection=[Average Intensity]");
	rename("B");
	selectWindow("Aba");
	close();
	selectWindow(t);
	close();
	if (i==0) 
	{
		selectWindow("B");
		rename("A");
	}
	else run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
}
run("Reslice [/]...", "output=1 start=Top avoid");
t=getTitle();
selectWindow("A");
close();