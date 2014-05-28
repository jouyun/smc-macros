spacer=1000;
for (i=0; i<(5400/spacer); i++)
{
	start=i*spacer+1;
	finish=start+spacer;
	run("Slice Keeper", "first="+start+" last="+finish+" increment=1");
	rename("A");
	run("Analyse Particles", "minimum=15 maximum=4 image=80 smart online stream file=[C:\\Users\\smc\\Desktop\\Particles Table.xls] pixel=30 accumulate=0 update=10 _image=imgNNNNNNNNN.tif start=0 in=50 _minimum=0 local=20 _maximum=1000 threads=50");
	rename("B");
	selectWindow("A");
	close();
	selectWindow("B");
	if (i!=0)
	{
		run("Concatenate...", "stack1=Concat stack2=B title=Concat");
	}
	else
	{
		rename("Concat");
	}
	selectWindow("TrialB.tif");
	
}

