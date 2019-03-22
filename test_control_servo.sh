#!/bin/bash
project="servo"

ghdl --clean

case $1 in 
    llvm)
        ghdl -a $project.vhd 
        ghdl -a tb_$project.vhd 

        ghdl -c -e tb_$project
        ghdl -c -r tb_$project --wave=tb_$project.ghw

        gtkwave tb_$project.ghw
        ;;
    mcode)
        ghdl -a $project.vhd
        ghdl -e $project

        ghdl -a tb_$project.vhd
        ghdl -e tb_$project
        ghdl -r tb_$project --wave=tb_$project.ghw

        gtkwave tb_$project.ghw
        ;;
esac

rm tb_$project.ghw work-obj93.cf
