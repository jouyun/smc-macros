//Boilerplate file loading
current_file=getArgument;

if (current_file=="")
{
     current_file = File.openDialog("Source Worm");
}
else
{
     //current_file=name;
}
open(current_file);
t=getTitle();
selectWindow(t);
run("32-bit");
run("Make Windows", "window=256 z=1 staggered?");
run("Enhance Contrast", "saturated=0.35");
saveAs("Raw Data", "/run/user/2179/gvfs/smb-share:server=tesla,share=media/smc/TransmittedYeastSpores/ProcessMe/"+substring(t, 0, lengthOf(t)-4)+".raw");
