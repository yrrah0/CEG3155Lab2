library ieee;
use ieee.std_logic_1164.all;

entity leftshift8bitregister is
	port(
		i_reset,i_leftshift: in std_logic;
		i_clock: in std_logic;
		i_value: in std_logic_vector(7 downto 0);
		o_value	: out std_logic_vector(7 downto 0));
end leftshift8bitregister;

architecture rtl of leftshift8bitregister is
	signal int_value: std_logic_vector (7 downto 0);
	
	
	component enARdFF_2
	port(
		i_clock : in std_logic;
		i_d : in std_logic;
		o_q,o_qBar: out std_logic);
	end component;

	begin
		--component instantiation
		  b7: enARdFF_2
			port map(
			i_d => i_value(7) or (int_value(6) and i_leftshift),
			
			i_clock => i_clock,
			o_q => int_value(7));
			
			b6: enARdFF_2
			port map(
			i_d => (i_value(6)) or (int_value(5) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(6));
			
			b5: enARdFF_2
			port map(
			i_d => (i_value(5)) or (int_value(4) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(5));
			
			b4: enARdFF_2
			port map(
			i_d => (i_value(4)) or (int_value(3) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(4));
			
			b3: enARdFF_2
			port map(
			i_d => (i_value(3)) or (int_value(2) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(3));
			
			b2: enARdFF_2
			port map(
			i_d => (i_value(2)) or (int_value(1) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(2));
			
			b1: enARdFF_2
			port map(
			i_d => (i_value(1)) or (int_value(0) and i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(1));
			
			b0: enARdFF_2
			port map(
			i_d => (i_value(0)) and not(i_leftshift),
			
			
			i_clock => i_clock,
			o_q => int_value(0));
			--concurrent signals
			
			
			--Output Driver
				o_value <= int_value;

end rtl;