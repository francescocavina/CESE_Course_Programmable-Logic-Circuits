# Author: Francesco Cavina <francescocavina98@gmail.com>vcdvhd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/barrel_shifter_Nbit.vhd ../sources/barrel_shifter_Nbit_tb.vhd
ghdl -s ../sources/barrel_shifter_Nbit.vhd ../sources/barrel_shifter_Nbit_tb.vhd

# Elaborate and run the testbench
ghdl -e barrel_shifter_Nbit_tb
ghdl -r barrel_shifter_Nbit_tb --vcd=barrel_shifter_Nbit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave barrel_shifter_Nbit_tb.vcd