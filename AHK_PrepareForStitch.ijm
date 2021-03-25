for (i=0; i<32; i++)
{
	for (j=0; j<9; j++)
	{
		File.rename('/n/core/micro/mg2/ahk/smc/20171115_SCR_Batch/Batch2/Tiffs'+IJ.pad(i*9+j,4)+'.tif', '/n/core/micro/mg2/ahk/smc/20171115_SCR_Batch/Batch2/Tiffs'+IJ.pad(j,4)+'.tif');
	}
	run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=/n/core/micro/mg2/ahk/smc/20171115_SCR_Batch/Batch2 layout_file=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
	Stack.setDisplayMode("grayscale");

	saveAs("Tiff", "/n/core/micro/mg2/ahk/smc/20171115_SCR_Batch/Batch2/Fused"+IJ.pad(i,3)+".tif");
	close();
	for (j=0; j<9; j++)
	{
		//File.delete('/n/core/micro/mg2/ahk/smc/20171115_SCR_Batch/Batch2/Tiffs'+IJ.pad(i*9+1+j,4));
	}
}

