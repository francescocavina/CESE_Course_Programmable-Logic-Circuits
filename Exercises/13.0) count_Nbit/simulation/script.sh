 Author: Francesco Cavina <francescocavina98@gmail.com>vcdvhd

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/cont_Nbit.vhd ../sources/cont_Nbit_tb.vhd
ghdl -s ../sources/cont_Nbit.vhd ../sources/cont_Nbit_tb.vhd

# Elaborate and run the testbench
ghdl -e cont_Nbit_tb
ghdl -r cont_Nbit_tb --vcd=cont_Nbit_tb.vcd --stop-time=11000ns

# Open the waveform using GTKWave
gtkwave cont_Nbit_tb.vcd