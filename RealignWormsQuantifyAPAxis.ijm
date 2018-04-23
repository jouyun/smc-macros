name=getArgument;
if (name=="")
{
	source_dir = getDirectory("Source Directory");
}
else
{
	source_dir=name;
}

source_list = getFileList(source_dir);
DAPI_file=source_dir+"Data.csv";
if (File.exists(DAPI_file)) File.delete(DAPI_file);
DAPIf=File.open(DAPI_file);




for (n=0; n<source_list.length; n++)
{
	cur_file=source_dir+source_list[n];
	if (endsWith(cur_file, "mask.tif"))
	{
		open(cur_file);
		/*********************************************
		 * ALIGNMENT PORTION
		 ********************************************/
		
		t=getTitle();
		
		run("Duplicate...", "title=Mask");
		setAutoThreshold("Default dark");
		run("Convert to Mask");
		run("Analyze Particles...", "display");
		
		x=getResult("XM", nResults-1);
		y=getResult("YM",nResults-1);
		theta=getResult("Angle", nResults-1);
		Major=getResult("Major", nResults-1);
		Minor=getResult("Minor", nResults-1);
		
		width=getWidth();
		height=getHeight();
		
		tx=floor(width/2-x);
		ty=floor(height/2-y);
		close();
		selectWindow(t);
		
		if (getWidth()>getHeight()) max_size=getWidth();
		else max_size=getHeight();
		run("Canvas Size...", "width="+1.2*max_size+" height="+1.2*max_size+" position=Center zero");
		run("Translate...", "x="+tx+" y="+ty+" interpolation=Bilinear enlarge stack");
		
		run("Rotate... ", "angle="+theta+" grid=1 interpolation=Bilinear enlarge stack");
		
		width=getWidth();
		height=getHeight();
		scale=1.2;
		IJ.log("width, Major, height, Minor: "+width+","+Major+","+height+","+Minor);
		if (width>scale*Major||height>scale*Minor)
		{
			makeRectangle(width/2-Major*scale/2, height/2-Minor*scale/2, scale*Major, scale*Minor);
			run("Crop");
		}
		width=getWidth();
		height=getHeight();
		if (width%2>0)
		{
			makeRectangle(0, 0, width-1, height);
			run("Crop");
		}
		if (height%2>0)
		{
			makeRectangle(0, 0, width, height-1);
			run("Crop");
		}
		run("Stack to Hyperstack...", "order=xyczt(default) channels=5 slices=1 frames=1 display=Grayscale");
		Stack.setChannel(4);
		headleft=getBoolean("Is head on left?");
		if (headleft==false) run("Flip Horizontally", "stack");
		Stack.setChannel(1);
		
		/*********************************************
		 * QUANTIFY/PLOT PORTION
		 ********************************************/
		mwidth=20;
		t=getTitle();
		run("Stack to Hyperstack...", "order=xyczt(default) channels=5 slices=1 frames=1 display=Grayscale");
		
		selectWindow(t);
		run("Duplicate...", "title=DAPI duplicate channels=1");
		run("Project In Y");
		tt=getTitle();
		selectWindow("DAPI");
		close();
		selectWindow(tt);
		run("Scale...", "x=- y=- width="+mwidth+" height=1 interpolation=Bilinear average create title=DAPI");
		run("Add...", "value=1");
		selectWindow(tt);
		close();
		
		selectWindow(t);
		run("Duplicate...", "title=H3P duplicate channels=3");
		run("Project In Y");
		tt=getTitle();
		selectWindow("H3P");
		close();
		selectWindow(tt);
		//return("");
		run("Scale...", "x=- y=- width="+mwidth+" height=1 interpolation=Bilinear average create title=H3P");
		selectWindow(tt);
		close();
		
		selectWindow(t);
		run("Duplicate...", "title=Tunel duplicate channels=5");
		run("Project In Y");
		tt=getTitle();
		selectWindow("Tunel");
		close();
		selectWindow(tt);
		run("Scale...", "x=- y=- width="+mwidth+" height=1 interpolation=Bilinear average create title=Tunel");
		selectWindow(tt);
		close();
		
		DAPI=t;
		selectWindow("DAPI");
		for (i=1; i<mwidth+1; i++)
		{
			DAPI=DAPI+","+getPixel(i-1,0);
		}
		
		//H3P=t;
		selectWindow("H3P");
		for (i=1; i<mwidth+1; i++)
		{
			DAPI=DAPI+","+getPixel(i-1,0);
		}
		
		Tunel=t;
		selectWindow("Tunel");
		for (i=1; i<mwidth+1; i++)
		{
			DAPI=DAPI+","+getPixel(i-1,0);
		}
		print(DAPIf, DAPI);
		IJ.log(DAPI);
		//print(H3Pf, H3P);
		//print(Tunelf, Tunel);
		run("Close All");

	}
}
File.close(DAPIf);

//imageCalculator("Divide 32-bit", "H3P","DAPI");
//imageCalculator("Divide 32-bit", "Tunel","DAPI");

/*
selectWindow("H3P");
run("Select All");
run("Plot Profile");

selectWindow("Tunel");
run("Select All");
run("Plot Profile");
*/