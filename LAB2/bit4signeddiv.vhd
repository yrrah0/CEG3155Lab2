library ieee;
use ieee.std_logic_1164.all;

entity bit4signeddiv is
    port (
        i_X, i_Y: in std_logic_vector(3 downto 0);
        i_clk, i_reset: in std_logic;
        o_Q, o_R: out std_logic_vector(3 downto 0);
        o_V, o_Z: out std_logic
    );
end;

architecture rtl of bit4signeddiv is
    component Divider4
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            i_clk, i_reset: in std_logic;
            o_Q, o_R: out std_logic_vector(3 downto 0);
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4complementer
        port (
            i_in: in std_logic_vector(3 downto 0);
            o_out: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal int_signalX, int_signalY: std_logic_vector(3 downto 0);
    signal int_signalXnot, int_signalYnot: std_logic_vector(3 downto 0);
    signal int_signalQ, int_signalQnot: std_logic_vector(3 downto 0);
begin
    divider4Inst: Divider4
        port map (
            i_X => int_signalX,
            i_Y => int_signalY,
            i_clk => i_clk,
            i_reset => i_reset,
            o_Q => int_signalQ,
            o_R => o_R,
            o_V => o_V,
            o_Z => o_Z
        );
    
    complementerX: bit4complementer
        port map (
            i_in => i_X,
            o_out => int_signalXnot
        );
        
    complementerY: bit4complementer
        port map (
            i_in => i_Y,
            o_out => int_signalYnot
        );
    
    complementerQ: bit4complementer
        port map (
            i_in => int_signalQ,
            o_out => int_signalQnot
        );
    
    int_signalX <=
        i_X when (i_X(3) = '0') else
        int_signalXnot;
    
    int_signalY <=
        i_Y when (i_Y(3) = '0') else
        int_signalYnot;
    
    o_Q <=
        int_signalQ when ((i_X(3) xor i_Y(3)) = '0') else
        int_signalQnot;
end;