
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ROMKey is
generic (
    L_BITS : natural; -- Addressbreite
    M_BITS : natural); -- Wortbreite
port ( 
    ADDR : in std_logic_vector(L_BITS-1 downto 0);
    DATA : out unsigned(M_BITS-1 downto 0));
end ROMKey;

architecture RTL of ROMKey is

type ROM_array is array(0 to 2**L_BITS - 1) of unsigned(M_BITS - 1 downto 0);

signal memory : ROM_array := ( "00101101" , "00101110" ,"00101100" ,"10101100" ,
    "01101101" , "00101111" , "00100100" , "00100011" , "11111100" , "01101101" ,
     "00101100" , "00101100" , "00101100" , "00101100" , "00101100" , "00111111",
     others => "00000001");

begin
DATA <= memory(to_integer(unsigned(ADDR)));
end RTL;
