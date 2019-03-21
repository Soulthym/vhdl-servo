-- Banc de test pourl'exercice sur les machines � �tat

entity SERVOTB is
	port( OK: out BOOLEAN := TRUE);
end entity;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture A1 of SERVOTB is
	signal clk, rst: STD_LOGIC := '0';
	signal pos : std_logic_vector(7 downto 0);
	signal gpio : STD_LOGIC;

begin

  process
  begin
    while Now < 140 US loop
      clk <= '0';
      wait for 4 nS;
      clk <= '1';
      wait for 4 nS;
    end loop;
    wait;
  end process;

  process
  begin
 	rst <= '1';
	pos <= "00000000";
	wait for 10 nS;
	
	rst <= '0';
	wait for 40 uS;

	pos <= "00001111";
	wait for 40 uS;
	
	pos <= "11111111";
	wait for 40 uS;
	wait;
  
  end process;
  UUT: entity work.SERVO(servo_control) port map (	servo_clk =>clk,
					reset => rst, 
					position => pos,
					gpio_clk_out => gpio);
end;

