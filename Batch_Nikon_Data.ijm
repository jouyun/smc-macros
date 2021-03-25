source_dir="D:\\SMC\\NikonData\\WellPlate_with_Robot\\20150819_183230_850\\";

analysis_file="D:\\SMC\\NikonData\\WellPlate_with_Robot\\20150819_183230_850\\out.csv";
base_folder="D:\\SMC\\NikonData\\WellPlate_with_Robot\\20150819_183230_850\\";
base_name="Plate003_Well";
base_number=2305;
chars=newArray("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P");

source_list = getFileList(source_dir);

rows=16;
columns=24;

//rows=1;
//columns=1;

//f = File.open(analysis_file); // display file open dialog

setBatchMode(false);

for (row=0; row<rows; row++)
{
	for (column=0; column<columns; column++)
	{
		area=1;
		mean=0;
		tmp_base=base_name+chars[row]+IJ.pad(column+1,2);
		file_path="";
		for (i=0; i<source_list.length; i++)
		{
			//IJ.log(tmp_base);
			//IJ.log(source_list[i]);
			if (startsWith(source_list[i],tmp_base))
			{
				file_path=base_folder+source_list[i];
			}
		}
		IJ.log(file_path);
		//run("Bio-Formats Importer", "open="+base+chars[row]+IJ.pad(column+1, 2)+"_Seq"+(base_number+2*(row*24+column))+".nd2 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_1");		
		run("Bio-Formats Importer", "open="+file_path+" autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_1");		
		tmp=getTitle();
		run("Z Project...", "projection=[Max Intensity]");
		rename("B");

		run("Concatenate...", "  title=A image1=A image2=B image3=[-- None --]");
		selectWindow(tmp);
		close();
		/*run("32-bit");
		run("Gaussian Blur...", "sigma=1");
		run("Percentile Threshold", "percentile=10 snr=15");
		run("Erode");
		run("Analyze Particles...", "size=2-Infinity display clear add");
		selectWindow("A");
		run("Clear Results");
		roiManager("Measure");
		total_res=nResults;

		
		
		for (i=0; i<total_res; i++)
		{
			area=(area+getResult("Area", i));
			mean=mean+getResult("Mean", i)*getResult("Area",i);
		}
		run("Close All");
		print(f,""+chars[row]+","+(column+1)+","+mean+","+area+","+mean/area);*/
	}
}
//File.close(f);