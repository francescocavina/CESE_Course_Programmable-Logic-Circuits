# Author: Francesco Cavina <francescocavina98@gmail.com>vcdvhd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/ffd.vhd ../sources/reg_Nbit.vhd ../sources/cont_4bit.vhd ../sources/cont_4bit_tb.vhd
ghdl -s ../sources/ffd.vhd ../sources/reg_Nbit.vhd ../sources/cont_4bit.vhd ../sources/cont_4bit_tb.vhd

# Elaborate and run the testbench
ghdl -e cont_4bit_tb
ghdl -r cont_4bit_tb --vcd=cont_4bit_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave cont_4bit_tb.vcd