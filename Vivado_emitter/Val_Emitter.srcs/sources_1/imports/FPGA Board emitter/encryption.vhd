library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity electricity_cipher is
    port(
        Clk    : in  std_logic;         --100MHz
        Rst    : in  std_logic;         --aktive low
        enable : in  std_logic;         --switch r2
        sw     : in  std_logic_vector(8 downto 1);
        output : out std_logic;
        LED_B  : out std_logic
    );

end electricity_cipher;

architecture RTL of electricity_cipher is

    component memory_randnum
        port(
            Clk                : in  std_logic;
            Rst                : in  std_logic;
            Target_ADDR_rannum : in  unsigned(7 downto 0);
            randnum_in         : in  unsigned(7 downto 0);
            Output_ADDR_rannum : in  unsigned(7 downto 0);
            rannum_out         : out unsigned(7 downto 0);
            fullcounter        : out std_logic
        );
    end component memory_randnum;

    component memory_source is
        port(
            Clk         : in  std_logic;
            Source_ADDR : in  unsigned(7 downto 0);
            CDOUT       : out unsigned(7 downto 0));
    end component;

    component memory_target is
        port(
            Clk            : in  std_logic;
            Target_EN_ADDR : in  unsigned(7 downto 0);
            data_in        : in  unsigned(7 downto 0);
            output_addr    : in  unsigned(7 downto 0);
            data_out       : out unsigned(7 downto 0));
    end component;

    component Random_Number_8
        port(
            Clk             : in  std_logic;
            Rst             : in  std_logic;
            KeyIn           : in  unsigned(7 downto 0);
            reset_Number    : in  std_logic;
            RanNum          : out unsigned(8 downto 1);
            RanNum_ADDR_out : out unsigned(7 downto 0)
        );
    end component Random_Number_8;

    component Key
        generic(
            L_BITS : natural;
            M_BITS : natural
        );
        port(
            ADDR : in  std_logic_vector(L_BITS - 1 downto 0);
            DATA : out unsigned(M_BITS - 1 downto 0)
        );
    end component Key;

    signal Source_EN_ADDR     : unsigned(7 downto 0);
    signal DReg               : unsigned(7 downto 0);
    signal RanNum             : unsigned(7 downto 0);
    signal KeyInInt           : unsigned(7 downto 0);
    signal reset_Number       : std_logic;
    signal counter            : integer;
    signal ADDRKey            : std_logic_vector(7 downto 0);
    signal clockcounter       : unsigned(19 downto 0) := (others => '0');
    signal outputclock        : std_logic             := '0';
    signal Target_ADDR        : unsigned(7 downto 0);
    signal data_in            : unsigned(7 downto 0);
    signal output_addr        : unsigned(7 downto 0);
    signal data_out           : unsigned(7 downto 0);
    signal outputcounter      : integer;
    signal test               : integer;
    signal Target_ADDR_rannum : unsigned(7 downto 0);
    signal Output_ADDR_rannum : unsigned(7 downto 0);
    signal RanNumOut          : unsigned(7 downto 0);
    signal fullcounter        : std_logic;
    signal start              : std_logic;
    signal sequenzcounter     : integer;
    signal onetime_counter    : integer;
    signal output_addr_counter : integer;
begin
    rannum_mem : component memory_randnum
        port map(
            Rst                => Rst,
            fullcounter        => fullcounter,
            Clk                => Clk,
            Target_ADDR_rannum => Target_ADDR_rannum,
            randnum_in         => RanNum,
            Output_ADDR_rannum => Output_ADDR_rannum,
            rannum_out         => RanNumOut
        );

    target_mem_E : memory_target
        port map(
            Clk            => Clk,
            Target_EN_ADDR => Target_ADDR,
            data_in        => data_in,
            output_addr    => output_addr,
            data_out       => data_out
        );

    source_mem_E : memory_source
        port map(
            Clk         => Clk,
            Source_ADDR => Source_EN_ADDR,
            CDOUT       => DReg);

    RanNumber : Random_Number_8
        port map(
            RanNum_ADDR_out => Target_ADDR_rannum,
            Clk             => Clk,
            Rst             => Rst,
            KeyIn           => KeyInInt,
            reset_Number    => reset_Number,
            RanNum          => RanNum);

    ROMKey_mem : Key
        generic map(
            L_BITS => 8,
            M_BITS => 8)
        port map(
            ADDR => ADDRKey,
            DATA => KeyInInt);

    slowclock : process(Clk)
    begin                               -- Prozess für die Outputclock
        if (rising_edge(Clk)) then
            if (clockcounter < 100000) then
                clockcounter <= clockcounter + 1; -- 1kHz
            else
                clockcounter <= "00000000000000000000";
                outputclock  <= not outputclock;
                LED_B        <= '1';    --Test für programming device
            end if;
        end if;
    end process slowclock;

    AddressKey : process(Clk, enable)
    begin
        if (enable = '1') then
            if rising_edge(Clk) then
                ADDRKey <= sw;
            end if;
        end if;

    end process AddressKey;

    Output_serial : process(Rst, Outputclock, enable)
        constant bytelen : integer                      := 7;
        constant sequenz : std_logic_vector(7 downto 0) := "11111111";
    begin
        -- test <= test + 1;
        if (Rst = '0') then
            output_addr     <= "00000000";
            outputcounter   <= 0;
            sequenzcounter  <= 0;
            output          <= '0';
            start           <= '0';
            test            <= 0;
            onetime_counter <= 0;
            output_addr_counter<= 0;
        --elsif(enable = '1') then
        elsif (rising_edge(outputclock)) then

            if (start = '1') then
                if (onetime_counter < 64) then
                    output <= data_out(bytelen - outputcounter);
                    if (outputcounter < 7) then
                        --  output <= '1';
                        outputcounter <= outputcounter + 1;
                    else
                        if(output_addr_counter < 63) then
                        output_addr_counter <= output_addr_counter + 1;
                        output_addr     <= output_addr + 1;       
                        outputcounter   <= 0;
                        end if;
                        onetime_counter <= onetime_counter + 1;
                    end if;
                end if;
            elsif (start = '0') then
                output <= sequenz(bytelen - sequenzcounter);
                if (sequenzcounter < 7) then
                    --  output <= '1';

                    sequenzcounter <= sequenzcounter + 1;
                else
                    sequenzcounter <= 0;
                    start          <= '1';
                end if;
            end if;

        end if;

    end process Output_serial;

    encryption : process(Clk, Rst, enable)
    begin
        if (Rst = '0') then
            Source_EN_ADDR     <= "00000000";
            Target_ADDR        <= "00000000";
            Output_ADDR_rannum <= "00000000";
            reset_Number       <= '0';
            counter            <= 0;
        elsif (enable = '1') then
            if (fullcounter = '1') then
                if rising_edge(Clk) then
                    if (counter < 65) then
                        data_in <= RanNumOut xor DReg;
                    end if;
                    if (counter < 63) then
                        Source_EN_ADDR     <= Source_EN_ADDR + 1;
                        Output_ADDR_rannum <= Output_ADDR_rannum + 1;
                    end if;
                    if (counter < 65) then
                        Target_ADDR <= Target_ADDR + 1;
                        counter     <= counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process encryption;
end RTL;
