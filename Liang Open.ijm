'run("Raw...", "open=[D:\\smc\\SPIM\\05082012 Liang\\out_stop_230roro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=19500 gap=0 little-endian use");
'run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=195 display=Composite");
'rename("0508WT-Membrane");

'run("Raw...", "open=[D:\\smc\\SPIM\\05142012 Liang WT\\out1045ro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=18600 gap=0 little-endian use");
'run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=186 display=Composite");
'rename("0514WT-Centrosome");

'run("Raw...", "open=[D:\\smc\\SPIM\\05222012 Liang WT\\out_all_234frames.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=22800 gap=0 little-endian use");
'run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=228 display=Composite");
'rename("05222012-WT");

'run("Raw...", "open=[D:\\smc\\SPIM\\05232012 Liang 44\\outro_all.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=32000 gap=0 little-endian use");
'run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=320 display=Composite");
'rename("05232012-44");

run("Raw...", "open=[D:\\smc\\SPIM\\05302012 LIA\\05302012 590 LIA\\outro_all.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=23000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=230 display=Composite");
rename("05302012A 590");

run("Raw...", "open=[D:\\smc\\SPIM\\05302012 LIA\\Second WT\\out_stop_230roro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=21000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=210 display=Composite");
rename("05302012B WT");

run("Raw...", "open=[D:\\smc\\SPIM\\05302012 LIA\\Third Dead 590\\out_allro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=26000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=260 display=Composite");
rename("05302012C 590");

run("Raw...", "open=[D:\\smc\\SPIM\\05312012 LIA\\First\\outro_all.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=28700 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=287 display=Composite");
rename("05312012A C Heat shock 2hr44");

run("Raw...", "open=[D:\\smc\\SPIM\\05312012 LIA\\Second\\outro_all.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=22000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=220 display=Composite");
rename("05312012B 590");

run("Raw...", "open=[D:\\smc\\SPIM\\06052012 LIA\\First 440\\outro_all.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=22700 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=227 display=Composite");
rename("06052012A 44");

run("Raw...", "open=[D:\\smc\\SPIM\\06052012 LIA\\Second 440\\out_allro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=34900 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=349 display=Composite");
rename("06052012B 44");



run("Raw...", "open=[D:\\smc\\SPIM\\06062012 LIA 44\\first_ro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=30000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=300 display=Composite");
rename("06062012A 44");

run("Raw...", "open=[D:\\smc\\SPIM\\06062012 LIA 44\\second_ro.raw] image=[16-bit Unsigned] width=1004 height=1002 offset=0 number=30000 gap=0 little-endian use");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=50 frames=300 display=Composite");
rename("06062012B 590");

'run("Bio-Formats Importer", "open=[D:\\smc\\SPIM\\05092012 Liang Mutant\\New Slices\\out_all-z1.tif] color_mode=Default group_files view=Hyperstack stack_order=XYCZT use_virtual_stack axis_1_number_of_images=50 axis_1_axis_first_image=1 axis_1_axis_increment=1 file=[] pattern=[D:\\smc\\SPIM\\05092012 Liang Mutant\\New Slices\\out_all-z<1-50>.tif]");
'run("Enhance Contrast", "saturated=0.35");
'Stack.setChannel(2);
'run("Enhance Contrast", "saturated=0.35");
'run("Channels Tool... ");
'Stack.setDisplayMode("composite");
'rename("0509Mut-Centrosome");

