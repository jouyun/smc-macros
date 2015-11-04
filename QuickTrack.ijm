drop=0.85;
background=100;

//background=159;
//drop=0.8;

t=getTitle();
run("seeded multipoint adaptive region grow", "background="+background+" drop="+drop+" minimum=-150");
rename("A1");
run("Analyze Particles...", "display");
for (i=1; i<74; i++)
{
	selectWindow(t);
	setSlice(i+1);

	X=getResult("XM", nResults-1);
	Y=getResult("YM", nResults-1);
	makePoint(X,Y);
	
	run("seeded multipoint adaptive region grow", "background="+background+" drop="+drop+" minimum=-150");
	rename("A"+(i+1));
	run("Analyze Particles...", "add");
}
//return("");
selectWindow(t);
close();
run("Concatenate...", "all_open title=[Concatenated Stacks]");
run("32-bit");
open("/n/projects/smc/public/RLA/"+t);
//open("D:\\SMC\\"+t);
run("Merge Channels...", "c2="+t+" c6=[Concatenated Stacks] create");