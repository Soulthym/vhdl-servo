#for file in $(ls *.vhd); do
#    ghdl -a uart_get.vhd 
#done
ghdl -a uart_get.vhd 
ghdl -a tb_uart_get.vhd 

ghdl -c -e tb_uart_get
ghdl -c -r tb_uart_get --wave=tb_uart_get.ghw
gtkwave tb_uart_get.ghw
