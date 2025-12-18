onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Lab_8bd_opt

do {wave.do}

view wave
view structure
view signals

do {Lab_8bd.udo}

run -all

quit -force
