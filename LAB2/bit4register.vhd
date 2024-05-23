library ieee;
use ieee.std_logic_1164.all;

entity bit4register is
	port(
		i_reset, i_load: in std_logic;
		i_clock: in std_logic;
		i_value: in std_logic_vector(3 downto 0);
		o_value	: out std_logic_vector(3 downto 0));
end bit4register;

architecture rtl of bit4register is
	signal int_value: std_logic_vector (3 downto 0);
	
	
	component enARdFF_2
	port(
		i_reset : in std_logic;
		i_d,i_enable,i_clock : in std_logic;
		o_q,o_qBar : out std_logic);
	end component;

	begin
		--component instantiation
			b3: enARdFF_2
			port map(
			i_d => i_value(3) and i_load,
			i_reset => i_reset,
			i_enable => i_load,
			i_clock => i_clock,
			o_q => int_value(3));
			
			b2: enARdFF_2
			port map(
			i_d => i_value(2) and i_load,
			i_reset => i_reset,
			i_enable => i_load,
			i_clock => i_clock,
			o_q => int_value(2));
			
			b1: enARdFF_2
			port map(
			i_d => i_value(1) and i_load,
			i_reset => i_reset,
			i_enable => i_load,
			i_clock => i_clock,
			o_q => int_value(1));
			
			b0: enARdFF_2
			port map(
			i_d => i_value(0) and i_load,
			i_reset => i_reset,
			i_enable => i_load,
			i_clock => i_clock,
			o_q => int_value(0));
			
			--Output Driver
				o_value <= int_value;

end rtl;