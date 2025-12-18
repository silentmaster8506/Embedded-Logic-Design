onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fp_add1p_opt

do {wave.do}

view wave
view structure
view signals

do {fp_add1p.udo}

run -all

quit -force
