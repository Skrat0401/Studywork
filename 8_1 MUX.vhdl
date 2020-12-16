--- 8-to-1 multiplexer (VHDL)
---
library ieee;
use ieee.std_logic_1164.all;

entity MUX_8_to_1 is
	port ( 	A : in std_logic_vector (2 downto 0);
			D : in std_logic_vector (7 downto 0);
			Q : out std_logic);
end MUX_8_to_1;
architecture RTL of MUX_8_to_1 is
begin
	process (A, D)
	begin
		case A is
			when "000" => Q <= D(0);
			when "001" => Q <= D(1);
			when "010" => Q <= D(2);
			when "011" => Q <= D(3);
			when "100" => Q <= D(4);
			when "101" => Q <= D(5);
			when "110" => Q <= D(6);
			when "111" => Q <= D(7);
			when others => NULL;
		end case;
	end process;
end RTL;