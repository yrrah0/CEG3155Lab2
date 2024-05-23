library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity bit4controldiv is
    port (
        i_clk: in std_logic;
        i_reset: in std_logic;
        i_R: in std_logic;
        i_counteq: in std_logic;
        o_Rreset: out std_logic;
        o_Rleftshift: out std_logic;
        o_Rrightshift: out std_logic;
        o_Rleftload: out std_logic;
        o_Rleftshr: out std_logic;
        o_Rrightload: out std_logic;
        o_countclk: out std_logic;
        o_countreset: out std_logic;
        o_load: out std_logic;
        o_alusub: out std_logic;
        o_dandreset: out std_logic;
        o_dandload: out std_logic;
        o_dorreset: out std_logic;
        o_dorload: out std_logic
    );
end;

architecture rtl of bit4controldiv is
    component DFF
        port (
            i_D: in std_logic;
            i_clk: in std_logic;
            CLRN: in std_logic;
            PRN: in std_logic;
            o_Q: out std_logic 
        );
    end component;
    
    signal int_signalSIn: std_logic_vector(0 to 9);
    signal int_signalS: std_logic_vector(0 to 9);
begin
    S0: DFF
        port map (
            i_D => int_signalSIn(0),
            i_clk => i_clk,
            CLRN => '1',
            PRN => i_reset,
            o_Q => int_signalS(0)
        );
    
    generateStateFF: for i in 1 to 9 generate
        S: DFF
            port map (
                i_D => int_signalSIn(i),
                i_clk => i_clk,
                CLRN => i_reset,
                PRN => '1',
                o_Q => int_signalS(i)
            );
    end generate;
    
    o_Rreset <= int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4) or int_signalS(5) or int_signalS(6) or int_signalS(7) or int_signalS(8) or int_signalS(9);
    o_Rleftshift <= int_signalS(2) or int_signalS(4) or int_signalS(9);
    o_Rrightshift <= int_signalS(4);
    o_Rleftload <= int_signalS(3) or int_signalS(5);
    o_Rleftshr <= int_signalS(7);
    o_Rrightload <= int_signalS(1);
    o_countclk <= int_signalS(6);
    o_countreset <= int_signalS(3) or int_signalS(4) or int_signalS(5) or int_signalS(6) or int_signalS(9);
    o_load <= int_signalS(8);
    o_alusub <= int_signalS(2) or int_signalS(3) or int_signalS(6);
    o_dandreset <= int_signalS(0) or int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4) or int_signalS(5) or int_signalS(6) or int_signalS(7) or int_signalS(9);
    o_dandload <= int_signalS(0);
    o_dorreset <= int_signalS(0) or int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4) or int_signalS(5) or int_signalS(6) or int_signalS(7) or int_signalS(9);
    o_dorload <= int_signalS(0);
    
    int_signalSIn(0) <= int_signalS(8);
    int_signalSIn(1) <= int_signalS(0);
    int_signalSIn(2) <= int_signalS(1);
    int_signalSIn(3) <= int_signalS(2) or (int_signalS(6) and (not i_counteq));
    int_signalSIn(4) <= int_signalS(3) and (not i_R);
    int_signalSIn(5) <= int_signalS(3) and i_R;
    int_signalSIn(9) <= int_signalS(5);
    int_signalSIn(6) <= int_signalS(4) or int_signalS(9);
    int_signalSIn(7) <= int_signalS(6) and i_counteq;
    int_signalSIn(8) <= int_signalS(7);
end;