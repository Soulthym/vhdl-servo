library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_get is
    generic (
        NClkPerBit : integer := 115
        );
    port (
        Rst          : in  std_logic;
        Clk          : in  std_logic;
        SerialIn     : in  std_logic;
        ReadByte     : out std_logic_vector(7 downto 0)
        );
end uart_get;


architecture rtl of uart_get is

    type States is (SIdle, SReadStart, SReadData,
                     SReadStop);
    signal State : States := SIdle;
    signal ReadData : std_logic := '0';

    signal ClkCnt : integer range 0 to NClkPerBit-1 := 0;
    signal BitIdx : integer range 0 to 7 := 0;  -- 8 Bits Total
    signal sReadByte : std_logic_vector(7 downto 0) := (others => '0');

begin

    puart_get : process (Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                State <= SIdle;
            else
                case State is
                    when SIdle =>
                        ClkCnt <= 0;
                        BitIdx <= 0;
                        if SerialIn = '0' then
                            State <= SReadStart;
                        end if;
                    when SReadStart =>
                        if ClkCnt = (NClkPerBit-1)/2 then
                            if SerialIn = '0' then
                                ClkCnt <= 0;
                                BitIdx <= 0;
                                State <= SReadData;
                            end if;
                        else
                            ClkCnt <= ClkCnt + 1;
                        end if;

                    when SReadData =>
                        if ClkCnt < NClkPerBit-1 then
                            ClkCnt <= ClkCnt + 1;
                        else
                            ClkCnt <= 0;
                            sReadByte(BitIdx) <= SerialIn;
                            if BitIdx < 7 then
                                BitIdx <= BitIdx +1;
                            else
                                BitIdx <= 0;
                                State <= SReadStop;
                            end if;
                        end if;

                    when SReadStop =>
                        if ClkCnt < NClkPerBit-1 then
                            ClkCnt <= ClkCnt +1;
                        else
                            ClkCnt <= 0;
                            State <= SIdle;
                        end if;

                    when others =>
                        State <= SIdle;
                end case;
            end if;
        end if;
    end process puart_get;
    ReadByte <= sReadByte;

end rtl;
