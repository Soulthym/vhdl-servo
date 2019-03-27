-- Banc de test pourl'exercice sur les machines à état

entity TB_SERVO is
    port( OK: out BOOLEAN := TRUE);
end entity;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

architecture A1 of TB_SERVO is
    signal clk, rst: STD_LOGIC := '0';
    signal pos : std_logic_vector(7 downto 0);
    signal gpio : STD_LOGIC;
begin

    process
    begin
        while Now < 100 mS loop -- 50Mhz Clock
            clk <= '0';
            wait for 10 nS;
            clk <= '1';
            wait for 10 nS;
        end loop;
        wait;
    end process;

    process
    begin
        rst <= '1';
        wait for 100 nS;
        rst <= '0';
        pos <= "00000000";
        wait for 20 mS;
    
        pos <= "00001111";
        wait for 20 mS;
    
        pos <= "11111111";
        wait for 20 mS;
        wait;
  
    end process;
    UUT: entity work.SERVO(servo_control)
        generic map ( clkcnt => 195 )
        port map (    
              Clk => clk,
              rst => rst, 
              pos => pos,
              gpio => gpio
        );
end;
