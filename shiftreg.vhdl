--- ShiftRegister 8 bits (VHDL)
---
library ieee;
use ieee.std_logic_1164.all;

entity ShiftReg8 is
	port ( Clk, RS : in std_logic; -- clock, reset
		D : in std_logic; -- serial input
		Q : out std_logic ); -- 1 bit out
end ShiftReg8;

architecture RTL of ShiftReg8 is
	signal Qreg: std_logic_vector (7 downto 0); -- internal signal
	begin
	process (Clk, RS)
		begin
		if (RS = '0') then
			Qreg <= (others =>'0');
		elsif rising_edge(Clk) then
--			for i in 1 to 7 loop
--		   		Qreg(i-1) <= Qreg(i);
--			end loop;
--			Qreg(7) <= D;   
--  alternative writing:
         Qreg(6 downto 0)<=Qreg(7 downto 1); Qreg(7)<=D;
     --  Qreg <= D & Qreg(7 downto 1);  -- even more compact writing
		end if;
	end process;
	Q <= Qreg(0);
end RTL;