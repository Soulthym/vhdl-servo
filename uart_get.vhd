library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_get is
  generic (
    NClkPerBit : integer := 100 --115
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

  signal ReadDataR : std_logic := '0';
  signal ReadData  : std_logic := '0';

  signal ClkCnt : integer range 0 to NClkPerBit-1 := 0;
  signal BitIdx : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal sReadByte   : std_logic_vector(7 downto 0) := (others => '0');

begin

  pSAMPLE : process (Clk)
  begin
    if rising_edge(Clk) then
      ReadDataR <= SerialIn;
      ReadData  <= ReadDataR;
    end if;
  end process pSAMPLE;

  puart_get : process (Clk)
  begin
    if rising_edge(Clk) then
      if Rst = '1' then
          State <= SIdle;
      end if;
      case State is
        when SIdle =>
          ClkCnt <= 0;
          BitIdx <= 0;

          if ReadData = '0' then       
            State <= SReadStart;
          else
            State <= SIdle;
          end if;

        when SReadStart =>
          if ClkCnt = (NClkPerBit-1)/2 then
            if ReadData = '0' then
              ClkCnt <= 0; 
              State   <= SReadData;
            else
              State   <= SIdle;
            end if;
          else
            ClkCnt <= ClkCnt + 1;
            State   <= SReadStart;
          end if;

        when SReadData =>
          if ClkCnt < NClkPerBit-1 then
            ClkCnt <= ClkCnt + 1;
            State   <= SReadData;
          else
            ClkCnt            <= 0;
            sReadByte(BitIdx) <= ReadData;

            if BitIdx < 7 then
              BitIdx <= BitIdx + 1;
              State   <= SReadData;
            else
              BitIdx <= 0;
              State   <= SReadStop;
            end if;
          end if;

        when SReadStop =>
          if ClkCnt < NClkPerBit-1 then
            ClkCnt <= ClkCnt + 1;
            State   <= SReadStop;
          else
            ClkCnt <= 0;
            State   <= SIdle;
          end if;

        when others =>
          State <= SIdle;

      end case;
    end if;
  end process puart_get;

  ReadByte <= sReadByte;

end rtl;
