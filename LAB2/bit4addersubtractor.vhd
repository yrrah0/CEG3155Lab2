library ieee;
use ieee.std_logic_1164.all;

entity bit4addersubtractor is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        SUB: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Cout: out std_logic;
        V, Z: out std_logic
    );
end;

architecture rtl of bit4addersubtractor is
    component bit4adder
        port (
            X, Y: in std_logic_vector(3 downto 0);
            Cin: in std_logic;
            S: out std_logic_vector(3 downto 0);
            Cout: out std_logic;
            P, G: out std_logic;
            V, Z: out std_logic
        );
    end component;
    
    signal signalY: std_logic_vector(3 downto 0);
begin
    generateSignalY:
        for i in 3 downto 0 generate
            signalY(i) <= Y(i) xor SUB;
        end generate;
    
    adder4Inst: bit4adder
        port map (
            X => X,
            Y => signalY,
            Cin => SUB,
            S => S,
            Cout => Cout,
            V => V,
            Z => Z
        );
end;