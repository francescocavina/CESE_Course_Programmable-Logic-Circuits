# Author: Francesco Cavina <francescocavina98@gmail.com>

#! /bin/bash

# Compile the VHDL files
ghdl -a ../sources/ffd.vhd ../sources/ffd_tb.vhd
ghdl -s ../sources/ffd.vhd ../sources/ffd_tb.vhd

# Elaborate and run the testbench
ghdl -e ffd_tb
ghdl -r ffd_tb --vcd=ffd_tb.vcd --stop-time=1000ns

# Open the waveform using GTKWave
gtkwave ffd_tb.vcd