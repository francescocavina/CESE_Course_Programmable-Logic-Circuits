# Author: Francesco Cavina <francescocvcdavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/floating_point_adder.vhd ../sources/single_floating_point_adder_tb.vhd
ghdl -s ../sources/floating_point_adder.vhd ../sources/single_floating_point_adder_tb.vhd

# Elaborate and run the testbench
ghdl -e single_floating_point_adder_tb
ghdl -r single_floating_point_adder_tb --vcd=single_floating_point_adder_tb.vcd --stop-time=2000ns

# Open the waveform using GTKWave
gtkwave single_floating_point_adder_tb.vcd