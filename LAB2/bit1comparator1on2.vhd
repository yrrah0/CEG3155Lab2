library ieee;
use ieee.std_logic_1164.all;

entity bit1comparator1on2 is
	port(
		i_value1, i_value2: in std_logic;
		i_clock: in std_logic;
		o_gt,o_lt,o_eq	: out std_logic);
end bit1comparator1on2;

architecture rtl of bit1comparator1on2 is
	signal int_gt,int_lt,int_eq: std_logic;

	begin
		--concurrent signal
		 int_gt <= i_value1 and not(i_value2);
		 int_lt <= not(i_value1) and i_value2;
		 int_eq <= not(i_value1 xor i_value2);
		--Output Driver
		o_gt <= int_gt;
		o_lt <= int_lt;
		o_eq <= int_eq;
				

end rtl;