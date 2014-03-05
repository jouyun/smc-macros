//setBatchMode(true);
path=File.openDialog("Select any file");
threshold=90.0;
dir = File.getParent(path);
list= getFileList(dir);
NumFiles=list.length;
v=newArray(NumFiles);
for(i=0;i<NumFiles;i++){
     kernel=dir+File.separator+list[i];
     open(kernel);
     ImgName = getTitle();
     IJ.log(ImgName);
     rename("temp");
     run("Split Channels");
     selectWindow("C1-temp");
     Stack.getDimensions(w, h, c, slices, f);
     position=slices/2;
     kernel="title=green channels=1-3 slices=1-14";
     run("Duplicate...", "title=green");
     selectWindow("green");
     selectWindow("C1-temp");
     close();
     selectWindow("C2-temp");
     kernel="title=red channels=1-3 slices=1-14";
     run("Duplicate...", "title=red");
     selectWindow("red");
     selectWindow("C2-temp");
     close();
     selectWindow("green");
     //setAutoThreshold("IsoData dark");
     //getThreshold(c1lower, upper);
     //IJ.log("C1:   "+c1lower);
     selectWindow("red");
     //setAutoThreshold("IsoData dark");
     //getThreshold(c2lower, upper);
     //IJ.log("C2:   "+c2lower);
     print("\\Clear");
    
     selectWindow("red");
     //If using percentile uncomment this
     //run("Threshold Percentile", "threshold="+threshold);

     //If using percentile comment this block
     //method="Moments";
     method="Li";
     run("Duplicate...", "title=Thresholded");
     setAutoThreshold(""+method+" dark");
     run("Convert to Mask");
     //Extra bit to do the same thresholding on green and perform OR
     rename("red_thresh");
     selectWindow("green");
     run("Duplicate...", "title=green_thresh");
     setAutoThreshold(""+method+" dark");
     run("Convert to Mask");
     imageCalculator("OR create", "red_thresh","green_thresh");
     rename("Thresholded");
     selectWindow("green_thresh");
     close();
     
     selectWindow("red_thresh");
     close();
    
     run("Calculate Masked Pearsons", "first=green second=red mask=Thresholded");
    
     logs=getInfo("log");
     comm=indexOf(logs,":");
     peaks=substring(logs,comm+1,lengthOf(logs));
     tolog=","+peaks+",";
     v[i]=peaks;
     selectWindow("red");
     close();
     selectWindow("green");
     close();
     selectWindow("Thresholded");
     close();
     run("Close All");
}
f = File.open("C:\\"+File.getName(dir)+".csv");
for(i=0;i<NumFiles;i++)
{
     print(f, ""+v[i]);
}
File.close(f);