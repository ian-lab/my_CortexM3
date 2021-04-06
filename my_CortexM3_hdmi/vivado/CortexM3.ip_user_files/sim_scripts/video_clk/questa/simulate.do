onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib video_clk_opt

do {wave.do}

view wave
view structure
view signals

do {video_clk.udo}

run -all

quit -force
