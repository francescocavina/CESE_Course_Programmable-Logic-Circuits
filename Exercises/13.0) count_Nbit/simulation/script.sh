 Author: Francesco Cavina <francescocavina98@gmail.com>vcdvhd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/count_Nbit.vhd ../sources/count_Nbit_tb.vhd
ghdl -s ../sources/count_Nbit.vhd ../sources/count_Nbit_tb.vhd

# Elaborate and run the testbench
ghdl -e count_Nbit_tb
ghdl -r count_Nbit_tb --vcd=count_Nbit_tb.vcd --stop-time=11000ns

# Open the waveform using GTKWave
gtkwave count_Nbit_tb.vcd