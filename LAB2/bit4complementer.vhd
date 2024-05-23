library ieee;
use ieee.std_logic_1164.all;

entity bit4complementer is
    port (
        i_in: in std_logic_vector(3 downto 0);
        o_out: out std_logic_vector(3 downto 0)
    );
end;

architecture rtl of bit4complementer is
begin
    o_out(3) <= i_in(3) xor (i_in(2) or i_in(1) or i_in(0));
    o_out(2) <= i_in(2) xor (i_in(1) or i_in(0));
    o_out(1) <= i_in(1) xor i_in(0);
    o_out(0) <= i_in(0);
end;