LIBRARY ieee;
USE ieee.std_logic_1164.all; 
ENTITY MAIN is
	PORT
	(
		Clk		:  IN  STD_LOGIC;
		KEY		:  IN  STD_LOGIC;
		SW 		:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		DataServo:	OUT STD_LOGIC
	);
END entity;

ARCHITECTURE RTL OF MAIN IS 
	signal rst: std_logic;
	signal data : std_logic_vector(7 downto 0);
BEGIN 
	rst <= not KEY;
	data(0) <= SW(0);
	data(1) <= SW(1);
	data(2) <= SW(2);
	data(3) <= SW(3);
	data(4) <= SW(4);
	data(5) <= SW(5);
	data(6) <= SW(6);
	data(7) <= SW(7);

SERVO: entity work.servo 
	generic map(clkcnt => 195)
	port map(CLK => clk, RST => rst, pos => data, gpio => DataServo);
END architecture;
