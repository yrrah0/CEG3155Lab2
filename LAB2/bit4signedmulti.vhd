library ieee;
use ieee.std_logic_1164.all;

entity bit4signedmulti is
    port (
        i_X, i_Y: in std_logic_vector(3 downto 0);
        i_clk, i_reset: in std_logic;
        o_P: out std_logic_vector(7 downto 0);
        o_V, o_Z: out std_logic
    );
end;

architecture rtl of bit4signedmulti is
    component bit4multi
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            i_clk, i_reset: in std_logic;
            o_P: out std_logic_vector(7 downto 0);
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4complementer
        port (
            i_input: in std_logic_vector(3 downto 0);
            o_output: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component bit8complementer
        port (
            i_input: in std_logic_vector(7 downto 0);
            o_output: out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal int_signalX, int_signalY: std_logic_vector(3 downto 0);
    signal int_signalXnot, int_signalYnot: std_logic_vector(3 downto 0);
    signal int_signalP, int_signalPnot: std_logic_vector(7 downto 0);
begin
    multiplier4Inst: bit4multi
        port map (
            i_X => int_signalX,
            i_Y => int_signalY,
            i_clk => i_clk,
            i_reset => i_reset,
            o_P => int_signalP,
            o_V => o_V,
            o_Z => o_Z
        );
    
    complementerX: bit4complementer
        port map (
            i_input => i_X,
            o_output => int_signalXnot
        );
        
    complementerY: bit4complementer
        port map (
            i_input => i_Y,
            o_output => int_signalYnot
        );
    
    complementerP: bit8complementer
        port map (
            i_input => int_signalP,
            o_output => int_signalPnot
        );
    
    int_signalX <=
        i_X when (i_X(3) = '0') else
        int_signalXnot;
    
    int_signalY <=
        i_Y when (i_Y(3) = '0') else
        int_signalYnot;
    
    o_P <=
        int_signalP when ((i_X(3) xor i_Y(3)) = '0') else
        int_signalPnot;
end;