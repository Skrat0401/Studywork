----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2021 13:10:42
-- Design Name: 
-- Module Name: tb_out - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_out is
--  Port ( );
end tb_out;

architecture Behavioral of tb_out is
signal T_output   : std_logic;
signal T_Clk      :  std_logic;

component testfc
        port(
            Clk    : in  std_logic;
            output : out std_logic
        );
    end component testfc;
begin

DUT: testfc port map (
        Clk => T_Clk,
        output => T_output        
);

count: process 
    begin
     T_Clk <= '0';
     wait for 5 ns;
     T_Clk <= '1';
     wait for 5 ns;
 end process count;
end Behavioral;
