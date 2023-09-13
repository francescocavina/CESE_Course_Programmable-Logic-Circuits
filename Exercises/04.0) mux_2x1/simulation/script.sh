# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/mux_2x1.vhd ../sources/mux_2x1_tb.vhd
ghdl -s ../sources/mux_2x1.vhd ../sources/mux_2x1_tb.vhd

# Elaborate and run the testbench
ghdl -e mux_2x1_tb
ghdl -r mux_2x1_tb --vcd=mux_2x1_tb.vcd --stop-time=600ns

# Open the waveform using GTKWave
gtkwave mux_2x1_tb.vcd