tmp_dir=getArgument;

if (tmp_dir=="")
{
     tmp_dir = getDirectory("Source Directory");
}
else
{
     //current_file=name;
}

t=getTitle();
endf=indexOf(t, "background");
root_name=substring(t, 0, endf-1);
IJ.log(root_name);

//Clean up contrast
for (i=1; i<4; i++)
{
	Stack.setChannel(i);
	run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(1);
run("Green");
setMinAndMax(10, 4000);
Stack.setChannel(2);
setMinAndMax(10, 230);
run("Magenta");
Stack.setDisplayMode("grayscale");
Stack.setActiveChannels("110");
Stack.setChannel(1);

//Mark points
done=false;
ctr=0;
while(!done)
{
	waitForUser("Hold shift if no more clusters");
	if (isKeyDown("shift"))
	{
		done=true;
	}
	else
	{
		ctr++;
		//Save ROIs, measure, remove all ROIs
		roiManager("Save", ""+tmp_dir+root_name+"_Cluster"+ctr+".zip");
		roiManager("Show All");

		old_res=nResults;
		roiManager("Measure");
		new_res=nResults;
		IJ.log(""+old_res+","+new_res);
		for (j=old_res; j<new_res; j++)
		{
			setResult("Cluster", j, ctr);
		}
		updateResults();
		ct=roiManager("Count");
		for (i=0; i<ct; i++)
		{
			roiManager("Select", 0);
			roiManager("Delete");
		}
	}
}
setResult("Cluster", nResults, -1);
setResult("Label", nResults-1, t+":0000");
updateResults();

/*
nrois=roiManager("Count");
for (i=0; i<nrois/2; i++)
{
	selectWindow(t);
	roiManager("Select", i*2);
	Stack.getPosition(c,s1,f);
	selectWindow(t);
	roiManager("Select", i*2+1);
	Stack.getPosition(c,s2,f);

	run("Duplicate...", "duplicate slices="+s1+"-"+s2);
	run("Save", "save="+tmp_dir+root_name+"_Object"+(i+1)+"pp.tif");
	
}
if (isOpen("ROI Manager")) 
{
	//selectWindow("ROI Manager");
 	//run("Close");
}*/