-makelib ies_lib/xil_defaultlib -sv \
  "C:/software/xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/software/xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CortexM3.srcs/sources_1/ip/video_clk/video_clk_clk_wiz.v" \
  "../../../../CortexM3.srcs/sources_1/ip/video_clk/video_clk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

