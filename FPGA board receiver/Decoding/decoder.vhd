library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity decoder is
    port(
        Clk         : in  std_logic;
        Rst         : in  std_logic;    --aktive low
        enable      : in  std_logic;    --switch r2 
        fullcounter : in  std_logic;    --signalisiert Speicher ist voll
        syn_success : in  std_logic;
        ADDR_Key    : in  std_logic_vector(7 downto 0);
        DATOUT_DECR : out unsigned(7 downto 0); -- Datenausgang entschlüsselte Daten
        DATOUT_ADDR : out unsigned(7 downto 0); -- Adresse für entschlüsselte Daten
        DATIN_ENCR  : in  unsigned(7 downto 0); -- Dateneingang verschlüsselte Daten
        DATIN_ADDR  : out unsigned(7 downto 0)); -- Sourceadresse verschlüsselte Daten
end decoder;

architecture RTL of decoder is

    component Random_Number_8
        port(
            Clk                 : in  std_logic;
            Rst                 : in  std_logic;
            KeyIn               : in  unsigned(7 downto 0);
            reset_Number        : in  std_logic;
            RanNum              : out unsigned(8 downto 1);
            RanNum_targetadress : out unsigned(7 downto 0));
    end component Random_Number_8;

    component ROMKey_mem
        generic(
            L_BITS : natural;
            M_BITS : natural
        );
        port(
            ADDR : in  std_logic_vector(L_BITS - 1 downto 0);
            DATA : out unsigned(M_BITS - 1 downto 0)
        );
    end component ROMKey_mem;

    component Random_Number_8_mem
        port(Clk                 : in  std_logic;
             RanNum_targetadress : in  unsigned(7 downto 0);
             RanNum_In           : in  unsigned(7 downto 0);
             RanNum_sourceadress : in  unsigned(7 downto 0);
             RanNum_Out          : out unsigned(7 downto 0));
    end component Random_Number_8_mem;

    signal RanNumber_IN  : unsigned(7 downto 0);
    signal RanNumber_OUT : unsigned(7 downto 0);
    signal KeyInInt      : unsigned(7 downto 0);
    signal RanNum_tADDR  : unsigned(7 downto 0) := "00000000";
    signal RanNum_sADDR  : unsigned(7 downto 0) := "00000000";
    signal Source_ADDR   : unsigned(7 downto 0) := "00000000";
    signal Target_ADDR   : unsigned(7 downto 0) := "00000000";
    signal reset_Number  : std_logic;
    signal counter       : integer;

begin
    

    RanNumber_mem : Random_Number_8_mem
        port map(
            Clk                 => Clk,
            RanNum_targetadress => RanNum_tADDR,
            RanNum_In           => RanNumber_IN,
            RanNum_sourceadress => RanNum_sADDR,
            RanNum_Out          => RanNumber_OUT);

    RanNumber : Random_Number_8
        port map(
            Clk                 => Clk,
            Rst                 => Rst,
            KeyIn               => KeyInInt,
            reset_Number        => reset_Number,
            RanNum              => RanNumber_IN,
            RanNum_targetadress => RanNum_tADDR);

    ROMKey_memory : ROMKey_mem
        generic map(
            L_BITS => 8,
            M_BITS => 8)
        port map(
            ADDR => ADDR_Key,
            DATA => KeyInInt);

    decryption : process(Clk, Rst, enable)
    begin
        if (Rst = '0') then
            Source_ADDR  <= "00000000";
            Target_ADDR  <= "00000000";
            DATOUT_ADDR  <= "00000000";
            DATIN_ADDR   <= "00000000";
            RanNum_sADDR <= "00000000";
            reset_Number <= '0';
            counter      <= 0;
        end if;

        if (enable = '1') then
            if (syn_success = '1') then

                if (fullcounter = '1') then
                    if (counter < 65) then
                        if (rising_edge(Clk)) then
                            DATOUT_DECR <= RanNumber_OUT xor DATIN_ENCR;
                        end if;
                    end if;
                    if (counter < 64) then
                        if rising_edge(Clk) then
                            --DATOUT_DECR <= RanNumber_OUT xor DATIN_ENCR;
                            DATOUT_ADDR <= Target_ADDR;
                            DATIN_ADDR  <= Source_ADDR;
                            Source_ADDR <= Source_ADDR + 1;
                            Target_ADDR <= Target_ADDR + 1;
                            if (RanNum_sADDR < 63) then
                                RanNum_sADDR <= RanNum_sADDR + 1;
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
