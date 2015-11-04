macro "AutoRun" {
	setBackgroundColor(255,255,255);
	setPasteMode("Copy");
	exit();
}
//"Advanced Montage Menu Tool"


	var mont = newMenu("Advanced Montage Menu Tool", newArray("Make Montage...", "Montage to Stack...", "-", "RGB Color", "Canvas Size...", "-", "Overlays to ROI Manager", "-", "Montage Help"));

	macro "Advanced Montage Menu Tool - C00fF0077C0f0F9977Cf00F9077C888F0977" {
		mtge = getArgument();
		if (mtge!="-") {
		if (mtge=="Fix LSM XZ Scale") { FixLSMXZScaleTool(); }
		else if (mtge=="Montage Help") { run("Montage Help"); }
		else if (mtge=="Overlays to ROI Manager") { run("To ROI Manager"); }
		else { run(mtge); }
		}	
}


macro "Select Panels Tool - Cf00R0077R9077C888R9977R0977"{
    run("Select None");
    setPasteMode("Copy");
    w = getWidth;
    h = getHeight;
    getCursorLoc(x, y, z, flags);
    id=getImageID;
    t=getTitle;
    selectImage(id);
    xn = info("xMontage");
    yn = info("yMontage");
    if ((xn==0)||(yn==0)) {exit;}
    xc = floor(x/(w/xn));
    yc = floor(y/(h/yn));
    makeRectangle(xc*(w/xn),yc*(h/yn),(w/xn),(h/yn));
    xstart = x; ystart = y;
    x2=x; y2=y;
    x2c=xc;y2c=yc;
    while (flags&16 !=0) {
        getCursorLoc(x, y, z, flags);
        if (x!=x2 || y!=y2) {
            x2c = floor(x/(w/xn));
            y2c = floor(y/(h/yn));
            makeRectangle(xc*(w/xn),yc*(h/yn),(w/xn)*(x2c-xc+1),(h/yn)*(y2c-yc+1));
            x2=x; y2=y;
            wait(10);
        }
    }
    setPasteMode("add");
}


macro "Montage Shuffler Tool - C888R0077R9977C03fR0977R9077"{
    id=getImageID;
    run("Select None");
    setPasteMode("copy");
    w = getWidth;
    h = getHeight;
    getCursorLoc(x, y, z, flags);
    xn = info("xMontage");
    yn = info("yMontage");
    if ((xn==0)||(yn==0)) exit;
    xstart = x; ystart = y;
    x2=x; y2=y;
    while (flags&16 !=0) {
        getCursorLoc(x, y, z, flags);
        if (x!=x2 || y!=y2) spring(xstart, ystart, x, y);
        x2=x; y2=y;
        wait(10);
    }
    if (x!=xstart || y!=ystart) {
        xext=0;
        yext=0;
        if (x>w) xext=1;
        if (y>h) yext=1;
        if ((xext>0)||(yext>0)) {
            run("Canvas Size...", "width="+w+xext*(w/xn)+" height="+h+yext*(h/yn)+" position=Top-Left zero");
	
            setMetadata("xMontage="+(parseInt(xn)+parseInt(xext))+"\nyMontage="+(parseInt(yn)+parseInt(yext))+"\n");
	exit;
        }
        sc = floor(xstart/(w/xn));
        tc = floor(x/(w/xn));
        sr = floor(ystart/(h/yn));
        tr = floor(y/(h/yn));
        swap(sc,sr,tc,tr);

    }
}


//Annotation Tool

var str="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var numbers = call("ij.Prefs.get", "magicMontage.label.number", false);
var panels = call("ij.Prefs.get", "magicMontage.label.panels", 0);;
var labellength = call("ij.Prefs.get", "magicMontage.label.length", 0);
var labelfont = call("ij.Prefs.get", "magicMontage.label.font.type", "Arial");
var labelopt = call("ij.Prefs.get", "magicMontage.label.font.style", "bold");
var color = call("ij.Prefs.get", "magicMontage.label.font.color", "white");
var lcas = call("ij.Prefs.get", "magicMontage.label.lcas", false);
var antialiasedLabels = call("ij.Prefs.get", "magicMontage.label.antialiased", true);
var fontSizePercent = call("ij.Prefs.get", "magicMontage.label.font.size", 10);
var n=0;
var distanceToBorder = call("ij.Prefs.get", "magicMontage.label.border.distance", 10);
var cornerPosition = call("ij.Prefs.get", "magicMontage.label.corner", "upper left");
var secondDigitCorrection = 1;
var drawDistructively = call("ij.Prefs.get", "magicMontage.label.draw", false);

