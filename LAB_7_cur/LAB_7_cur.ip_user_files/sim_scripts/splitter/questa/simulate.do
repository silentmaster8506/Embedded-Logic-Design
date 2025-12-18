onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib splitter_opt

do {wave.do}

view wave
view structure
view signals

do {splitter.udo}

run -all

quit -force
