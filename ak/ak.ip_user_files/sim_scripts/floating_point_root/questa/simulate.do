onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib floating_point_root_opt

do {wave.do}

view wave
view structure
view signals

do {floating_point_root.udo}

run -all

quit -force
