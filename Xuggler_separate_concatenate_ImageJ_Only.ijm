frameks=27;

full_name= File.openDialog("Select a File");
direc=File.getParent(full_name);
fname=File.getName(full_name);
IJ.log(direc);
tmp_dir=direc+"\\tmp\\";
out_dir=direc+"\\output\\";
File.makeDirectory(tmp_dir);
File.makeDirectory(out_dir);
IJ.log(tmp_dir);

for (i=0; i<frameks; i++)
{
     run("Xuggler file reader jru v1", "open="+full_name+" start_frame="+(i*1000+1)+" end_frame="+(i*1000+1000-1)+" frame_interval=1 convert_to_greyscale? crop_x_start=0 crop_y_start=0 crop_width=720 crop_height=480 spatially_bin_by?=1");
     title=getTitle();

     selectWindow(title);
     tmp_title=fname+"-1-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(15, 3, 220, 151);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-2-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(237, 2, 230, 153);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-3-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(467, 2, 225, 154);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-4-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(13, 157, 223, 155);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-5-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(237, 157, 232, 155);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-6-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(469, 157, 232, 155);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-7-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(13, 313, 223, 155);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     tmp_title=fname+"-8-"+(i*1000+1)+".tif";
     run("Duplicate...", "title=7-27_3-1.avi duplicate range=1-1000");
     makeRectangle(237, 312, 227, 155);
     run("Crop");
     saveAs("Tiff", tmp_dir+tmp_title);
     close();

     selectWindow(title);
     close();
}

for (m=1; m<9; m++)
{
     current_title=fname+"-"+m+".tif";
     tmp_title=fname+"-"+m+"-1.tif";
     open(tmp_dir+tmp_title);    
     rename(current_title);
     for (i=1; i<frameks; i++)
     {
          tmp_title=fname+"-"+m+"-"+(i*1000+1)+".tif";
          open(tmp_dir+tmp_title);    
          run("Concatenate...", "  title="+current_title+" image1="+current_title+" image2="+tmp_title+" image3=[-- None --]");
     }
     selectWindow(current_title);
     saveAs("Tiff", out_dir+current_title);
     close();
}

