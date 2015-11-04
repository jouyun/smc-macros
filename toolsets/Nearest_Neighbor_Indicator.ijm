//-------------------------------------------------------------------------------------------------------
//Nearest Neighbor Indicator developed by Jan Brocher / BioVoxxel 2013
//first release (v0.1) 28.05.2013
//NO WARRANTY OF FUNCTIONALITY AND NO LIABILITY FOR ANY DAMAGES CAUSED ON FILES, SOFT- OR HARDWARE
//License: GPL v3.0
//-------------------------------------------------------------------------------------------------------

macro "Nearest Neighbor Tool - C00cDc6CfffD00D01D02D03D04D05D06D07D08D0cD0dD0eD0fD10D11D12D13D14D1cD1dD1eD1fD20D21D22D23D24D2cD2dD2eD2fD30D31D32D33D34D3cD3dD3eD3fD40D41D42D43D44D4aD4bD4cD4dD4eD4fD50D51D52D53D57D58D59D5aD5bD5eD5fD60D61D6aD6fD70D7fD80D86D8fD90D91D94D95D96D9aD9fDa0Da1Da6Da9DaaDabDacDadDaeDafDb0Db1Db8Db9DbcDbdDbeDbfDc0Dc1Dc8DcdDceDcfDd0Dd1Dd2Dd3Dd7DdeDdfDe0De1De2De3De4De7DeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8DfdDfeDffC00dD36Ccc0D66CeddD69Cc00D89C11dDb5C77bDc3CffeD49C44aDfbC00fD26D27D28D29D7cD7dDb3Db4Dc5DdaDdbDeaDebCbb2D82CeedD71C55aD2bCaadD16Da2CaacD6eCfffDb7DbaDbbDddDe6DedC00cD37Dd5C00fD2aD8cCee0D74CeeeD93Da5Ce11D78C22dDcaC77bD9cCfffD0bD15D54Da7De8C55aD8eCab8D76CeeeD5dC55cDa4CdddDf9CddcD7aCfffD92C22bDecC00eD19D1aD6cD8dCbb2D75CddeD9bDc2Cf00D88C22eDa3DcbC88bD9dCeefD45D85Dd8C55aDd6Caa6D84CeeeD48D9eDe5C66bDb6Dd4CcceD09CbbcDfcC22cDdcDe9Cff0D65D73CddeD5cCa66D99C44eD7bC99dD6bDc9C55cD35Cdd7D56CeeeDa8C55dD25CdddD47D67CddcD8aC11cD38C00eDc4CeedD3bDc7Cc00D79D98C00eDd9C77bDccDfaCdd5D64C66bD1bCaadD0aCee0D72Cd33D87C88dD17C44bD7eCdaaD77C66cD8bDb2CeecD62C22bD39Ccc1D83C55aD3aCdd7D55CccdD46C11dD6dCc44D97C55dD18CeeaD63CfeeD68CeedD81"{

	run("Options...", "iterations=1 count=1 black edm=Overwrite do=Nothing");
	run("Wand Tool...", "mode=Legacy tolerance=0");
	setFont("user");
	fontSize=getValue("font.size");
	leftButton=16;
	min=0;
	x2=-1; 
	y2=-1; 
	z2=-1; 
	flags2=-1;
	original=getTitle();
	getLocationAndSize(posX, posY, imgWidth, imgHeight);
	getCursorLoc(x, y, z, flags);
			
	if (x!=x2 || y!=y2 || z!=z2 || flags!=flags2) {
		if (flags&leftButton==16) {
			setBatchMode(true);
			if(isOpen("output")) {
				close("output");
			}
			selectWindow(original);
			run("Select All");
			run("Copy");
			run("Select None");
			run("Duplicate...", "title=voronoi");
			voronoi=getTitle();
			run("Voronoi");
			//create a mask for particle selection
			run("Duplicate...", "title=output");
			mask=getTitle();
			setThreshold(1, 255);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Invert");
			run("Duplicate...", "title=nearestNeighbor");
			nearestNeighbor=getTitle();
			//select neighbors of POI
			selectWindow(mask);
			setForegroundColor(255, 255, 255);
			doWand(x, y);
			run("Enlarge...", "enlarge=2 pixel");
			run("Fill");
			run("RGB Color");
			setForegroundColor(0, 0, 255);
			doWand(x, y);
			run("Fill");
			//find nearest neighbor 
			selectWindow(voronoi);
			run("Restore Selection");
			run("Clear Outside");
			getHistogram(values, counts, 256);
			for(i=0; i<255; i++) {
				if(values[i]>0 && counts[i]!=0) {
					min=values[i];
					i=256;
				}
			}
			setThreshold(min, min);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Dilate");
			run("Select All");
			run("Copy");
			selectWindow(nearestNeighbor);
			setPasteMode("Add");
			run("Select All");
			run("Paste");
			doWand(x, y);
			selectWindow(mask);
			run("Restore Selection");
			setForegroundColor(255, 255, 0);
			run("Fill");
			selectWindow(original);
			run("Select All");
			run("Copy");
			selectWindow(mask);
			run("Select All");
			setPasteMode("Transparent-white");
			run("Paste");
			//color selected particle (POI)
			setForegroundColor(255, 0, 0);
			doWand(x, y);
			run("Fill");
			setBatchMode(false);
			//Overlay.drawString("Nearest Neighbor Distance: "+(2*min)+" pixel", 5, 5+fontSize);
			//Overlay.show;
			setLocation(posX+imgWidth, posY);
			
		}
	}
	x2=x; y2=y; z2=z; flags2=flags;
	setForegroundColor(255, 255, 255);
	setBackgroundColor(0, 0, 0);
}

/*
macro "Nearest Neighbor Tool Options" {
   Dialog.create("Nearest Neighbor Options");
   	Dialog.addCheckbox("", false);
   	Dialog.show();
   	xxx=Dialog.getCheckbox();
}
*/
