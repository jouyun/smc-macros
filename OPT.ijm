//setTool("dropper");
lines_to_reconstruct=900;
angles=3600;
angle_spacing=0.1;
rename("A");
run("32-bit");
Stack.setSlice(1);
run("Back Project");
selectWindow("Img");
for (i=0; i<angles; i++)
{
     Stack.setSlice(i+1);
     run("Rotate... ", "angle="+(i*angle_spacing)+" grid=1 interpolation=Bilinear slice");
}

run("Z Project...", "start=1 stop="+angles+" projection=[Average Intensity]");
rename("B");
selectWindow("Img");
close();

for (j=1; j<lines_to_reconstruct; j++)
{
	selectWindow("A");
	Stack.setSlice(j+1);
run("Back Project");
selectWindow("Img");
for (i=0; i<angles; i++)
{
     Stack.setSlice(i+1);
     run("Rotate... ", "angle="+(i*angle_spacing)+" grid=1 interpolation=Bilinear slice");
}

run("Z Project...", "start=1 stop="+angles+" projection=[Average Intensity]");
rename("C");
selectWindow("Img");
close();
run("Concatenate...", "  title=B image1=B image2=C image3=[-- None --]");
}


