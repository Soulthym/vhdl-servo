
LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity tb_uart_get is
end;

architecture TEST of tb_uart_get is

constant Period : time := 1 us;

signal CLK      : std_logic := '0';
signal RST      : std_logic := '1';
signal SerialIn     : std_logic := '0';
signal ReadByte     : std_logic_vector(7 downto 0) := "00000000";
signal Done : boolean;
signal OK : boolean;

begin

CLK <= '0' when Done else not CLK after Period / 2;
RST <= '1', '0' after Period;

UUT : entity work.uart_get
generic map ( NClkPerBit => 10)
port map ( CLK      => CLK,
           RST      => RST,
           SerialIn => SerialIn,
           ReadByte => ReadByte
         );

process begin
    Ok <= true;
    SerialIn <= '1'; --Idle bit set to 1
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
    wait for 10 us;

    report "Checking output (should be A5 or 0_10100101_1).";
    assert ReadByte="10100101" report "Error on READ" severity warning;
    if ReadByte /= "10100101" then Ok <= false; 
    end if;
    wait for 100 us;

    SerialIn <= '0'; --start bit
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
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;
    SerialIn <= '1';
    wait for 10 us;
    SerialIn <= '0';
    wait for 10 us;

    SerialIn <= '1';
    wait for 10 us;

    report "Checking output (should be A5 or 0_10100101_1).";
    assert ReadByte="01011010" report "Error on READ" severity warning;
    if ReadByte /= "01011010" then Ok <= false; 
    end if;
    wait for 100 us;
    report "End of test. Verify that no error was reported.";
    Done <= true;
    wait;
end process;

end;
