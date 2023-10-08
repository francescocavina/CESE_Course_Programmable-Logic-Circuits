# Author: Francesco Cavina <francescocvcdavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/floating_point_adder.vhd ../sources/double_floating_point_adder_tb.vhd
ghdl -s ../sources/floating_point_adder.vhd ../sources/double_floating_point_adder_tb.vhd

# Elaborate and run the testbench
ghdl -e double_floating_point_adder_tb
ghdl -r double_floating_point_adder_tb --vcd=double_floating_point_adder_tb.vcd --stop-time=2000ns

# Open the waveform using GTKWave
gtkwave double_floating_point_adder_tb.vcd