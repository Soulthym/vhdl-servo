#!/bin/bash
project="servo"
ghdl --clean

ghdl -a $project.vhd 
ghdl -a tb_$project.vhd 

ghdl -c -e tb_$project
ghdl -c -r tb_$project --wave=tb_$project.ghw

gtkwave tb_$project.ghw

rm tb_$project.ghw work-obj93.cf
