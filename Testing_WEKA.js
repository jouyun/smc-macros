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
  importClass(Packages.ij.WindowManager); 

var image=WindowManager.getCurrentImage();

//var image = IJ.openImage(System.getProperty("ij.dir") + "/samples/clown.jpg");
if (image.getStackSize() > 1)
        new StackConverter(image).convertToGray32();
else
        image.setProcessor(image.getProcessor().convertToFloat());
 
var duplicator = new Duplicator();
 
// process the image into different stacks, one per feature:
 
var smoothed = duplicator.run(image);
IJ.run(smoothed, "Gaussian Blur...", "radius=20");
 
var medianed = duplicator.run(image);
IJ.run(medianed, "Median...", "radius=10");
 
// add new feature here (1/2)
 
// the FeatureStackArray contains a FeatureStack for every slice in our original image
var featuresArray = new FeatureStackArray(image.getStackSize(), 1, 16, false,
        1, 19, null);
 
// turn the list of stacks into FeatureStack instances, one per original
// slice. Each FeatureStack contains exactly one slice per feature.
for (var slice = 1; slice <= image.getStackSize(); slice++) {
        var stack = new ImageStack(image.getWidth(), image.getHeight());
        stack.addSlice("smoothed", smoothed.getStack().getProcessor(slice));
        stack.addSlice("medianed", medianed.getStack().getProcessor(slice));
 
        // add new feature here (2/2) and do not forget to add it with a
        // unique slice label!
 
        // create empty feature stack
        var features = new FeatureStack( stack.getWidth(), stack.getHeight(), false );
        // set my features to the feature stack
        features.setStack( stack );
        // put my feature stack into the array
        featuresArray.set(features, slice - 1);
        featuresArray.setEnabledFeatures(features.getEnabledFeatures());
}
 
var wekaSegmentation = new WekaSegmentation(image);
wekaSegmentation.setFeatureStackArray(featuresArray);
 
// set examples for class 1 (= foreground) and 0 (= background))
function addExample(classNum, slice, xArray, yArray) {
        var polygon = new FloatPolygon(xArray, yArray);
        var roi = new PolygonRoi(polygon, PolygonRoi.FREELINE);
        IJ.log("roi: " + roi);
        wekaSegmentation.addExample(classNum, roi, slice);
}
 
/*
 * generate these with the macro:
 
        getSelectionCoordinates(x, y);
 
        print('['); Array.print(x); print('],");
        print('['); Array.print(y); print(']");
 */
addExample(1, 1,
        [ 82,85,85,86,87,87,87,88,88,88,88,88,88,88,88,86,86,84,83,82,81,
          80,80,78,76,75,74,74,73,72,71,70,70,68,65,63,62,60,58,57,55,55,
          54,53,51,50,49,49,49,51,52,53,54,55,55,56,56 ],
        [ 141,137,136,134,133,132,130,129,128,127,126,125,124,123,122,121,
          120,119,118,118,116,116,115,115,114,114,113,112,111,111,111,111,
          110,110,110,110,111,112,113,114,114,115,116,117,118,119,119,120,
          121,123,125,126,128,128,129,129,130 ]
);
addExample(0, 1,
        [ 167,165,163,161,158,157,157,157,157,157,157,157,158 ],
        [ 30,29,29,29,29,29,28,26,25,24,23,22,21 ]
);
 
// train classifier
if (!wekaSegmentation.trainClassifier())
        throw new RuntimeException("Uh oh! No training today.");
 
output = wekaSegmentation.applyClassifier(image);
output.show();