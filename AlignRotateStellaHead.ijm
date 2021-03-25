
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
run("Set Measurements...", "area mean min centroid center perimeter bounding fit shape integrated median stack redirect=None decimal=3");

roiManager("Select", 1);
run("Measure");
X0=parseFloat(getResult("X",nResults-1));
Y0=parseFloat(getResult("Y",nResults-1));
Stack.getPosition(channel,slice,frame);
Z0=slice;
roiManager("Select", 3);
run("Measure");
X1=parseFloat(getResult("X",nResults-1));
Y1=parseFloat(getResult("Y",nResults-1));
Stack.getPosition(channel,slice,frame);
Z1=slice;
roiManager("Select", 0);
run("Measure");
X0p=parseFloat(getResult("X",nResults-1));
Y0p=parseFloat(getResult("Y",nResults-1));
Stack.getPosition(channel,slice,frame);
Z0p=slice;
roiManager("Select", 2);
run("Measure");
X1p=parseFloat(getResult("X",nResults-1));
Y1p=parseFloat(getResult("Y",nResults-1));
Stack.getPosition(channel,slice,frame);
Z1p=slice;
dX=X1-X0;
dY=Y1-Y0;
dZ=Z1-Z0;
IJ.log(""+dX+","+dY+","+dZ);
R0=-atan(dY/dX)/2/3.1415926*360;
R1=-atan(dZ/sqrt(dX*dX+dY*dY))/2/3.141592653*360;

dX=X1p-X0p;
dY=Y1p-Y0p;
dZ=Z1p-Z0p;
R2=-atan(dZ/sqrt(dX*dX+dY*dY))/2/3.141592653*360;

IJ.log("R0: "+R0+", R1: "+R1+", R2"+R2);
middle_x=(X0+X1+X0p+X1p)/4;
middle_y=(Y0+Y1+Y0p+Y1p)/4;
Stack.getDimensions(width, height, channels, slices, frames);
x_shift=(width/2-middle_x);
y_shift=(height/2-middle_y);
IJ.log(""+x_shift+","+y_shift);
run("TransformJ Translate", "x-translation="+x_shift+" y-translation="+y_shift+" z-translation=0.0 interpolation=linear background=0.0");
//run("Translate...", "x="+x_shift+" y="+y_shift+" interpolation=None stack");

run("TransformJ Rotate", "z-angle="+R0+" y-angle="+R1+" x-angle="+R2+" interpolation=linear background=0.0 adjust");

