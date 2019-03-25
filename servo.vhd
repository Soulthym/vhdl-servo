library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;
                     

entity SERVO is
	generic ( bit_count : integer := 255 );	--- divide sys clock into 1/255 ms clock
	port (	Clk : in STD_LOGIC;
		reset: in STD_LOGIC;
		position : in STD_lOGIC_VECTOR(7 downto 0);
		gpio_clk_out : out STD_LOGIC
	);
end entity;

architecture SERVO_CONTROL of SERVO is
signal count : std_logic_vector(7 downto 0); ---1 ms count---
signal total : integer range 0 to 4590 := 0;
signal servo_clk : std_logic;
signal servo_count : INTEGER range 0 to bit_count := 0;

type state_machine_counter is (Idle, Unit, Added);
signal state_counter : state_machine_counter;

begin

process(Clk, reset)
--- clock divider-----
	if reset = '1' then
		state_counter <= Idle;
		gpio_clk_out <= '0';
		count <= "00000000";
		total <= 0;
		servo_clk <= '0';
	elsif rising_edge(Clk) then	--- generate servo clock ---
		if servo_count = bit_count then
			servo_count <= 0;
			servo_clk <= not servo_clk;
		else
			servo_count <= servo_count + 1;
		end if;
	end if;
end process;

process(Clk, reset, servo_clk)
begin
--- servo signal generato ----
	if rising_edge(Clk) then
		if servo_clk = '1' then
			case state_counter is

			when Idle =>	---- idle mode : no signal ---
				if total = 4590 then
					total <= 0;
					state_counter <= Unit;
				else
					total <= total+1;
				end if;

				gpio_clk_out <= '0';
			when Unit =>	---- 1ms pulse ----
				if count = "11111111" then
					count <= "00000000";
					state_counter <= Added;
				else
					count <= std_logic_vector(unsigned(count) +1);
				end if;
				gpio_clk_out <= '1';
			when Added =>	---- angle control pulse ----
				if count = position then
					count <= "00000000";
					state_counter <= Idle;
				else
					count <=  std_logic_vector(unsigned(count) +1);
				end if;
				gpio_clk_out <= '1';
			end case;
		end if;
	end if;
end process;

end architecture;
