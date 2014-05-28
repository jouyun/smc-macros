importClass(Packages.ij.IJ);
importClass(Packages.ij.ImagePlus);
importClass(Packages.ij.ImageStack);
importClass(Packages.ij.gui.PolygonRoi);
importClass(Packages.ij.plugin.Duplicator);
importClass(Packages.ij.process.FloatPolygon);
importClass(Packages.ij.process.StackConverter);
importClass(Packages.trainableSegmentation.FeatureStack);
importClass(Packages.trainableSegmentation.FeatureStackArray);
importClass(Packages.trainableSegmentation.WekaSegmentation);
 importClass(Packages.ij.plugin.frame.RoiManager); 

var feature_image=WindowManager.getCurrentImage();
//var feature_image=IJ.openImage("/n/projects/smc/public/SMC/WEKA/p53_16h_01/Features.tif");
 
var image = IJ.openImage("/n/projects/smc/public/SMC/WEKA/p53_16h_01/DAPI.tif");
/*if (image.getStackSize() > 1)
        new StackConverter(image).convertToGray32();
else
        image.setProcessor(image.getProcessor().convertToFloat());*/
 
var duplicator = new Duplicator();
 
// process the image into different stacks, one per feature:
 
//var smoothed = duplicator.run(image);
//IJ.run(smoothed, "Gaussian Blur...", "radius=20");
 
//var medianed = duplicator.run(image);
//IJ.run(medianed, "Median...", "radius=10");
 
// add new feature here (1/2)
 
// the FeatureStackArray contains a FeatureStack for every slice in our original image
var featureStackArray = new FeatureStackArray(1, 1, 16, false,
        1, 19, null);
 
// turn the list of stacks into FeatureStack instances, one per original
// slice. Each FeatureStack contains exactly one slice per feature.
        var stack = new ImageStack(image.getWidth(), image.getHeight());
        //stack.addSlice("smoothed", smoothed.getStack().getProcessor(slice));
        //stack.addSlice("medianed", medianed.getStack().getProcessor(slice));
 
        IJ.log("Stacksize "+feature_image.getStackSize());
        for (var i=1; i<=feature_image.getStackSize(); i++)
        {
        	stack.addSlice("Feature"+i, feature_image.getStack().getProcessor(i));
        }
 
        //var feature_img = new ImagePlus("slice 1", stack);
        //featuresImage.show();
        feature_image.show();
        var featureStack = new FeatureStack(stack.getWidth(), stack.getHeight(), false);
        featureStack.setStack(feature_image.getStack());
        //featureStack.show();
        featureStackArray.set(featureStack, 0);
        var enabled=featureStack.getEnabledFeatures();
        featureStackArray.setEnabledFeatures([false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]);
        
 
var wekaSegmentation = new WekaSegmentation(image);
wekaSegmentation.setFeatureStackArray(featureStackArray);

manager = RoiManager.getInstance(); 
manager.runCommand("Open", "/n/projects/smc/public/SMC/WEKA/RealTrain_Edgesonly.zip");
rois = manager.getRoisAsArray(); 
for (i=0; i<5; i++) 
{
    IJ.log(rois[i].getName()+": "+rois[i].getType()); 
    manager.select(i);
    wekaSegmentation.addExample(0,rois[i],1);
}
for (i=5; i<10; i++) 
{
    IJ.log(rois[i].getName()+": "+rois[i].getType()); 
    manager.select(i);
    wekaSegmentation.addExample(1,rois[i],1);
}



 
// train classifier
if (!wekaSegmentation.trainClassifier())
        throw new RuntimeException("Uh oh! No training today.");
 

output=wekaSegmentation.applyClassifier(featureStackArray, 32, true);
output.show();

wekaSegmentation.saveClassifier("/n/projects/smc/public/SMC/WEKA/laplace_structure_deriv.model");