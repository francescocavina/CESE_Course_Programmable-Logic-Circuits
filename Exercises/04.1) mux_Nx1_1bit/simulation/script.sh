# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/mux_Nx1_1bit.vhd ../sources/mux_Nx1_1bit_tb.vhd
ghdl -s ../sources/mux_Nx1_1bit.vhd ../sources/mux_Nx1_1bit_tb.vhd

# Elaborate and run the testbench
ghdl -e mux_Nx1_1bit_tb
ghdl -r mux_Nx1_1bit_tb --vcd=mux_Nx1_1bit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave mux_Nx1_1bit_tb.vcd