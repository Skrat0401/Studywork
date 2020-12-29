    library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART_RX is
    Port ( RxD : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           TEst : out STD_LOGIC;
              RAZ : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end UART_RX;

architecture Behavioral of UART_RX is

    signal tick_UART : STD_LOGIC;                                                       -- Signal "top" passage d'un état à l'autre selon vitesse connexion série
    signal double_tick_UART : STD_LOGIC;                                                -- Signal précédent, fréquence * 2
    signal compteur_tick_UART : integer range 0 to 10420;                           -- Compteur pour tick_UART 
    signal double_compteur_tick_UART : integer range 0 to 5210;                 -- Compteur pour demi-périodes 
    type state_type is (idle, start, demiStart, b0, b1, b2, b3, b4, b5, b6, b7, stop);  -- Etats de la FSM
    signal state :state_type := idle;                                                   -- Etat par défaut
    signal RAZ_tick_UART : STD_LOGIC;                                                   -- RAZ du signal tick_UART;

begin

process(clk, RAZ, state, RAZ_tick_UART) -- Compteur classique (tick_UART)
begin
    if (raz='1') or (state = idle) or (RAZ_tick_UART = '1') then
        compteur_tick_UART <= 0;
        tick_UART <= '0';
    elsif clk = '1' and clk'event then
            if compteur_tick_UART = 10417 then
                tick_UART <= '1';
                compteur_tick_UART <= 0;
            else
                compteur_tick_UART <= compteur_tick_UART + 1;
                tick_UART <= '0';
            end if;
    end if;
end process;

process(clk, RAZ, state) -- Compteur demi-périodes (double_tick_UART car fréquence double)
begin
    if (raz='1') or (state = idle) then
        double_compteur_tick_UART <= 0;
        double_tick_UART <= '0';
    elsif clk = '1' and clk'event then
            if double_compteur_tick_UART = 5209 then
                double_tick_UART <= '1';
                double_compteur_tick_UART <= 0;
            else
                double_compteur_tick_UART <= double_compteur_tick_UART + 1;
                double_tick_UART <= '0';
            end if;
    end if;
end process;

fsm:process(clk, RAZ)   -- Machine à état
begin
    if (RAZ = '1') then
        state <= idle;
        data_out <= "00000000";
        RAZ_tick_UART <= '1';
    elsif clk = '1' and clk'event then
        case state is
            when idle => if RxD = '0' then  -- Si front descendant de RxD et en idle
                                state <= start;
                            RAZ_tick_UART <= '1';
                            end if;
            when start =>   if double_tick_UART = '1' then
                                    state <= demiStart;
                                    RAZ_tick_UART <= '0';
                                end if;
                            data_out <= "00000000";
            when demiStart => if tick_UART = '1' then
                                        state <= b0;
                                        RAZ_tick_UART <= '0';
                                    end if;
                            data_out(0) <= RxD; -- Acquisition bit 0
            when b0 =>  if tick_UART = '1' then
                                state <= b1;
                            end if;
                            data_out(1) <= RxD; -- Acquisition bit 1
            when b1 =>  if tick_UART = '1' then
                                state <= b2;
                            end if;
                            data_out(2) <= RxD; -- Acquisition bit 2
            when b2 =>  if tick_UART = '1' then
                                state <= b3;
                            end if;
                            data_out(3) <= RxD; -- Acquisition bit 3
            when b3 =>  if tick_UART = '1' then
                                state <= b4;
                            end if;
                            data_out(4) <= RxD; -- Acquisition bit 4
            when b4 =>  if tick_UART = '1' then
                                state <= b5;
                            end if;
                            data_out(5) <= RxD; -- Acquisition bit 5
            when b5 =>  if tick_UART = '1' then
                                state <= b6;
                            end if;
                            data_out(6) <= RxD; -- Acquisition bit 6
            when b6 =>  if tick_UART = '1' then
                                state <= b7;    
                            end if;
                            data_out(7) <= RxD; -- Acquisition bit 7
            when b7 =>  if tick_UART = '1' then
                                state <= stop;
                            end if;
            when stop => if tick_UART = '1' then
                                state <= idle;      -- Renvoi en idle
                            end if;
        end case;
    end if;
end process;


end Behavioral;