# Author: Francesco Cavina <francescocavina98@gmail.com>vcd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/ffd.vhd ../sources/reg_Nbit.vhd ../sources/reg_Nbit_tb.vhd
ghdl -s ../sources/ffd.vhd ../sources/reg_Nbit.vhd ../sources/reg_Nbit_tb.vhd

# Elaborate and run the testbench
ghdl -e reg_Nbit_tb
ghdl -r reg_Nbit_tb --vcd=reg_Nbit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave reg_Nbit_tb.vcd