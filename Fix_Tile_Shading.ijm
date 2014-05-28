title=getTitle();

setBatchMode(true);
Stack.getDimensions(width,height, channels, slices, frames);
for (m=0; m<slices; m++)
{
	Stack.setSlice(m+1);
for (i=0; i<3; i++)
{
	for (j=0; j<3; j++)
	{
		selectWindow(title);
		run("Duplicate...", "title=A"+i+"_"+j+" channels=1-2 slices=1-36");
		makeRectangle(i*512, j*512, 512, 512);		
		run("Crop");
	}
}
run("Images to Stack");
	selectWindow("Stack");
	run("Duplicate...", "title=Stack-tmp.tif duplicate range=1-9");
	run("Subtract...", "value="+(0)+" stack");
	run("Z Project...", "start=1 stop=9 projection=[Max Intensity]");
	rename("project");
	imageCalculator("Divide create 32-bit stack", "Stack-tmp.tif","project");
	rename("base");
		selectWindow("base");

		Stack.setSlice(1);
		current_name="A"+0;
		run("Duplicate...", "title="+current_name);

	for (j=1; j<3; j++)
	{
		selectWindow("base");
		Stack.setSlice(j+1);
		run("Duplicate...", "title=B");
		run("Combine...", "stack1="+current_name+" stack2=B combine");
		rename(current_name);
	}
	for (i=1; i<3; i++)
	{
		current_name="A"+i;
		selectWindow("base");
		Stack.setSlice(i*3+1);
		run("Duplicate...", "title="+current_name);

		for (j=1; j<3; j++)
		{
			selectWindow("base");
			Stack.setSlice(i*3+j+1);
			run("Duplicate...", "title=B");
			run("Combine...", "stack1="+current_name+" stack2=B combine");
			rename(current_name);
		}
		run("Combine...", "stack1="+"A0"+" stack2="+current_name+" ");
		rename("A0");
	}
	run("Multiply...", "value=118");
	setMinAndMax(0, 160.0000);
	selectWindow("base");
	close();
	selectWindow("project");
	close();
	selectWindow("Stack-tmp.tif");
	close();
	selectWindow("A0");
	run("Select All");
	run("Copy");
	selectWindow(title);
	run("Paste");
	selectWindow("A0");
	close();
	selectWindow("Stack");
	close();
	selectWindow(title);
}
//run("Z Project...", "start=1 stop=9 projection=[Max Intensity]");