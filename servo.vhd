library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;

entity SERVO is
    generic ( clkcnt : integer := 255 );    --- divide sys clock into 1/255 ms clock
    port (    
        clk : in STD_LOGIC;
        rst: in STD_LOGIC;
        pos : in STD_lOGIC_VECTOR(7 downto 0);
        gpio : out STD_LOGIC
    );
end entity;

architecture SERVO_CONTROL of SERVO is
signal cnt : integer range 0 to 5119;
signal servo_clk : std_logic;
signal servo_cnt : INTEGER range 0 to clkcnt := 0;

begin

    process(clk, rst)
    begin
    --- servo signal generato ----
        if rst = '1' then
            gpio <= '0';
            cnt <= 0;
            servo_clk <= '0';
        end if;
        if rising_edge(clk) then
            if servo_cnt < clkcnt then
                servo_clk <= '0';
                servo_cnt <= servo_cnt + 1;
            else
                servo_clk <= '1';
                servo_cnt <= 0;
                if cnt < 5119 then
                    cnt <= cnt + 1;
                else
                    cnt <= 0;
                end if;
            end if;
            if servo_clk = '1' then
                if cnt < (255 + to_integer(Unsigned(pos))) then
                    gpio <= '1';
                else
                    gpio <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;
