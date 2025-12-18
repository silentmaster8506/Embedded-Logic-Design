onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib bd_fft_opt

do {wave.do}

view wave
view structure
view signals

do {bd_fft.udo}

run -all

quit -force
