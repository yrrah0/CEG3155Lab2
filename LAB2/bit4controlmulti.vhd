library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity bit4controlmulti is
    port (
        i_clk: in std_logic;
        i_reset: in std_logic;
        i_P_0Z: in std_logic;
        i_counteq4: in std_logic;
        o_Preset: out std_logic;
        o_Prightshift: out std_logic;
        o_Pleftshift: out std_logic;
        o_Prightload: out std_logic;
        o_countclk: out std_logic;
        o_countreset: out std_logic;
        o_load: out std_logic;
        o_Mreset: out std_logic;
        o_Mload: out std_logic;
        o_MERreset: out std_logic;
        o_MERload: out std_logic
    );
end;

architecture rtl of bit4controlmulti is
    component DFF
        port (
            i_D: in std_logic;
            i_clk: in std_logic;
            i_clr: in std_logic;
            i_prn: in std_logic;
            o_Q: out std_logic 
        );
    end component;
    
    signal int_signalSin: std_logic_vector(0 to 5);
    signal int_signalS: std_logic_vector(0 to 5);
    signal int_signalC0: std_logic;
    signal int_signalC1out: std_logic;
begin
    S0: DFF
        port map (
            i_D => int_signalSin(0),
            i_clk => i_clk,
            i_clr => '1',
            i_prn => i_reset,
            o_Q => int_signalS(0)
        );
    
    generateStateFF: for i in 1 to 5 generate
        S: DFF
            port map (
                i_D => int_signalSin(i),
                i_clk => i_clk,
                i_clr => i_reset,
                i_prn => '1',
                o_Q => int_signalS(i)
            );
    end generate;
    
    o_Preset <= int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4) or int_signalS(5);
    o_Pleftshift <= int_signalS(2);
    o_Prightload <= int_signalS(1);
    o_Prightshift <= int_signalS(4);
    o_countreset <= int_signalS(2) or int_signalS(3) or int_signalS(4);
    o_countclk <= int_signalS(4);
    o_load <= int_signalS(5);
    o_Mreset <= int_signalS(0) or int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4);
    o_Mload <= int_signalS(0);
    o_MERreset <= int_signalS(0) or int_signalS(1) or int_signalS(2) or int_signalS(3) or int_signalS(4);
    o_MERload <= int_signalS(0);
    
    int_signalSin(0) <= int_signalS(5);
    int_signalSin(1) <= int_signalS(0);
    int_signalC0 <= int_signalS(1) or int_signalC1out;
    int_signalSin(2) <= int_signalC0 and (not i_P_0Z);
    int_signalSin(3) <= int_signalC0 and i_P_0Z;
    int_signalSin(4) <= int_signalS(2) or int_signalS(3);
    int_signalSin(5) <= int_signalS(4) and i_counteq4;
    int_signalC1out <= int_signalS(4) and (not i_counteq4);
end;