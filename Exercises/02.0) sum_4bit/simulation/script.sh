# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a -fsynopsys ../sources/sum_Nbit.vhd ../sources/sum_4bit_tb.vhd
ghdl -s -fsynopsys ../sources/sum_Nbit.vhd ../sources/sum_4bit_tb.vhd

# Elaborate and run the testbench
ghdl -e sum_4bit_tb
ghdl -r sum_4bit_tb --vcd=sum_4bit_tb.vcd --stop-time=600ns

# Open the waveform using GTKWave
gtkwave sum_4bit_tb.vcd