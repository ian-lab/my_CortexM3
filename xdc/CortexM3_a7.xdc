#---------------------------------系统时钟--------------------------------------
create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports CLK50m]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS15} [get_ports CLK50m]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK50m]

#-----------------------------------UART----------------------------------------
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports RXD]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports TXD]

#-----------------------------------LED-----------------------------------------
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS15} [get_ports {ledNumOut[0]}]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS15} [get_ports {ledNumOut[1]}]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS15} [get_ports {ledNumOut[2]}]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS15} [get_ports {ledNumOut[3]}]

#----------------------------------按键-----------------------------------------
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS15} [get_ports RSTn]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS15} [get_ports KEY]

#-----------------------------------DEGUG-----------------------------------------
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports SWDIO]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports SWCLK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SWCLK]

#----------------------------------CAMERA-----------------------------------------
create_clock -period 40.000 -name cmos_pclk [get_ports cam_pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cam_pclk_IBUF]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports cam_pclk]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports cam_rst_n]
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports cam_pwdn]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[0]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[1]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[2]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[3]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[4]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[5]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[6]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {cam_data[7]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports cam_vsync]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports cam_href]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports cam_scl]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports cam_sda]

#----------------------------------hdmi-----------------------------------------
set_property PACKAGE_PIN J22 [get_ports {tmds_data_p[0]}]
set_property PACKAGE_PIN K21 [get_ports {tmds_data_p[1]}]
set_property PACKAGE_PIN H20 [get_ports {tmds_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[0]}]
set_property PACKAGE_PIN J20 [get_ports tmds_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_p]




