border_size=20;

open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish3-BxD 48hpf di-pERK1-2-singleslice_Stitch2.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish3-BxD 48hpf di-pERK1-2-singleslice_Stitch.zip.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");

open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish6-BxD 48hpf di-pERK1-2_Stitch-singleslice.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish6-BxD 48hpf di-pERK1-2_Stitch.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");



open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish7-BxD 48hpf di-pERK1-2_Stitch.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish7-BxD 48hpf di-pERK1-2_Stitch.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");

//open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish6-BxD 48hpf di-pERK1-2_Stitch-singleslice.tif");
//open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 48hpf di-pERK1-1/For figure/SMC/Fish6-BxD 48hpf di-pERK1-2_Stitch.roi");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish4 - BxD 2Double 5dpf di-pERK1-2_Stitch_SMC.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish4 - BxD 2Double 5dpf di-pERK1-2_Stitch_SMC.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");




open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish6 - BxD 2Double 5dpf di-pERK1-2_Stitch.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish6 - BxD 2Double 5dpf di-pERK1-2_Stitch.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");

open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish10 - BxD Double 5dpf di-pERK1-2_Stitch.tif");
run("32-bit");
open("/n/projects/smc/public/MVG/pERK quantification/Time course - BxD di-pERK1-2/BxD 5dpf di-pERK1-2/For figure/SMC/Fish10 - BxD Double 5dpf di-pERK1-2_Stitch.roi");
roiManager("Add");
run("Compare ROI To Border", "border="+border_size);
close();
roiManager("Select", 0);
roiManager("Delete");
