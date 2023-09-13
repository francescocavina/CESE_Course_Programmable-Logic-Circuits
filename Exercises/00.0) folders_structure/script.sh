# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/sum_1bit.vhd ../sources/sum_1bit_tb.vhd
ghdl -s ../sources/sum_1bit.vhd ../sources/sum_1bit_tb.vhd

# Elaborate and run the testbench
ghdl -e sum_1bit_tb
ghdl -r sum_1bit_tb --vcd=sum_1bit_tb.vcd --stop-time=600ns

# Open the waveform using GTKWave
gtkwave sum_1bit_tb.vcd
