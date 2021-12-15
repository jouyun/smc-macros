from register_virtual_stack import Register_Virtual_Stack_MT
from register_virtual_stack import Transform_Virtual_Stack_MT
import os
from ij import IJ, ImagePlus, WindowManager

temp_dir =IJ.getDirectory("temp")
IJ.log(temp_dir)

imp = WindowManager.getCurrentImage()

cslice = imp.getFrame()
channel = imp.getChannel()
print(type(cslice))
IJ.log(str(cslice))

# source directory
source_dir = temp_dir + '/Source/'
# output directory
target_dir = temp_dir + '/Target/'
# transforms directory
transf_dir = temp_dir + '/Transforms/'
# reference image
reference_name = "Tiffs"+str(cslice).zfill(4)+".tif"
# shrinkage option (false)
use_shrinking_constraint = 0
if not os.path.exists(source_dir):
    os.makedirs(source_dir)
if not os.path.exists(target_dir):
    os.makedirs(target_dir)    
if not os.path.exists(transf_dir):
    os.makedirs(transf_dir)



lst = os.listdir(source_dir)
for f in lst:
	os.remove(source_dir+'/'+f)
lst = os.listdir(transf_dir)
for f in lst:
	os.remove(transf_dir+'/'+f)	
lst = os.listdir(target_dir)
for f in lst:
	os.remove(target_dir+'/'+f)


IJ.run("Duplicate...", "duplicate channels="+str(channel));
IJ.run("Image Sequence... ", "dir="+source_dir+" format=TIFF, name=Tiffs");

lst = os.listdir(source_dir)
for f in lst:
	os.rename(source_dir+'/'+f, source_dir+'/'+f[0:-6])


p = Register_Virtual_Stack_MT.Param()
#p.registrationModelIndex=5

Register_Virtual_Stack_MT.exec(source_dir, target_dir, transf_dir, 
reference_name, p, use_shrinking_constraint)

WindowManager.getCurrentImage().setTitle("Orig")

lst = os.listdir(source_dir)
for f in lst:
	os.remove(source_dir+'/'+f)
IJ.log(imp.getTitle())

IJ.selectWindow(imp.getTitle())
nchannels = imp.getNChannels()

merge_string = ""

for i in range(1,nchannels+1):
	IJ.selectWindow(imp.getTitle())
	IJ.run("Duplicate...", "duplicate channels="+str(i));
	IJ.run("Image Sequence... ", "dir="+source_dir+" format=TIFF, name=Tiffs");
	
	lst = os.listdir(source_dir)
	for f in lst:
		os.rename(source_dir+'/'+f, source_dir+'/'+f[0:-6])

	Transform_Virtual_Stack_MT.exec(source_dir, target_dir, transf_dir, True)
	WindowManager.getCurrentImage().setTitle("Ch"+str(i))
	IJ.run("Duplicate...", "title=CH"+str(i)+" duplicate");
	
	lst = os.listdir(source_dir)
	for f in lst:
		os.remove(source_dir+'/'+f)
	merge_string = merge_string+"c"+str(i)+"=CH"+str(i)+" "

IJ.log(merge_string)
IJ.run("Merge Channels...", merge_string+"create")