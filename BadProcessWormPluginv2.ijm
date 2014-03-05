run("test calling");
selectWindow("WormMask");
run("Find Connected Regions", "allow_diagonal display_one_image regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
selectWindow("WormMask");
run("Invert");
run("Analyze Particles...", "size=100000-840000 circularity=0.00-1.00 show=Nothing display exclude clear");
selectWindow("WormMask");

