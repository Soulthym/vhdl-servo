#!/bin/bash
ghdl --clean

ghdl -a servo.vhd
ghdl -e servo

ghdl -a servotb.vhd
ghdl -e servotb
ghdl -r servotb --vcd=out.gtk

gtkwave out.gtk
