onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fft_8pt_bd_opt

do {wave.do}

view wave
view structure
view signals

do {fft_8pt_bd.udo}

run -all

quit -force
