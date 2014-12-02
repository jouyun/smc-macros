setBatchMode(true);

AB_C="Only channel 28"; //Usually 18

for (i=40; i<42; i++)
{
	//41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
	base="Tiffs"+IJ.pad(i,4)+".tif";
	//if (i==195||i==190||i==103||i==100, 101 93 94 95 86 84) 
	//if (i==84||i==1192||i==1103||i==1195)
	{
open("/n/projects/smc/public/AKO/0812B/AB/"+base);
rename("AB");
open("/n/projects/smc/public/AKO/0812B/C/"+base);
rename("C");
run("Pairwise stitching", "first_image=AB second_image=C fusion_method=[Linear Blending] fused_image=A<->B check_peaks=5 compute_overlap subpixel_accuracy x=360.6434 y=-25.8680 registration_channel_image_1=["+AB_C+"] registration_channel_image_2=["+AB_C+"]");
//makeRectangle(1, 1, 2450, 510);
//run("Crop");

saveAs("Tiff", "/n/projects/smc/public/AKO/0812B/ABC/"+base);
run("Close All");	}
//else
{
	
}
}
