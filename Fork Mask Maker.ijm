start_radius=5;
for (i=start_radius; i<20; i++)
{

radius=i;

brad=radius+5;
newImage("Neg", "32-bit Black", 256, 256, 1);
newImage("blobs", "32-bit Black", 256, 256, 1);
makeOval(128-brad, 128-brad, brad*2, brad*2);
run("Invert");
imageCalculator("Subtract 32-bit", "Neg","blobs");

newImage("Pos", "32-bit Black", 256, 256, 1);
makeOval(128-radius, 128-radius, radius*2, radius*2);
run("Invert");

lrad=radius-2;
makeOval(128-lrad, 128-lrad, lrad*2, lrad*2);
run("Invert");

imageCalculator("Add 32-bit", "Neg","Pos");
imageCalculator("Add 32-bit", "Pos","Neg");
rename("B");
selectWindow("Neg");
close();
selectWindow("blobs");
close();

if (i!=start_radius)
{
run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
}
else
{
selectWindow("B");
rename("A");
}
}


