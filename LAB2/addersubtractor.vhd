LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 2 bit adder and subtractor
entity addersubtractor is
    port ( 
    i_A,i_B: in std_logic_vector(1 downto 0);
    i_sub: in std_logic;
    o_S : out std_logic_vector(1 downto 0);
    o_cout : out std_logic
    );
end entity;

architecture rtl of addersubtractor is

    -- define temp variable to xor B and K, as well as carries in between adders
    signal int_cout0, int_cout1 : std_logic;
     signal int_addsub: std_logic_vector(1 downto 0);
    
    -- fulladder component definition
    component fulladder is
        port ( 
        X, Y, Cin : in std_logic;
        S, Cout : out std_logic );
    end component;

BEGIN
    
    -- port maps for both adders
    adder0: fulladder PORT MAP ( X => i_A(0), -- assuming x, y and cin are the inputs of adder
                             Y => (i_B(0) and not(i_sub)) or (i_sub and (i_sub xor i_B(0))),
                             Cin => i_sub,
                             S => int_addsub(0), -- assuming sum and cout are the outputs
                             Cout => int_cout0);
    adder1: fulladder PORT MAP ( X => i_A(1),
                             Y => (i_B(1) and not(i_sub)) or (i_sub and (i_sub xor i_B(1))),
                             Cin => int_cout0,
                             S => int_addsub(1),
                             Cout => int_cout1);
    o_cout <= int_cout1;
	 o_S <= int_addsub;
    
end;