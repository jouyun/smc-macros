//setBatchMode(true);
path=File.openDialog("Select any file");

dir = File.getParent(path);
list= getFileList(dir);
NumFiles=list.length;
v=newArray(NumFiles);
for(i=0;i<NumFiles;i++){
	//kernel="open=["+dir+list[i]+"] color_mode=Default view=Hyperstack stack_order=XYCZT";
	kernel=dir+File.separator+list[i];
	//IJ.log(kernel);
	open(kernel);
	//run("Bio-Formats Importer", kernel);
	ImgName = getTitle();
	IJ.log(ImgName);
	rename("temp");
	run("Split Channels");
	selectWindow("C1-temp");
	Stack.getDimensions(w, h, c, slices, f);
	position=slices/2;
	//Stack.setSlice(position);
	kernel="title=green channels=1-3 slices=1-14";
	run("Duplicate...", "title=green");
	selectWindow("green");
	run("Smooth");
	selectWindow("C1-temp");
	close();
	selectWindow("C2-temp");
	//Stack.setSlice(position);
	kernel="title=red channels=1-3 slices=1-14";
	run("Duplicate...", "title=red");
	selectWindow("red");
	run("Smooth");
	selectWindow("C2-temp");
	close();
	selectWindow("green");
	setAutoThreshold("IsoData dark");
	getThreshold(c1lower, upper);
	//IJ.log("C1:   "+c1lower);
	selectWindow("red");
	setAutoThreshold("IsoData dark");
	getThreshold(c2lower, upper);
	//IJ.log("C2:   "+c2lower);
	print("\\Clear");
	
	//kernel = "imga=green imgb=red thra=" +c1lower+" thrb="+c2lower + " pearson";
	kernel = "imga=green imgb=red thra=" +"0"+" thrb="+c2lower + " costesthr";
	run("JACoP ",kernel);
	run("Close");
	run("Close");

	
	logs=getInfo("log");
	comm=indexOf(logs,"r=");
	peaks=substring(logs,comm+2,comm+6);
	tolog=","+peaks+",";
	v[i]=peaks;
	selectWindow("red");
	close();
	selectWindow("green");
	close();
}
f = File.open("D:\\"+File.getName(dir)+".csv"); 
for(i=0;i<NumFiles;i++)
{
	print(f, ""+v[i]);
}
File.close(f);