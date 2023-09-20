# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/count_4bit.vhd ../sources/count_4bit_tb.vhd
ghdl -s ../sources/count_4bit.vhd ../sources/count_4bit_tb.vhd

# Elaborate and run the testbench
ghdl -e count_4bit_tb
ghdl -r count_4bit_tb --vcd=count_4bit_tb.vcd --stop-time=11000ns

# Open the waveform using GTKWave
gtkwave count_4bit_tb.vcd