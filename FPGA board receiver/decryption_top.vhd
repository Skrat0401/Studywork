library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decryption_top is
    port(
        Clk                       : in  std_logic; --100MHz
        Rst                       : in  std_logic; --aktive low
        enable                    : in  std_logic; --switch r2
        data_in_pin               : in  std_logic;
        sw                        : in  std_logic_vector(8 downto 1);
        LED_syn_success           : out std_logic;
        LED_comparator_success    : out std_logic;
        LED_comparator_fail       : out std_logic;
        LED_comparator_10_success : out std_logic;
        LED_comparator_30_success : out std_logic;
        LED_comparator_50_success : out std_logic;
        LED_synfull               : out std_logic;
        LED_decrfull              : out std_logic;
        output                    : out std_logic
    );

end decryption_top;

architecture RTL of decryption_top is

    signal LED         : std_logic;
    signal syn_success : std_logic;
    signal data        : unsigned(7 downto 0);

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

    component comparator
        port(
            ADDR_DECR        : out unsigned(7 downto 0);
            DATA_DECR        : in  unsigned(7 downto 0);
            Clk              : in  STD_LOGIC;
            Rst              : in  STD_LOGIC;
            fullcounter_DECR : in  std_logic;
            ADDR_current_mem : out unsigned(7 downto 0);
            DATA_current_mem : in  unsigned(7 downto 0);
            success_flag10   : out STD_LOGIC;
            success_flag30   : out STD_LOGIC;
            success_flag50   : out STD_LOGIC;
            success_flag     : out STD_LOGIC
        );
    end component comparator;

    component comparator_mem
        port(
            Current_ADDR : in  unsigned(7 downto 0);
            Current_DATA : out unsigned(7 downto 0);
            Clk          : in  std_logic
        );
    end component comparator_mem;

    component decoder_mem
        port(
            Clk              : in  std_logic;
            Rst              : in  std_logic;
            DATOUT_DECR      : in  unsigned(7 downto 0);
            DATOUT_ADDR      : in  unsigned(7 downto 0);
            Target_Data_Decr : out unsigned(7 downto 0);
            Target_Addr_Decr : in  unsigned(7 downto 0);
            fullcounter_DECR : out std_logic
        );
    end component decoder_mem;

    component decoder
        port(
            Clk          : in  std_logic;
            Rst          : in  std_logic;
            enable       : in  std_logic;
            fullcounter  : in  std_logic;
            syn_success  : in  std_logic;
            RanNumber    : in  unsigned(7 downto 0);
            RanNum_sADDR : out unsigned(7 downto 0);
            DATOUT_DECR  : out unsigned(7 downto 0);
            DATOUT_ADDR  : out unsigned(7 downto 0);
            DATIN_ENCR   : in  unsigned(7 downto 0);
            DATIN_ADDR   : out unsigned(7 downto 0)
        );
    end component decoder;

    component synchronization_mem
        port(
            Clk         : in  std_logic;
            Rst         : in  std_logic;
            target_addr : in  unsigned(7 downto 0);
            data_in     : in  unsigned(7 downto 0);
            output_addr : in  unsigned(7 downto 0);
            fullcounter : out std_logic;
            data_out    : out unsigned(7 downto 0)
        );
    end component synchronization_mem;

    component synchronization
        port(
            Clk         : in  std_logic;
            Rst         : in  std_logic;
            LED_B       : out std_logic;
            syn_success : out std_logic;
            data_in_pin : in  std_logic;
            data_out    : out unsigned(7 downto 0);
            output_addr : out unsigned(7 downto 0);
            syn_en      : in  std_logic
        );
    end component synchronization;
    signal memory_syn_target_addr : unsigned(7 downto 0);
    signal fullcounter            : std_logic;
    signal data_for_decode        : unsigned(7 downto 0);
    signal addr_for_decode        : unsigned(7 downto 0);
    signal DATOUT_DECR            : unsigned(7 downto 0);
    signal DATOUT_ADDR            : unsigned(7 downto 0);
    signal success_flag_LED       : STD_LOGIC;
    signal fullcounter_DECR_mem   : std_logic;
    signal ADDR_DECR_mem          : unsigned(7 downto 0);
    signal DATA_DECR_mem          : unsigned(7 downto 0);
    signal ADDR_current_mem       : unsigned(7 downto 0);
    signal DATA_current_mem       : unsigned(7 downto 0);
    signal KeyInInt               : unsigned(7 downto 0);
    signal RanNumber_IN           : unsigned(7 downto 0);
    signal RanNumber_OUT          : unsigned(7 downto 0);
    signal RanNum_tADDR           : unsigned(7 downto 0) := "00000000";
    signal RanNum_sADDR           : unsigned(7 downto 0) := "00000000";
    signal reset_Number           : std_logic            := '0'; --high equal true
    signal success_flag10         : STD_LOGIC;
    signal success_flag30         : STD_LOGIC;
    signal success_flag50         : STD_LOGIC;

