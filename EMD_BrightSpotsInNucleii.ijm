root_dir="/n/core/micro/asa/emd/smc/20180914_FAL_Coloc/Clone7/";

file_list=getFileList(root_dir);
for (f=0; f<file_list.length; f++)
{
    run("Bio-Formats Importer", "open="+root_dir+file_list[f]+" color_mode=Default view=Hyperstack stack_order=XYCZT");
    t=getTitle();
    run("Gaussian Blur...", "sigma=1 stack");
    run("Subtract Background...", "rolling=50 stack");
    run("32-bit");
    run("find blob 3D mask subspots", "threshold=6000 minimum=500 max=30000 segment=2 quantify=1 filter=20 percentile=70");

    run("32-bit");
    selectWindow(t);
    run("add channel", "target=TempImg");
    run("Make Composite", "display=Grayscale");
    Stack.setDisplayMode("composite");
    Stack.setActiveChannels("1001");
    run("Magenta");
    Stack.setChannel(4);
    run("Grays");
    setMinAndMax(0, 1);
    run("Close All");    
}