macro "Overlay Annotation Tool - C000 T2709A T8709B T1f09C T8f09D" {
    xn = info("xMontage");
    yn = info("yMontage");
    getCursorLoc(x, y, z, flags);
    getDimensions(width, height, channels, slices, frames);
    iw = width/xn;
    ih = height/yn;
    panels = (width/iw) * (height/ih);
    xPanel = floor(x/iw);
    yPanel = floor(y/ih);
    fontsize = (ih*fontSizePercent)/100;
    if (fontsize<12) { 
    	fontsize=12;
    	borderDistance=0;
	}
    if (numbers==1) {labellength = panels; } 
    else {labellength = lengthOf(str);} 
    if (antialiasedLabels==true) labelopt=labelopt+"antialiased";
    setFont(labelfont, fontsize, labelopt);
    	if (color=="white") { r=255; g=255; b=255; }
    	if (color=="black") { r=0; g=0; b=0; }
    	if (color=="red") { r=255; g=0; b=0; }
    	if (color=="green") { r=0; g=255; b=0; }
    	if (color=="blue") { r=0; g=0; b=255; }
    	if (color=="light grey") { r=200; g=200; b=200; }
    	if (color=="dark grey") { r=100; g=100; b=100; }
    	if (color=="magenta") { r=255; g=0; b=255; }
    	if (color=="cyan") { r=0; g=255; b=255; }
    	if (color=="yellow") { r=255; g=255; b=0; }
    setColor(r, g, b);
    //positional definition
    if(cornerPosition=="upper left") {
    	xLabelPosition = (xPanel*iw)+distanceToBorder;
    	yLabelPosition = (yPanel*ih)+distanceToBorder+fontsize;
    } else if (cornerPosition=="upper right") {
    	xLabelPosition = (xPanel*iw)+iw-distanceToBorder-(0.7*fontsize*secondDigitCorrection);
    	yLabelPosition = (yPanel*ih)+distanceToBorder+(1.2*fontsize);
    } else if (cornerPosition=="lower left") {
    	xLabelPosition = (xPanel*iw)+distanceToBorder;
    	yLabelPosition = (yPanel*ih)+ih-distanceToBorder; 
    } else if (cornerPosition=="lower right") {
    	xLabelPosition = (xPanel*iw)+iw-distanceToBorder-(0.7*fontsize*secondDigitCorrection);
    	yLabelPosition = (yPanel*ih)+ih-distanceToBorder; 
    }
    if (numbers==true) {
    	if(drawDistructively==false) {
    		Overlay.drawString(n+1, xLabelPosition, yLabelPosition);
    	} else {
    		drawString(n+1, xLabelPosition, yLabelPosition);
    	}
    		n++; 
    		if(n>8) {
    			secondDigitCorrection = 2;
    		}
    			if (n>=labellength) { n=0; } 
    	}

    else {	
    	letterLabel = substring(str,n,n+1); 
    	if (lcas==1) {letterLabel = toLowerCase(letterLabel);}
    	if(drawDistructively==false) {
    		Overlay.drawString(letterLabel, xLabelPosition, yLabelPosition);
    	} else {
    		 drawString(letterLabel, xLabelPosition, yLabelPosition);
    	}
    	n++; 
    	if (n>=labellength) { n=0; }
    }
    
    Overlay.show();
}

