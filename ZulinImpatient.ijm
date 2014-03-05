t=getTitle();
Stack.getDimensions(width, height, channels, slices, frames);
for (i=0; i<slices; i++)
{
	selectWindow(t);
	run("Duplicate...", "title=current"+" duplicate channels=1-2 slices="+(i+1));
	tt=getTitle();
	run("MultiStackReg", "stack_1=current action_1=[Load Transformation File] file_1=U:\\omxworx\\Hawley\\CKC\\20140206\\TransformationMatrices.txt stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");
	if (i==0)
	{
		rename("Cumulative");
	}
	else
	{
		run("Concatenate...", "  title=Cumulative image1=Cumulative image2=current image3=current image4=[-- None --]");
	}
}
