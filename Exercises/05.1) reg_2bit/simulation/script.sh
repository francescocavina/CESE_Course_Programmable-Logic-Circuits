# Author: Francesco Cavina <francescocavina98@gmail.com>vcd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/ffd.vhd ../sources/reg_2bit.vhd ../sources/reg_2bit_tb.vhd
ghdl -s ../sources/ffd.vhd ../sources/reg_2bit.vhd ../sources/reg_2bit_tb.vhd

# Elaborate and run the testbench
ghdl -e reg_2bit_tb
ghdl -r reg_2bit_tb --vcd=reg_2bit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave reg_2bit_tb.vcd