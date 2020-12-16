--- Testbench for Shift Reg (VHDL)
--- Author: Klaus Gosger  
---
library ieee;
use ieee.std_logic_1164.all;
entity test_ShiftReg8 is -- no external signals
end test_ShiftReg8;

architecture Behavioural of test_ShiftReg8 is

	component ShiftReg8 is
		port ( Clk, RS : in  std_logic;  -- clock, reset
			   D       : in  std_logic;  -- serial input
			   Q       : out std_logic); -- 1 bit out
	end component;
	
	-- testbench internal signals
	signal TClk : std_logic := '0'; 
	signal TRS  : std_logic := '0';
	signal TD   : std_logic ;
	signal TQ   : std_logic ;
	
	-- testbench test signals
	constant TDV: std_logic_vector (15 downto 0) := "0101010101010101";
	constant TQV: std_logic_vector (15 downto 0) := "1010101010000000"; 
	
	begin
	-- connect DUT to testbench
	DUT: ShiftReg8 port map (Clk=>TClk, RS=>TRS ,D=>TD, Q=>TQ);
	
	-- run tests
	reset : process -- reset shiftreg once
	begin
	    wait for 20 ns; TRS <= '0';
	    wait for 4 ns;  TRS <= '1';
	    wait;
	end process reset;
	
	test: process 
	
	begin
		L1: for j in 0 to 15 loop -- step to next transition
			 
			TD <= TDV(j);     -- set input signal to test vector 
			TClk <= '0';
			wait for 50 ns;
			TClk <= '1';
			wait for 50 ns;
		   
			if (TQ /= TQV(j) ) then -- compare output signals
				report "test step failed" severity NOTE;
			else
				report "test step passed" severity NOTE;
			end if;
		end loop L1;
		wait;
	end process test;
end Behavioural;