title=getTitle();
step_size=1;
stack_size=1;
run("Duplicate...", "title=Aba duplicate range=1-"+stack_size);
run("Reslice [/]...", "output=1 start=Top avoid");
t=getTitle();
run("Z Project...", "start=1 stop="+3000+" projection=[Average Intensity]");
rename("A");
selectWindow("Aba");
close();
selectWindow(t);
close();

for (i=1; i<360; i++)
{
	IJ.log("Am on:  "+i);
	selectWindow(title);
	run("Duplicate...", "title=Aba duplicate range=1-"+stack_size);
	run("Rotate... ", "angle="+(i*step_size)+" grid=1 interpolation=Bilinear stack");
	run("Reslice [/]...", "output=1 start=Top avoid");
	t=getTitle();
	run("Z Project...", "start=1 stop="+3000+" projection=[Average Intensity]");
	rename("B");
	selectWindow("Aba");
	close();
	selectWindow(t);
	close();
	run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
}