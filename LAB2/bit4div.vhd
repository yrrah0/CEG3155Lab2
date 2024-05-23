library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity bit4div is
    port (
        i_X, i_Y: in std_logic_vector(3 downto 0);
        i_clk, i_reset: in std_logic;
        o_Q, o_R: out std_logic_vector(3 downto 0);
        o_V, o_Z: out std_logic
    );
end;

architecture rtl of bit4div is
    component bit4controldiv is
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
            o_Cout: out std_logic;
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4counter16 is
        port (
            i_clk, i_reset, i_en: in std_logic;
            VALUE: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal signalCounterClock: std_logic;
    signal signalCounterResetN: std_logic;
    signal signalCounterValue: std_logic_vector(3 downto 0);
    
    signal signalOutputLoad: std_logic;
    signal signalOutput: std_logic_vector(7 downto 0);
    
    signal signalSubtract: std_logic;
    
    signal signalSRDividendResetN: std_logic;
    signal signalSRDividendLoad: std_logic;
    signal signalSRDividendOut: std_logic_vector(3 downto 0);
    
    signal signalSRDivisorResetN: std_logic;
    signal signalSRDivisorLoad: std_logic;
    signal signalSRDivisorOut: std_logic_vector(3 downto 0);
    
    signal signalSRRemainderResetN: std_logic;
    signal signalSRRemainderLeftLoad: std_logic;
    signal signalSRRemainderRightLoad: std_logic;
    signal signalSRRemainderShiftLeft: std_logic;
    signal signalSRRemainderLeftShiftRight: std_logic;
    signal signalSRRemainderLeftInput, signalSRRemainderLeftOutput: std_logic_vector(3 downto 0);
    signal signalSRRemainderRightInput, signalSRRemainderRightOutput: std_logic_vector(3 downto 0);
    signal signalSRRemainderRightSerialInRight: std_logic;
    
begin
    counter: bit4counter16
        port map (
            i_clk => signalCounterClock,
            i_reset => i_reset and signalCounterResetN,
            i_en => '1',
            VALUE => signalCounterValue
        );

    control: bit4controldiv
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_R => signalSRRemainderLeftOutput(3),
            i_counteq => signalCounterValue(2) and (not signalCounterValue(1)) and signalCounterValue(0),
            o_Rreset => signalSRRemainderResetN,
            o_Rleftshift => signalSRRemainderShiftLeft,
            o_Rrightshift => signalSRRemainderRightSerialInRight,
            o_Rleftload => signalSRRemainderLeftLoad,
            o_Rleftshr => signalSRRemainderLeftShiftRight,
            o_Rrightload => signalSRRemainderRightLoad,
            o_countclk => signalCounterClock,
            o_countreset => signalCounterResetN,
            o_load => signalOutputLoad,
            o_alusub => signalSubtract,
            o_dandreset => signalSRDividendResetN,
            o_dandload => signalSRDividendLoad,
            o_dorreset => signalSRDivisorResetN,
            o_dorload => signalSRDivisorLoad
        );
    
    adderSubtractor4Inst: bit4addersubtractor
        port map (
            i_X => signalSRRemainderLeftOutput,
            i_Y => i_Y,
            SUB => signalSubtract,
            S => signalSRRemainderLeftInput
        );
        
    SRDividend: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRDividendResetN,
            i_S(1) => '0',
            i_S(0) => signalSRDividendLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => i_X,
            o_out => signalSRDividendOut
        );
        
    SRDivisor: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRDivisorResetN,
            i_S(1) => '0',
            i_S(0) => signalSRDivisorLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => i_Y,
            o_out => signalSRDivisorOut
        );
    
    SRRemainderLeft: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRRemainderResetN,
            i_S(1) => signalSRRemainderShiftLeft or signalSRRemainderLeftShiftRight,
            i_S(0) => (not signalSRRemainderShiftLeft) or signalSRRemainderLeftShiftRight or signalSRRemainderLeftLoad,
            i_leftshift => '0',
            i_rightshift => signalSRRemainderRightOutput(3),
            i_in => signalSRRemainderLeftInput,
            o_out => signalSRRemainderLeftOutput
        );
        
    SRRemainderRight: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset and signalSRRemainderResetN,
            i_S(1) => signalSRRemainderShiftLeft,
            i_S(0) => (not signalSRRemainderShiftLeft) or signalSRRemainderRightLoad,
            i_leftshift => '0',
            i_rightshift => signalSRRemainderRightSerialInRight,
            i_in => i_X,
            o_out => signalSRRemainderRightOutput
        );
        
    SRRemainderOutput: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_S(1) => '0',
            i_S(0) => signalOutputLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => signalSRRemainderLeftOutput,
            o_out => o_R
        );
    
    SRQuotientOutput: bit4shiftregister
        port map (
            i_clk => i_clk,
            i_reset => i_reset,
            i_S(1) => '0',
            i_S(0) => signalOutputLoad,
            i_leftshift => '0',
            i_rightshift => '0',
            i_in => signalSRRemainderRightOutput,
            o_out => o_Q
        );
    
    o_V <= not (or_reduce(i_Y));
    o_Z <= not (or_reduce(signalSRRemainderLeftOutput) or or_reduce(signalSRRemainderRightOutput));
end;