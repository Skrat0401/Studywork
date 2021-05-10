library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity decoder is
    port(
        Clk          : in  std_logic;
        Rst          : in  std_logic;   --aktive low
        enable       : in  std_logic;   --switch r2 
        fullcounter  : in  std_logic;   --signalisiert Speicher ist voll
        syn_success  : in  std_logic;
        RanNumber    : in  unsigned(7 downto 0);
        RanNum_sADDR : out unsigned(7 downto 0);
        DATOUT_DECR  : out unsigned(7 downto 0); -- Datenausgang entschlüsselte Daten
        DATOUT_ADDR  : out unsigned(7 downto 0); -- Adresse für entschlüsselte Daten
        DATIN_ENCR   : in  unsigned(7 downto 0); -- Dateneingang verschlüsselte Daten
        DATIN_ADDR   : out unsigned(7 downto 0)); -- Sourceadresse verschlüsselte Daten
end decoder;

architecture RTL of decoder is

    signal Source_ADDR      : unsigned(7 downto 0) := "00000000";
    signal Target_ADDR      : unsigned(7 downto 0) := "00000000";
    signal RanNum_sADDR_int : unsigned(7 downto 0);
    signal counter          : integer;

begin

    decryption : process(Clk, Rst, enable)
    begin
        if (Rst = '0') then
            Source_ADDR  <= "00000000";
            Target_ADDR  <= "00000000";
            DATOUT_ADDR  <= "00000000";
            DATIN_ADDR   <= "00000000";
            RanNum_sADDR <= "00000000";
            counter      <= 0;
            DATOUT_DECR  <= "00000000";
        end if;

        if (enable = '1') then
            if (syn_success = '1') then

                if (fullcounter = '1') then
                    if (counter < 65) then
                        if (rising_edge(Clk)) then
                            DATOUT_DECR <= RanNumber xor DATIN_ENCR;
                        end if;
                    end if;
                    if (counter < 64) then
                        if rising_edge(Clk) then
                            --DATOUT_DECR <= RanNumber_OUT xor DATIN_ENCR;
                            DATOUT_ADDR <= Target_ADDR;
                            DATIN_ADDR  <= Source_ADDR;
                            Source_ADDR <= Source_ADDR + 1;
                            Target_ADDR <= Target_ADDR + 1;
                            if (RanNum_sADDR_int < 63) then
                                RanNum_sADDR_int <= RanNum_sADDR_int + 1;
                                RanNum_sADDR     <= RanNum_sADDR_int;
                            end if;
                        end if;
                    end if;
                    if (counter < 65) then
                        if rising_edge(Clk) then
                            DATOUT_ADDR <= Target_ADDR;
                            counter     <= counter + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process decryption;

end RTL;
