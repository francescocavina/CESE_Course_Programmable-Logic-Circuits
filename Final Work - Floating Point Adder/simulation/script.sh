# Author: Francesco Cavina <francescocvcdavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/floating_point_adder.vhd ../sources/floating_point_adder_tb.vhd
ghdl -s ../sources/floating_point_adder.vhd ../sources/floating_point_adder_tb.vhd

# Elaborate and run the testbench
ghdl -e floating_point_adder_tb
ghdl -r floating_point_adder_tb --vcd=floating_point_adder_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave floating_point_adder_tb.vcd