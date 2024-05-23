LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 2 bit adder and subtractor
entity bit8addersubtractor is
    port ( 
    i_A,i_B: in std_logic_vector(7 downto 0);
    i_sub: in std_logic;
    o_S : out std_logic_vector(7 downto 0);
    o_cout : out std_logic
    );
end entity;

architecture rtl of bit8addersubtractor is

    -- define temp variable to xor B and K, as well as carries in between adders
    signal int_cout0, int_cout1, int_cout2, int_cout3, int_cout4, int_cout5, int_cout6, int_cout7 : std_logic;
     signal int_addsub: std_logic_vector(7 downto 0);
    
    -- fulladder component definition
    component fulladder is
        port (
        X, Y, Cin : in std_logic;
        S, Cout : out std_logic );
    end component;

BEGIN
    
    -- port maps for both adders
    adder0: fulladder PORT MAP (
									  X => i_A(0), 
                             Y => (i_B(0) and not(i_sub)) or (i_sub and (i_sub xor i_B(0))),
                             Cin => i_sub,
                             S => int_addsub(0), 
                             Cout => int_cout0);
    adder1: fulladder PORT MAP ( 
									  X => i_A(1),
                             Y => (i_B(1) and not(i_sub)) or (i_sub and (i_sub xor i_B(1))),
                             Cin => int_cout0,
                             S => int_addsub(1),
                             Cout => int_cout1);
									  
	 adder2: fulladder PORT MAP (
									  X => i_A(2), 
                             Y => (i_B(2) and not(i_sub)) or (i_sub and (i_sub xor i_B(2))),
                             Cin => int_cout1,
                             S => int_addsub(2), 
                             Cout => int_cout2);
	 adder3: fulladder PORT MAP (
									  X => i_A(3), 
                             Y => (i_B(3) and not(i_sub)) or (i_sub and (i_sub xor i_B(3))),
                             Cin => int_cout2,
                             S => int_addsub(3), 
                             Cout => int_cout3);
	 adder4: fulladder PORT MAP (
									  X => i_A(4), 
                             Y => (i_B(4) and not(i_sub)) or (i_sub and (i_sub xor i_B(4))),
                             Cin => int_cout3,
                             S => int_addsub(4), 
                             Cout => int_cout4);
    adder5: fulladder PORT MAP (
									  X => i_A(5), 
                             Y => (i_B(5) and not(i_sub)) or (i_sub and (i_sub xor i_B(5))),
                             Cin => int_cout4,
                             S => int_addsub(5), 
                             Cout => int_cout5);
	 adder6: fulladder PORT MAP (
									  X => i_A(6), 
                             Y => (i_B(6) and not(i_sub)) or (i_sub and (i_sub xor i_B(6))),
                             Cin => int_cout5,
                             S => int_addsub(6), 
                             Cout => int_cout6);
	 adder7: fulladder PORT MAP (
									  X => i_A(7), 
                             Y => (i_B(7) and not(i_sub)) or (i_sub and (i_sub xor i_B(7))),
                             Cin => int_cout6,
                             S => int_addsub(7), 
                             Cout => int_cout7);
	
    o_cout <= int_cout7;
	 o_S <= int_addsub;
    
end rtl;