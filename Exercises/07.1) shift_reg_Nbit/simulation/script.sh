# Author: Francesco Cavina <francescocavina98@gmail.com>vcdvhd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/shift_reg_Nbit.vhd ../sources/shift_reg_Nbit_tb.vhd
ghdl -s ../sources/shift_reg_Nbit.vhd ../sources/shift_reg_Nbit_tb.vhd

# Elaborate and run the testbench
ghdl -e shift_reg_Nbit_tb
ghdl -r shift_reg_Nbit_tb --vcd=shift_reg_Nbit_tb.vcd --stop-time=3000ns

# Open the waveform using GTKWave
gtkwave shift_reg_Nbit_tb.vcd