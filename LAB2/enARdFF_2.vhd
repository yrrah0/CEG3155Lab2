library ieee;
use ieee.std_logic_1164.all;

entity enARdFF_2 is
	port(
		i_clock : in std_logic;
		i_d : in std_logic;
		o_q,o_qBar: out std_logic);
end enARdFF_2;

architecture rtl of enARdFF_2 is
	SIGNAL int_q, int_qBar : STD_LOGIC;
 SIGNAL int_d, int_dBar : STD_LOGIC;
 SIGNAL int_notD, int_notClock : STD_LOGIC;

	
	component enabledSRLatch
	port(
		 i_set, i_reset : IN STD_LOGIC;
		i_enable : IN STD_LOGIC;
		o_q, o_qBar : OUT STD_LOGIC);
	end component;

	begin
		--concurrent signal
		masterLatch: enabledSRLatch
		 PORT MAP ( i_set => i_d,
		 i_reset => int_notD,
		 i_enable => int_notClock,
		 o_q => int_q,
		 o_qBar => int_qBar);
		 slaveLatch: enabledSRLatch
		 PORT MAP ( i_set => int_q,
		 i_reset => int_qBar,
		 i_enable => i_clock,
		 o_q => o_q,
		 o_qBar => o_qBar);
		  
			--Output Driver
			int_notD <= not(i_d);
			int_notClock <= not(i_clock);

end rtl;