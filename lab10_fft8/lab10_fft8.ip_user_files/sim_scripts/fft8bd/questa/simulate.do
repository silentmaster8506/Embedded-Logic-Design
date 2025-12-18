onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fft8bd_opt

do {wave.do}

view wave
view structure
view signals

do {fft8bd.udo}

run -all

quit -force
