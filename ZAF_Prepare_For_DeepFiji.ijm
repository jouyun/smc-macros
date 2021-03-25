name=getArgument;
if (name=="")
{
    source_dir = getDirectory("Source Directory");
}
else
{
    source_dir=name;
}
setBatchMode(false);
source_list = getFileList(source_dir);
for (n=0; n<source_list.length; n++)
{
    fname=source_dir+source_list[n];
    if (endsWith(fname, ".tif") && !endsWith(fname, "projection.tif"))
    {
    	IJ.log(fname);
    	open(fname);
		t=getTitle();
		run("Duplicate...", "title=DAPI duplicate channels=4");
		run("Duplicate...", "duplicate");
		run("Duplicate...", "duplicate");
		selectWindow(t);
		run("Duplicate...", "title=A duplicate channels=1");
		selectWindow(t);
		run("Duplicate...", "title=B duplicate channels=2");
		selectWindow(t);
		run("Duplicate...", "title=C duplicate channels=3");
		run("Merge Channels...", "c1=A c2=DAPI create");
		rename("A");
		run("Merge Channels...", "c1=B c2=DAPI-1 create");
		rename("B");
		run("Merge Channels...", "c1=C c2=DAPI-2 create");
		rename("C");
		run("Concatenate...", "  image1=A image2=B image3=C image4=[-- None --]");
		//selectWindow(t);
		//close();
		//selectWindow("Untitled");
		//rename(t);        }
        run("Save As Tiff", "save=["+fname+"_DL.tif]");
        run("Close All");
    }
    //close();
}




