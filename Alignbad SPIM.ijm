
for (i=1; i<2; i++)
{
selectWindow("out_all.raw");
Stack.setSlice(i);
Stack.setChannel(1);
run("Reduce Dimensionality...", "  frames keep");
rename("A");
run("MultiStackReg", "stack_1=A action_1=[Load Transformation File] file_1=[F:\Share\05092012 Liang Mutant\TransformationMatrices.txt] stack_2=None action_2=Ignore file_2=[] transformation=Translation");
selectWindow("out_all.raw");
Stack.setSlice(i);
Stack.setChannel(2);
run("Reduce Dimensionality...", "  frames keep");
rename("B");
run("MultiStackReg", "stack_1=B action_1=[Load Transformation File] file_1=[F:\Share\05092012 Liang Mutant\TransformationMatrices.txt] stack_2=None action_2=Ignore file_2=[] transformation=Translation");
run("Interleave", "stack=A stack=B");

makeRectangle(197, 201, 643, 721);
run("Crop");
//run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=180 frames=1 display=Composite");
//saveAs("Tiff", "F:\\Share\\05092012 Liang Mutant\\out_all-z"+i+".tif");
//close();
}
