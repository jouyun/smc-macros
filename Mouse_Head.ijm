t=getTitle();
first_row=4;
second_row=4;

run("Properties...", "channels=3 slices=1 frames=1 unit=micron pixel_width=1 pixel_height=1 voxel_depth=1.0000");
run("Duplicate...", " ");
run("Invert");
setAutoThreshold("Triangle dark");
run("Convert to Mask");
run("Dilate");
roiManager("Deselect");
run("Analyze Particles...", "size=4813636-Infinity display clear add");


num_entries=roiManager("Count");
a=newArray(0);
b=newArray(0);
Array.sort(b);
Array.print(b);
Array.print(a);
scaler=1000000;

for (i=0; i<first_row; i++)
{
	val=(scaler*floor(parseFloat(getResult("XM",i)))+floor(parseFloat(getResult("YM",i))));
	a=Array.concat(a,val);
}

for (i=first_row; i<first_row+second_row; i++)
{
	val=(scaler*floor(parseFloat(getResult("XM",i)))+floor(parseFloat(getResult("YM",i))));
	b=Array.concat(b,val);
}



Array.print(a);
Array.sort(a);
Array.sort(b);
for (i=0; i<first_row; i++)
{
	y=a[i]%scaler;
	x=floor(a[i]/scaler);
	IJ.log("X,Y: "+x+","+y);
}

Array.sort(a);
for (i=0; i<second_row; i++)
{
	y=b[i]%scaler;
	x=floor(b[i]/scaler);
	IJ.log("X,Y: "+x+","+y);
}
close();

rec_size=4200;
for (i=0; i<first_row; i++)
{
	y=a[i]%scaler;
	x=floor(a[i]/scaler);
	selectWindow(t);
	makeRectangle(x-rec_size/2, y-rec_size/2, rec_size, rec_size);
	run("Duplicate...", "title=A"+i+" duplicate");
}
for (i=0; i<second_row; i++)
{
	y=b[i]%scaler;
	x=floor(b[i]/scaler);
	selectWindow(t);
	makeRectangle(x-rec_size/2, y-rec_size/2, rec_size, rec_size);
	run("Duplicate...", "title=A"+(i+first_row)+" duplicate");
}
str="";
for (i=0; i<first_row+second_row; i++)
{
	str=str+"image"+(i+1)+"=A"+i+" ";
}
str=str+"image"+(first_row+second_row+1)+"=[-- None --]";
IJ.log(str);
run("Concatenate...", "  title="+t+"stacked"+" "+str);

/*
run("Analyze Particles...");
makeRectangle(12948, 1476, 2556, 2436);
run("Measure");
roiManager("Deselect");
run("Analyze Particles...", "size=16000000-Infinity display clear add");
*/