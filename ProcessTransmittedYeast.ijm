t=getTitle();
if (isOpen("Img")==true)
{
	selectWindow("Img");
	close();
}
selectWindow(t);
run("Unet", "number=2 scale=40000 select=U:/Fiji/Fiji.app/tensorflow/frozen_TransYeast2Chan.pb");
while (isOpen("Img")==false)
{
	wait(1000);
}