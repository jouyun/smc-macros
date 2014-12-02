setBatchMode(true);

//A_B="Average all channels";
A_B="Only channel 20";  //Used to be 14
AB_C="Only channel 18";

for (i=0; i<66; i++)
{
	if (i==0||i==1||i==2||i==605)
	{
base="Tiffs"+IJ.pad(i,4)+".tif";
open("/n/projects/smc/public/AKO/0812B/A/"+base);
rename("A");
open("/n/projects/smc/public/AKO/0812B/B/"+base);
rename("B");
run("Pairwise stitching", "first_image=A second_image=B fusion_method=[Linear Blending] fused_image=A<->B check_peaks=5 compute_overlap subpixel_accuracy x=360.6434 y=-25.8680 registration_channel_image_1=["+A_B+"] registration_channel_image_2=["+A_B+"]");
rename("AB");
saveAs("Tiff", "/n/projects/smc/public/AKO/0812B/AB/"+base);
rename("AB");
//open("/n/projects/smc/public/AKO/0812B/C/"+base);
//rename("C");
//run("Pairwise stitching", "first_image=AB second_image=C fusion_method=[Linear Blending] fused_image=A<->B check_peaks=5 compute_overlap subpixel_accuracy x=360.6434 y=-25.8680 registration_channel_image_1=["+AB_C+"] registration_channel_image_2=["+AB_C+"]");
//saveAs("Tiff", "/n/projects/smc/public/AKO/0812B/ABC/"+base);
run("Close All");	}
//else
{
	
}
}

