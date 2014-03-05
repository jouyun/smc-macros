title=getTitle();
//a=roiManager("Range");
for (i=0; i<4; i++)
{
	selectWindow(title);
	run("Duplicate...", "title=A duplicate channels=1-2 slices=1-15");
	selectWindow("A");
	run("Hyperstack to Stack");
	roiManager("Select", 0);
	run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
	saveAs("Tiff", "E:\\Data\\092711 HYM980 OA cos7\\"+title+i+".tif");
	close();
	selectWindow("A");
	close();
	roiManager("Select", 0);
	roiManager("Delete");
}	