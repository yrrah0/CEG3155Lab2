library ieee;
use ieee.std_logic_1164.all;

entity fixedpointalu is
    port (
        i_opS: in std_logic_vector(1 downto 0);
        i_A, i_B: in std_logic_vector(3 downto 0);
        i_gclk, i_greset: in std_logic;
        
        o_muxout: out std_logic_vector(7 downto 0);
        o_Cout: out std_logic;
        o_zero: out std_logic;
        o_overflow: out std_logic
    );
end;

architecture rtl of fixedpointalu is
    component bit4addersubtractor is
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            i_sub: in std_logic;
            o_S: out std_logic_vector(3 downto 0);
            o_iCout: out std_logic;
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4signedmulti is
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            i_clk, i_reset: in std_logic;
            P: out std_logic_vector(7 downto 0);
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit4signeddiv is
        port (
            i_X, i_Y: in std_logic_vector(3 downto 0);
            i_clk, i_reset: in std_logic;
            o_Q, o_R: out std_logic_vector(3 downto 0);
            o_V, o_Z: out std_logic
        );
    end component;
    
    component bit8mux4x1 is
        port (
            I3, I2, I1, I0: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    component mux4x1 is
        port(
            i_in: in std_logic_vector(3 downto 0);
            o_out: out std_logic;
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    signal signalAdditionSubtractionResult: std_logic_vector(3 downto 0);
    signal signalMultiplicationResult: std_logic_vector(7 downto 0);
    signal signalDivisionResult: std_logic_vector(7 downto 0);
    signal signalV, signalZ: std_logic_vector(0 to 2);
begin
    MUX8bit4x1Inst: bit8mux4x1
        port map (
            I3 => signalDivisionResult,
            I2 => signalMultiplicationResult,
            I1(7 downto 4) => "0000",
            I1(3 downto 0) => signalAdditionSubtractionResult,
            I0(7 downto 4) => "0000",
            I0(3 downto 0) => signalAdditionSubtractionResult,
            O => o_muxout,
            C => i_opS
        );
        
    MUX4x1InstZ: mux4x1
        port map (
            i_in(3) => signalZ(2),
            i_in(2) => signalZ(1),
            i_in(1) => signalZ(0),
            i_in(0) => signalZ(0),
            o_out => o_zero,
            C => i_opS
        );
        
    MUX4x1InstV: mux4x1
        port map (
            i_in(3) => signalV(2),
            i_in(2) => signalV(1),
            i_in(1) => signalV(0),
            i_in(0) => signalV(0),
            o_out => o_overflow,
            C => i_opS
        );
    
    adderSubtractorInst: bit4addersubtractor
        port map (
            i_X => i_A,
            i_Y => i_B,
            i_sub => (not i_opS(1)) and i_opS(0),
            o_S => signalAdditionSubtractionResult,
            o_iCout => o_Cout,
            o_V => signalV(0),
            o_Z => signalZ(0)
        );
        
    multiplierInst: bit4signedmulti
        port map (
            i_X => i_A,
            i_Y => i_B,
            i_clk => i_gclk,
            i_reset => i_greset,
            P => signalMultiplicationResult,
            o_V => signalV(1),
            o_Z => signalZ(1)
        );
        
    dividerInst: bit4signeddiv
        port map (
            i_X => i_A,
            i_Y => i_B,
            i_clk => i_gclk,
            i_reset => i_greset,
            o_Q => signalDivisionResult(3 downto 0),
            o_R => signalDivisionResult(7 downto 4),
            o_V => signalV(2),
            o_Z => signalZ(2)
        );
end;