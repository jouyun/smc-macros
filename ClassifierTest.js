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
importClass(Packages.ij.WindowManager); 

IJ.run("MultiThread Test");
var feature_image=WindowManager.getCurrentImage();
 
var duplicator = new Duplicator();
var featureStackArray = new FeatureStackArray(1, 1, 16, false,
        1, 19, null);
 
        var stack = new ImageStack(feature_image.getWidth(), feature_image.getHeight());
 
        for (var i=1; i<=feature_image.getStackSize(); i++)
        {
        	stack.addSlice("Feature"+i, feature_image.getStack().getProcessor(i));
        }
 
        var featureStack = new FeatureStack(stack.getWidth(), stack.getHeight(), false);
        featureStack.setStack(feature_image.getStack());
        featureStackArray.set(featureStack, 0);
        var enabled=featureStack.getEnabledFeatures();
        featureStackArray.setEnabledFeatures([false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]);
        
 
var wekaSegmentation = new WekaSegmentation(feature_image);
//wekaSegmentation.setFeatureStackArray(featureStackArray);
wekaSegmentation.loadClassifier("D:\\SMC\\laplace_structure_deriv2.model");

 
output=wekaSegmentation.applyClassifier(featureStackArray, 32, true);
output.show();

