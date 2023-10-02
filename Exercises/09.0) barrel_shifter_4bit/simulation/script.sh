# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/mux_Nx1_1bit.vhd ../sources/barrel_shifter_4bit.vhd ../sources/barrel_shifter_4bit_tb.vhd
ghdl -s ../sources/mux_Nx1_1bit.vhd ../sources/barrel_shifter_4bit.vhd ../sources/barrel_shifter_4bit_tb.vhd

# Elaborate and run the testbench
ghdl -e barrel_shifter_4bit_tb
ghdl -r barrel_shifter_4bit_tb --vcd=barrel_shifter_4bit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave barrel_shifter_4bit_tb.vcd