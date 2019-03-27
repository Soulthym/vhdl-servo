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
    while Now < 50 mS loop
      clk <= '0';
      wait for 2 nS;
      clk <= '1';
      wait for 2 nS;
    end loop;
    wait;
  end process;

  process
   begin
     rst <= '1';
    wait for 10 mS;

    rst <= '0';
    pos <= "00000000";
    wait for 10 mS;
    
    pos <= "00001111";
    wait for 10 mS;
    
    pos <= "11111111";
    wait for 10 mS;
    wait;
  
  end process;
  UUT: entity work.SERVO(servo_control)
      generic map ( clkcnt => 2 )
      port map (    
              Clk => clk,
            rst => rst, 
            pos => pos,
            gpio => gpio
        ) ;
end;
