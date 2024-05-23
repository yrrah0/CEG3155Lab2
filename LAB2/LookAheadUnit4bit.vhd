library ieee;
use ieee.std_logic_1164.all;

entity LookAheadUnit4bit is
    port (
        i_P, i_G: in std_logic_vector(3 downto 0);
        i_Cin: in std_logic;
        o_P, o_PG: out std_logic;
        o_C: out std_logic_vector(4 downto 0)
    );
end;

architecture rtl of LookAheadUnit4bit is
begin
    o_C(0) <= i_Cin;
    o_C(1) <= i_G(0) or (i_P(0) and i_Cin);
    o_C(2) <= i_G(1) or (i_P(1) and i_G(0)) or (i_P(1) and i_P(0) and i_Cin);
    o_C(3) <= i_G(2) or (i_P(2) and i_G(1)) or (i_P(2) and i_P(1) and i_G(0)) or (i_P(2) and i_P(1) and i_P(0) and i_Cin);
    o_C(4) <= i_G(3) or (i_P(3) and i_G(2)) or (i_P(3) and i_P(2) and i_G(1)) or (i_P(3) and i_P(2) and i_P(1) and i_G(0)) or (i_P(3) and i_P(2) and i_P(1) and i_P(0) and i_Cin);
    
    o_P <= i_P(3) and i_P(2) and i_P(1) and i_P(0);
    o_PG <= i_G(3) or (i_P(3) and i_G(2)) or (i_P(3) and i_P(2) and i_G(1)) or (i_P(3) and i_P(2) and i_P(1) and i_G(0));
end;