macro "Overlay Annotation Tool Options" {
    if (nImages>0) setupUndo;
    Dialog.create("Annotation - Options");
    Dialog.addString("Labels:",str);
    Dialog.addCheckbox("Use numbers", numbers);
    Dialog.addChoice("Font:",newArray("Arial", "Times New Roman", "SansSerif", "Calibri"), labelfont);
    Dialog.addChoice("Style:", newArray(" ", "bold", "italic", "bold italic"), labelopt);
    Dialog.addChoice("Color:", newArray("white", "black", "red", "green", "blue", "light grey", "dark grey", "magenta", "cyan", "yellow"), color);
    Dialog.addCheckbox("Lowercase labels", lcas);
    Dialog.addCheckbox("Reset label counter",true);
    Dialog.addCheckbox("Antialiased", antialiasedLabels);
    Dialog.addCheckbox("Draw labels (no overlay)", drawDistructively);
    Dialog.addNumber("Font size (% of tile)", fontSizePercent);
    Dialog.addNumber("Distance from border", distanceToBorder);
    Dialog.addChoice("Position", newArray("upper left", "upper right", "lower left", "lower right"), cornerPosition);
    Dialog.show;
    str  = Dialog.getString;
    numbers = Dialog.getCheckbox;
    call("ij.Prefs.set", "magicMontage.label.number", numbers);
    labelfont = Dialog.getChoice;
    call("ij.Prefs.set", "magicMontage.label.font.type", labelfont);
    labelopt = Dialog.getChoice;
    call("ij.Prefs.set", "magicMontage.label.font.style", labelopt);
    color = Dialog.getChoice;
    call("ij.Prefs.set", "magicMontage.label.font.color", color);
    lcas = Dialog.getCheckbox;
    call("ij.Prefs.set", "magicMontage.label.lcas", lcas);
    resetCounter = Dialog.getCheckbox;
    if (resetCounter==true) {
    	n=0;
    }
    antialiasedLabels = Dialog.getCheckbox;
    call("ij.Prefs.set", "magicMontage.label.antialiased", antialiasedLabels);
    drawDistructively = Dialog.getCheckbox;
    call("ij.Prefs.set", "magicMontage.label.draw", drawDistructively);
    fontSizePercent=Dialog.getNumber();
    call("ij.Prefs.set", "magicMontage.label.font.size", fontSizePercent);
    distanceToBorder=Dialog.getNumber();
    call("ij.Prefs.set", "magicMontage.label.border.distance", distanceToBorder);
    cornerPosition=Dialog.getChoice();
    call("ij.Prefs.set", "magicMontage.label.corner", cornerPosition);
}


macro "Scale Bar Action Tool - C000L060bLe6ebL09e9L08e8"{
    doCommand("Scale Bar...");
}

macro "Extract Selected Panels Tool- C888R0077"{
    t=getTitle;
    xn = info("xMontage");
    yn = info("yMontage");
    pw = getWidth/xn;
    ph = getHeight/yn;
    run("Duplicate...", "title=[Extract of "+t+"]");
    setMetadata("xMontage="+getWidth/pw+"\nyMontage="+getHeight/ph+"\n");
}

macro "Montage Sync Tool - C000L48d8L838d" {
    w=getWidth;
    h= getHeight;
    getCursorLoc(x,y,z,flags);
    xn = info("xMontage");
    yn = info("yMontage");
    if ((xn==0)||(yn==0)) {run("Set Montage Layout"); exit;}
    xc = floor(x/(w/xn));
    yc = floor(y/(h/yn));
    x0 = x-xc*w/xn;
    y0 = y-yc*h/yn;
    xp =newArray(xn*yn);
    yp =newArray(xn*yn);
    for (i=0;i<xn;i++) {
        for (j=0;j<yn;j++) {
            xp[j*xn+i] = x0+i*(w/xn);
            yp[j*xn+i] = y0+j*(h/yn);
        }
    }
    makeSelection("point",xp,yp);
}


function info(key) {
  i = getMetadata;
  List.setList(i);
  return List.get(key);
}



function swap(a,b,c,d) {
    setupUndo;
    setBatchMode(true);
    makeRectangle(a*(w/xn),b*(h/yn),(w/xn),(h/yn));
    run("Duplicate...", "title=tmp");
    selectImage(id);
    makeRectangle(c*(w/xn),d*(h/yn),(w/xn),(h/yn));
    run("Copy");
    makeRectangle(a*(w/xn),b*(h/yn),(w/xn),(h/yn));
    run("Paste");
    selectWindow("tmp");
    run("Select All");
    run("Copy");
    selectImage(id);
    makeRectangle(c*(w/xn),d*(h/yn),(w/xn),(h/yn));
    run("Paste");
    run("Select None");
    setBatchMode(false);
}

function spring(x0,y0,x1,y1) {
    d = sqrt((y1-y0)*(y1-y0)+(x1-x0)*(x1-x0));
    step=3;
    r=15;
    xa = newArray(floor(d/step));
    ya = newArray(xa.length);
    for (i=0;i<xa.length;i++) {
        j=i*step;
        xa[i]=x0+j*(x1-x0)/d+sin(j/7)*r;
        ya[i]=y0+j*(y1-y0)/d+cos(j/7)*r;
    }
    if (xa.length>1){
        xa[0]=x0;
        ya[0]=y0;
        xa[xa.length-1]=x1;
        ya[ya.length-1]=y1;
    }
    makeSelection("freeline",xa,ya);
}



