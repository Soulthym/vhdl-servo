-- tb_bcd_counter
-- ---------------------------------------------------
--  Test Bench for BCD Counter entity
-- ---------------------------------------------------
-- Self testing but not exhaustive...
-- Counts at 500 Hz so simulation is fast.
-- Note : must compile in VHDL '93 or 2001.

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity tb_uart_get is
end;

architecture TEST of tb_uart_get is

constant Period : time := 1 us; -- speed up simulation with a 100kHz clock

signal CLK      : std_logic := '0';
signal RST      : std_logic := '1';
signal SerialIn     : std_logic := '0';
signal ReadByte     : std_logic_vector(7 downto 0) := "00000000";
signal Done : boolean;

begin

-- System Inputs
CLK <= '0' when Done else not CLK after Period / 2;
RST <= '1', '0' after Period;

UUT : entity work.uart_get
generic map ( NClkPerBit => 10)
port map ( CLK      => CLK,
           RST      => RST,
           SerialIn => SerialIn,
           ReadByte => ReadByte
         );

-- Control Simulation and check outputs
process begin
    SerialIn <= 'U'; --start bit
    Rst <= '1';
    wait for 1 us;
    Rst <= '0';
    wait for 10 us;

    SerialIn <= '0'; --start bit
    wait for 10 us;

    SerialIn <= '1';
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;
    SerialIn <= '1';
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;
    SerialIn <= '1';
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;
    SerialIn <= '1';
    wait for 10 us;

    SerialIn <= '1';
    wait for 100 us;

    report "Checking output (should be 99).";
    assert ReadByte="10100101" report "Error on READ" severity warning;

    report "End of test. Verify that no error was reported.";
    Done <= true;
    wait;
end process;

end;
