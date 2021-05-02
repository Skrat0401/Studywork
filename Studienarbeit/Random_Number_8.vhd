library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Random_Number_8 is
    port(
        Clk : in std_logic;
        Rst : in std_logic;
        KeyIn : in unsigned (7 downto 0);
        reset_Number : in std_logic;
        RanNum : out unsigned (8 downto 1)
    );
end entity Random_Number_8;

architecture RTL of Random_Number_8 is
    signal RanNumReg : unsigned (8 downto 1);   
begin
    process (Clk, Rst) begin
        if(Rst = '0') then
            RanNumReg <= KeyIn;
        elsif(reset_Number = '1')then
        	RanNumReg <= KeyIn;
        elsif rising_edge(Clk) then 
            for ii in 8 downto 2 loop
                RanNumReg(ii) <= RanNumReg(ii-1);
            end loop;
            RanNumReg(1) <= RanNumReg(8) XOR RanNumReg(6) XOR RanNumReg(5) XOR RanNumReg(4);
        end if;
    end process;
    RanNum <= RanNumReg;
end architecture RTL;
