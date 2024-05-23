library ieee;
use ieee.std_logic_1164.all;

entity bit2multiplexer is
	port(
		i_left,i_right: in std_logic;
		i_op0,i_op1,i_op3: in std_logic_vector(7 downto 0);
		o_value: out std_logic_vector(7 downto 0));
end bit2multiplexer;

architecture rtl of bit2multiplexer is
	signal int_value: std_logic_vector (7 downto 0);
	signal int_clock: std_logic;
	

	begin
		--concurrent signal assignment
		  o_value(0) <= (i_op0(0) and not(i_left) and not(i_right)) or (i_op1(0) and not(i_left) and i_right) or (i_op1(0) and i_op3(0) and i_left and i_right) or (i_op3(0) and i_left and not(i_right));
		  o_value(1) <= (i_op0(1) and not(i_left) and not(i_right)) or (i_op1(1) and not(i_left) and i_right) or (i_op1(1) and i_op3(1) and i_left and i_right) or (i_op3(1) and i_left and not(i_right));
		  o_value(2) <= (i_op0(2) and not(i_left) and not(i_right)) or (i_op1(2) and not(i_left) and i_right) or (i_op1(2) and i_op3(2) and i_left and i_right) or (i_op3(2) and i_left and not(i_right));
		  o_value(3) <= (i_op0(3) and not(i_left) and not(i_right)) or (i_op1(3) and not(i_left) and i_right) or (i_op1(3) and i_op3(3) and i_left and i_right) or (i_op3(3) and i_left and not(i_right));
		  o_value(4) <= (i_op0(4) and not(i_left) and not(i_right)) or (i_op1(4) and not(i_left) and i_right) or (i_op1(4) and i_op3(4) and i_left and i_right) or (i_op3(4) and i_left and not(i_right));
		  o_value(5) <= (i_op0(5) and not(i_left) and not(i_right)) or (i_op1(5) and not(i_left) and i_right) or (i_op1(5) and i_op3(5) and i_left and i_right) or (i_op3(5) and i_left and not(i_right));
		  o_value(6) <= (i_op0(6) and not(i_left) and not(i_right)) or (i_op1(6) and not(i_left) and i_right) or (i_op1(6) and i_op3(6) and i_left and i_right) or (i_op3(6) and i_left and not(i_right));
		  o_value(7) <= (i_op0(7) and not(i_left) and not(i_right)) or (i_op1(7) and not(i_left) and i_right) or (i_op1(7) and i_op3(7) and i_left and i_right) or (i_op3(7) and i_left and not(i_right));
		  
		  
			
			
end rtl;