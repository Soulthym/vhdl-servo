library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;
                     

entity SERVO is
	port (	servo_clk : in STD_LOGIC;	---50Hz clock---
		reset: in STD_LOGIC;
		position : in STD_lOGIC_VECTOR(7 downto 0);
		gpio_clk_out : out STD_LOGIC
	);
end entity;

architecture SERVO_CONTROL of SERVO is
signal count : std_logic_vector(7 downto 0); ---1 ms count---
signal total : integer range 0 to 4590 := 0;

type state_machine_counter is (Idle, Unit, Added);
signal state_counter : state_machine_counter;

begin

process(servo_clk, reset)
begin
	if reset = '1' then
		state_counter <= Idle;
		gpio_clk_out <= '0';
		count <= "00000000";
		total <= 0;
	elsif rising_edge(servo_clk) then
		case state_counter is

		when Idle =>
			if total = 4590 then
				total <= 0;
				state_counter <= Unit;
			else
				total <= total+1;
			end if;

			gpio_clk_out <= '0';
		when Unit =>
			if count = "11111111" then
				count <= "00000000";
				state_counter <= Added;
			else
				count <= std_logic_vector(unsigned(count) +1);
			end if;
			gpio_clk_out <= '1';
		when Added =>
			if count = position then
				count <= "00000000";
				state_counter <= Idle;
			else
				count <=  std_logic_vector(unsigned(count) +1);
			end if;
			gpio_clk_out <= '1';
		end case;

	end if;
end process;

end architecture;
