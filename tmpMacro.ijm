base="p53_30min"
directory="/home/smc/Data/LCC/H3P quantification amputated fragments/2014-04-10 unc p53 zfp1 RNAi amp below PR/"+base+"/"
name=base+".mvd2";
run("Bio-Formats Importer", "open=["+directory+name+"] autoscale color_mode=Default concatenate_series open_all_series view=Hyperstack stack_order=XYCZT");
tmp_directory=directory+"Tiffs/";
File.makeDirectory(tmp_directory);
wid=6;
hei=4;

run("Max Project With Reference At Front", "channels=2 frames="+(wid*hei));
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=1 frames="+(wid*hei)+" display=Grayscale");
runMacro("SaveMultipageImageSequence.ijm", tmp_directory);
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+wid+" grid_size_y="+hei+" tile_overlap=20 first_file_index_i=0 directory=["+tmp_directory+"] file_names=Tiffs{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
saveAs("Tiff", directory+"Fused.tif");
//run("Close All");