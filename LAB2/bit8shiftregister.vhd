library ieee;
use ieee.std_logic_1164.all;

entity bit8shiftregister is
    port (
        i_clk, i_reset: in std_logic;
        i_S: in std_logic_vector(1 downto 0);
        i_leftShift, i_rightShift: in std_logic;
        i_in: in std_logic_vector(7 downto 0);
        o_out: out std_logic_vector(7 downto 0)
    );
    -- i_S: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
end;

architecture rtl of bit8shiftregister is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    component mux4x1 is
        port(
            i_in: in std_logic_vector(3 downto 0);
            o_out: out std_logic;
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    signal int_signalDFFOutput: std_logic_vector(7 downto 0);
    signal int_signalMUXOutput: std_logic_vector(7 downto 0);
    signal int_signalMUXInputLeftShift: std_logic_vector(7 downto 0);
    signal int_signalMUXInputRightShift: std_logic_vector(7 downto 0);
begin
    int_signalMUXInputLeftShift(0) <= i_rightShift;
    int_signalMUXInputLeftShift(7 downto 1) <= int_signalDFFOutput(6 downto 0);
    int_signalMUXInputRightShift(7) <= i_leftShift;
    int_signalMUXInputRightShift(6 downto 0) <= int_signalDFFOutput(7 downto 1);
    
    generateMUX: for i in 7 downto 0 generate
        MUX4x1Inst: MUX4x1
            port map (
                i_in(3) => int_signalMUXInputRightShift(i),
                i_in(2) => int_signalMUXInputLeftShift(i),
                i_in(1) => i_in(i),
                i_in(0) => int_signalDFFOutput(i),
                o_out => int_signalMUXOutput(i),
                C => i_S
            );
    end generate;
    
    generateDFF: for i in 7 downto 0 generate
        DFFInst: enARdFF_2
            port map (
                i_resetBar => i_reset,
                i_d => int_signalMUXOutput(i),
                i_enable => '1',
                i_clock => i_clk,
                o_q => int_signalDFFOutput(i)
            );
    end generate;
    
    o_out <= int_signalDFFOutput;
end;