begin
    reset_Number <= '0';
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
            ADDR => sw,
            DATA => KeyInInt);

    comparator_for_success : component comparator
        port map(
            ADDR_DECR        => ADDR_DECR_mem,
            DATA_DECR        => DATA_DECR_mem,
            Clk              => Clk,
            Rst              => Rst,
            fullcounter_DECR => fullcounter_DECR_mem,
            ADDR_current_mem => ADDR_current_mem,
            DATA_current_mem => DATA_current_mem,
            success_flag10   => success_flag10,
            success_flag30   => success_flag30,
            success_flag50   => success_flag50,
            success_flag     => success_flag_LED
        );

    comparator_memory : component comparator_mem
        port map(
            Current_ADDR => ADDR_current_mem,
            Current_DATA => DATA_current_mem,
            Clk          => Clk
        );

    memory_for_decryption : decoder_mem
        port map(
            Clk              => Clk,
            Rst              => Rst,
            DATOUT_DECR      => DATOUT_DECR,
            DATOUT_ADDR      => DATOUT_ADDR,
            Target_Data_Decr => DATA_DECR_mem,
            Target_Addr_Decr => ADDR_DECR_mem,
            fullcounter_DECR => fullcounter_DECR_mem
        );

    decode_unit : component decoder
        port map(
            Clk          => Clk,
            Rst          => Rst,
            enable       => enable,
            fullcounter  => fullcounter,
            syn_success  => syn_success,
            RanNumber    => RanNumber_OUT,
            RanNum_sADDR => RanNum_sADDR,
            DATOUT_DECR  => DATOUT_DECR,
            DATOUT_ADDR  => DATOUT_ADDR,
            DATIN_ENCR   => data_for_decode,
            DATIN_ADDR   => addr_for_decode
        );

    memory_synchronization : synchronization_mem
        port map(
            Clk         => Clk,
            Rst         => Rst,
            target_addr => memory_syn_target_addr,
            data_in     => data,
            output_addr => addr_for_decode,
            fullcounter => fullcounter,
            data_out    => data_for_decode
        );

    synchronization_input : synchronization
        port map(
            Clk         => Clk,
            Rst         => Rst,
            LED_B       => LED,
            syn_success => syn_success,
            data_in_pin => data_in_pin,
            data_out    => data,
            output_addr => memory_syn_target_addr,
            syn_en      => enable
        );

    syn_LED : process(Clk, Rst)
    begin
        if (Rst = '0') then
            LED_syn_success <= '0';
        elsif (rising_edge(Clk)) then
            if (syn_success = '1') then
                LED_syn_success <= '1';
            end if;
        end if;
    end process syn_LED;

    comparator_LED : process(Clk, Rst)
    begin
        if (Rst = '0') then
            LED_comparator_success    <= '0';
            LED_comparator_fail       <= '0';
            LED_comparator_10_success <= '0';
            LED_comparator_30_success <= '0';
            LED_comparator_50_success <= '0';
        elsif (rising_edge(Clk)) then
            if (success_flag_LED = '1') then
                LED_comparator_success <= '1';
                LED_comparator_fail    <= '0';
            else
                LED_comparator_fail    <= '1';
                LED_comparator_success <= '0';
            end if;
            if (success_flag10 = '1') then
                LED_comparator_10_success <= '1';
            else
                LED_comparator_10_success <= '0';
            end if;
            if (success_flag30 = '1') then
                LED_comparator_30_success <= '1';
            else
                LED_comparator_30_success <= '0';
            end if;
            if (success_flag50 = '1') then
                LED_comparator_50_success <= '1';
            else
                LED_comparator_50_success <= '0';
            end if;
        end if;
    end process comparator_LED;

    fullcounter_syn_mem_LED : process(Clk, Rst)
    begin
        if (Rst = '0') then
            LED_synfull  <= '0';
            LED_decrfull <= '0';
        elsif (rising_edge(Clk)) then
            if (fullcounter = '1') then
                LED_synfull <= '1';
            end if;
            if (fullcounter_DECR_mem = '1') then
                LED_decrfull <= '1';
            end if;
        end if;
    end process fullcounter_syn_mem_LED;

    Testing : process(Clk, Rst, DATOUT_ADDR)
    begin
        if (Rst = '0') then
            output <= '0';
        elsif(DATOUT_ADDR > "00000000")then
            output <= '1';
        end if;
    end process Testing;
end RTL;
