set_property IOSTANDARD LVCMOS33 [get_ports TXD]
set_property IOSTANDARD LVCMOS33 [get_ports RXD]

set_property IOSTANDARD LVCMOS33 [get_ports SWDIO]
set_property IOSTANDARD LVCMOS33 [get_ports SWCLK]

set_property IOSTANDARD LVCMOS33 [get_ports RSTn]
set_property IOSTANDARD LVCMOS33 [get_ports KEY]

set_property IOSTANDARD LVCMOS33 [get_ports {ledNumOut[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledNumOut[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledNumOut[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledNumOut[0]}]

set_property PACKAGE_PIN N18 [get_ports TXD]
set_property PACKAGE_PIN P19 [get_ports RXD]

set_property PACKAGE_PIN K18 [get_ports SWDIO]
set_property PACKAGE_PIN H15 [get_ports SWCLK]

set_property PACKAGE_PIN M19 [get_ports RSTn]
set_property PACKAGE_PIN F16 [get_ports KEY]


set_property PACKAGE_PIN M15 [get_ports {ledNumOut[3]}]
set_property PACKAGE_PIN G14 [get_ports {ledNumOut[2]}]
set_property PACKAGE_PIN M17 [get_ports {ledNumOut[1]}]
set_property PACKAGE_PIN G15 [get_ports {ledNumOut[0]}]


create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports CLK50m]
set_property IOSTANDARD LVCMOS33 [get_ports CLK50m]
set_property PACKAGE_PIN K17 [get_ports CLK50m]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SWCLK]




