library ieee;
use ieee.std_logic_1164.all;

entity bit4counter16 is
    port (
        i_clk, i_reset, i_en: in std_logic;
        o_count: out std_logic_vector(3 downto 0)
    );
end;

architecture rtl of bit4counter16 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    signal int_signalValue: std_logic_vector(3 downto 0);
    signal int_signalD: std_logic_vector(3 downto 0);
begin
    int_signalD(3) <= int_signalValue(3) xor (int_signalValue(2) and int_signalValue(1) and int_signalValue(0));
    int_signalD(2) <= int_signalValue(2) xor (int_signalValue(1) and int_signalValue(0));
    int_signalD(1) <= int_signalValue(1) xor int_signalValue(0);
    int_signalD(0) <= not int_signalValue(0);

    generateDFF: for i in 3 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => i_reset,
                i_d => int_signalD(i),
                i_enable => i_en,
                i_clock => i_clk,
                o_q => int_signalValue(i)
            );
    end generate;
    
    o_count <= int_signalValue;
end;