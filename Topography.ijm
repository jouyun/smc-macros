run("Close All");
for (i=0; i<10; i++)
{
	run("Topography Mapper", "latitude=25.537640 longitude=-126.005814 km=10 starting="+(i*50));
	//run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.35");
}
run("Concatenate...", "all_open title=[Concatenated Stacks]");
run("Z Project...", "projection=[Max Intensity]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Flip Vertically");