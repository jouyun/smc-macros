rename("X");
run("Split Channels");
selectWindow("C2-"+"X");
rename("B");
selectWindow("C1-"+"X");
rename("A");

run("Colocalization Threshold", "channel_1=A channel_2=B use=None channel=[Red : Green] show show include");
selectWindow("A");
close();
selectWindow("B");
close();
