library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decryption_top is
    port(
        Clk                    : in  std_logic; --100MHz
        Rst                    : in  std_logic; --aktive low
        enable                 : in  std_logic; --switch r2
        data_in_pin            : in  std_logic;
        sw                     : in  std_logic_vector(8 downto 1);
        LED_syn_success        : out std_logic;
        LED_comparator_success : out std_logic;
        LED_comparator_fail    : out std_logic
        -- output   : out std_logic
    );

end decryption_top;

architecture RTL of decryption_top is

    signal LED         : std_logic;
    signal syn_success : std_logic;
    signal data        : unsigned(7 downto 0);

    component comparator
        port(
            ADDR_DECR        : out unsigned(7 downto 0);
            DATA_DECR        : in  unsigned(7 downto 0);
            Clk              : in  STD_LOGIC;
            Rst              : in  STD_LOGIC;
            fullcounter_DECR : in  std_logic;
            ADDR_current_mem : out unsigned(7 downto 0);
            DATA_current_mem : in  unsigned(7 downto 0);
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
            Target_Addr_Decr : in  unsigned(7 downto 0)
        );
    end component decoder_mem;

    component decoder
        port(
            Clk         : in  std_logic;
            Rst         : in  std_logic;
            enable      : in  std_logic;
            fullcounter : in  std_logic;
            syn_success : in  std_logic;
            ADDR_Key    : in  std_logic_vector(7 downto 0);
            DATOUT_DECR : out unsigned(7 downto 0);
            DATOUT_ADDR : out unsigned(7 downto 0);
            DATIN_ENCR  : in  unsigned(7 downto 0);
            DATIN_ADDR  : out unsigned(7 downto 0)
        );
    end component decoder;

    component synchronization_mem
        port(
            Clk         : in  std_logic;
            target_addr : in  unsigned(7 downto 0);
            data_in     : in  unsigned(7 downto 0);
            output_addr : in  unsigned(7 downto 0);
            fullcounter : out std_logic;
            data_out    : out unsigned(7 downto 0)
        );
    end component synchronization_mem;

    component synchronization
        port(
            clk         : in  std_logic;
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

begin

    comparator_for_success : component comparator
        port map(
            ADDR_DECR        => ADDR_DECR_mem,
            DATA_DECR        => DATA_DECR_mem,
            Clk              => Clk,
            Rst              => Rst,
            fullcounter_DECR => fullcounter_DECR_mem,
            ADDR_current_mem => ADDR_current_mem,
            DATA_current_mem => DATA_current_mem,
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
            Target_Addr_Decr => ADDR_DECR_mem
        );

    decode_unit : component decoder
        port map(
            Clk         => Clk,
            Rst         => Rst,
            enable      => enable,
            fullcounter => fullcounter,
            syn_success => syn_success,
            ADDR_Key    => sw,
            DATOUT_DECR => DATOUT_DECR,
            DATOUT_ADDR => DATOUT_ADDR,
            DATIN_ENCR  => data_for_decode,
            DATIN_ADDR  => addr_for_decode
        );

    memory_synchronization : synchronization_mem
        port map(
            Clk         => Clk,
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
            LED_comparator_success <= '0';
            LED_comparator_fail    <= '0';
        elsif (rising_edge(Clk)) then
            if (success_flag_LED = '1') then
                LED_comparator_success <= '1';
                LED_comparator_fail    <= '0';
            else
                LED_comparator_fail    <= '1';
                LED_comparator_success <= '0';
            end if;
        end if;
    end process comparator_LED;

end RTL;
