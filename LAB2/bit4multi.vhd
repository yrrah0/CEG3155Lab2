library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity bit4multi is
    port (
        i_X, i_Y: in std_logic_vector(3 downto 0);
        i_clk, i_reset: in std_logic;
        o_P: out std_logic_vector(7 downto 0);
        o_V, o_Z: out std_logic
    );
end;

architecture rtl of bit4multi is
    component bit4controlmulti is
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
    end component;

    component bit8shiftregister is
        port (
            i_clk, i_reset: in std_logic;
            i_S: in std_logic_vector(1 downto 0);
            i_leftshift, i_rightshift: in std_logic;
            i_in: in std_logic_vector(7 downto 0);
            o_out: out std_logic_vector(7 downto 0)
        );
        -- i_S: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
    end component;

    component bit4shiftregister is
        port (
            i_clk, i_reset: in std_logic;
            i_S: in std_logic_vector(1 downto 0);
            i_leftshift, i_rightshift: in std_logic;
            i_in: in std_logic_vector(3 downto 0);
            o_out: out std_logic_vector(3 downto 0)
        );
        -- i_S: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
    end component;
    
    component bit4addersubtractor is
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            SUB: in std_logic;
            S: out std_logic_vector(3 downto 0);
            Cout: out std_logic;
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4counter16 is
        port (
            i_clk, i_reset, EN: in std_logic;
            VALUE: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal signalCounterClock: std_logic;
    signal signalCounterResetN: std_logic;
    signal signalCounterValue: std_logic_vector(3 downto 0);
    
    signal signalOutputLoad: std_logic;
    signal signalOutput: std_logic_vector(7 downto 0);
    
    signal signalSRMultiplicandResetN: std_logic;
    signal signalSRMultiplicandLoad: std_logic;
    signal signalSRMultiplicandOut: std_logic_vector(3 downto 0);
    
    signal signalSRMultiplierResetN: std_logic;
    signal signalSRMultiplierLoad: std_logic;
    signal signalSRMultiplierOut: std_logic_vector(3 downto 0);
    
    signal signalSRProductResetN: std_logic;
    signal signalSRProductLeftLoad: std_logic;
    signal signalSRProductRightLoad: std_logic;
    signal signalSRProductShiftRight: std_logic;
    
    signal signalSRProductLeftInput: std_logic_vector(3 downto 0);
    signal signalSRProductLeftOutput: std_logic_vector(3 downto 0);
    signal signalSRProductRightOutput: std_logic_vector(3 downto 0);
begin
    counter: bit4counter16
        port map (
            i_clk => signalCounterClock,
            i_reset => i_reset and signalCounterResetN,
            EN => '1',
            VALUE => signalCounterValue
        );

    control: bit4controlmulti
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_P_0Z => not signalSRProductRightOutput(0),
            i_counteq4 => signalCounterValue(2) and (not signalCounterValue(1)) and signalCounterValue(0),
            o_Preset => signalSRProductResetN,
            o_Prightshift => signalSRProductShiftRight,
            o_Pleftshift => signalSRProductLeftLoad,
            o_Prightload => signalSRProductRightLoad,
            o_countclk => signalCounterClock,
            o_countreset => signalCounterResetN,
            o_load => signalOutputLoad,
            o_Mreset => signalSRMultiplicandResetN,
            o_Mload => signalSRMultiplicandLoad,
            o_MERreset => signalSRMultiplierResetN,
            o_MERload => signalSRMultiplierLoad
        );

    adderSubtractor4Inst: bit4addersubtractor
        port map (
            i_X => signalSRProductLeftOutput,
            i_Y => i_X,
            SUB => '0',
            S => signalSRProductLeftInput
        );
    
    SRMultiplicand: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRMultiplicandResetN,
            i_S(1) => '0',
            i_S(0) => signalSRMultiplicandLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => i_X,
            o_out => signalSRMultiplicandOut
        );
    
    SRMultiplier: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRMultiplierResetN,
            i_S(1) => '0',
            i_S(0) => signalSRMultiplierLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => i_Y,
            o_out => signalSRMultiplierOut
        );
    
    SRProductLeft: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRProductResetN,
            i_S(1) => signalSRProductShiftRight,
            i_S(0) => signalSRProductShiftRight or signalSRProductLeftLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => signalSRProductLeftInput,
            o_out => signalSRProductLeftOutput
        );
        
    SRProductRight: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRProductResetN,
            i_S(1) => signalSRProductShiftRight,
            i_S(0) => signalSRProductShiftRight or signalSRProductRightLoad,
            i_leftshift => signalSRProductLeftOutput(0),
            i_rightshift => '0',
            i_in => i_Y,
            o_out => signalSRProductRightOutput
        );
        
    SROutput: bit8shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_S(1) => '0',
            i_S(0) => signalOutputLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in(7 downto 4) => signalSRProductLeftOutput,
            i_in(3 downto 0) => signalSRProductRightOutput,
            o_out => signalOutput
        );
    
    o_P <= signalOutput;
    o_V <= '0';
    o_Z <= not (or_reduce(signalOutput));
end;