macro "Add Panel to Manager [F1]" {
    roiManager("Add");
    setOption("Show All",true);
}

macro "Selected panels to stack [F2]" {
    id=getImageID;
    t=getTitle;
    selectImage(id);
    roiManager("select",0);
    getSelectionBounds(x,y,sw,sh);
    setBatchMode(true);
    newImage("Extracted Panels of "+t, "RGB", sw,sh,roiManager("count"));
    id2=getImageID;
    setPasteMode("copy");
    for (i=0;i<roiManager("count");i++) {
        selectImage(id);
        roiManager("select",i);
        run("Copy");
        selectImage(id2);
        setSlice(i+1);
        run("Paste");
    }
    setBatchMode(false);
}

macro "Crop Montage [F3]" {
    setBatchMode(true);
    setPasteMode("copy");
    w=getWidth;
    h= getHeight;
    b=bitDepth;
    getSelectionBounds(x,y,sw,sh);
    t=getTitle;
    id=getImageID;
    getVoxelSize(xp,yp,zp,unit);
    xn = info("xMontage");
    yn = info("yMontage");
    xc = floor(x/(w/xn));
    yc = floor(y/(h/yn));
    xpa = x-xc*(w/xn);
    ypa= y-yc*(h/yn);
    newImage("Crop of "+t,b+"RGB",sw,sh,(xn)*(yn));
    id2=getImageID;
    for (j=0;j<yn;j++) {
        for (i=0;i<xn;i++) {
            selectImage(id);
            makeRectangle(i*(w/xn)+xpa,j*(h/yn)+ypa,sw,sh);
            run("Copy");
            selectImage(id2);
            setSlice(j*(xn)+i+1);
            run("Paste");
        }
    }
    setVoxelSize(xp,yp,zp,unit);
    setBatchMode(false);
}

macro "Fit Clipboard content into panel [F4]" {
    getSelectionBounds(x,y,sw,sh);
    id=getImageID;
    setBatchMode(true);
    ffp=sw/sh;
    run("Internal Clipboard");
    run("RGB Color");
    ffc=getWidth/getHeight;
    if (ffc>ffp) {
        run("Size...", "width="+sw+" height="+sw/ffc+" constrain interpolation=Bicubic");
        run("Canvas Size...", "width="+sw+" height="+sh+" position=Center zero");
    } else {
        run("Size...", "width="+sh*ffc+" height="+sh+" constrain interpolation=Bicubic");
        run("Canvas Size...", "width="+sw+" height="+sh+" position=Center zero");
    }
    run("Copy");
    close;
    selectImage(id);
    setBatchMode(false);
    setPasteMode("Copy");
    run("Paste");
}

macro "Fill Panel with Clipboard content [F5]" {
    
    getSelectionBounds(x,y,sw,sh);
    id=getImageID;
    setBatchMode(true);
    ffp=sw/sh;
    run("Internal Clipboard");
    run("RGB Color");
    ffc=getWidth/getHeight;
    if (ffc>ffp) {
        run("Size...", "width="+sw*ffc+" height="+sh+" constrain interpolation=Bicubic");
        run("Canvas Size...", "width="+sw+" height="+sh+" position=Center zero");
    } else {
        run("Size...", "width="+sw+" height="+sh/ffc+" constrain interpolation=Bicubic");
        run("Canvas Size...", "width="+sw+" height="+sh+" position=Center zero");
    }
    run("Copy");
    close;
    selectImage(id);
    setBatchMode(false);
    setPasteMode("Copy");
    run("Paste");
    
}

macro "Set Montage Layout [F12]" {
    Dialog.create("Set Montage Layout");
    Dialog.addNumber("Width:", 2);
    Dialog.addNumber("Height:", 2);
    Dialog.show;
    mw = Dialog.getNumber;
    mh = Dialog.getNumber;
    setMetadata("xMontage="+mw+"\nyMontage="+mh+"\n");
}
		

macro "Montage Help" {
Dialog.create("Montage Help");
Dialog.addMessage("Available Functions using Montages: \n \n Add Panel to Manager [F1] \n Selected panels to stack [F2] \n Crop Montage [F3] \n Fit Clipboard content into panel [F4] \n Fill Panel with Clipboard content [F5] \n Set Montage Layout [F12]\n \nOriginally developed by Jerome Mutterer et al.\nAdditional functionality added by Jan Brocher");
Dialog.show();
}



