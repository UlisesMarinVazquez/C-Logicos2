library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONVERTIDORES is 
    Port(
        RELOJ : in STD_LOGIC; -- Reloj 
        ULISES    : in STD_LOGIC_VECTOR(3 downto 0);
        SELECTOR    : in STD_LOGIC_VECTOR(1 downto 0);
        AIKO    : out STD_LOGIC_VECTOR(7 downto 0); -- LEDS DE CODIGO GRAY Y EXCESO3
        DISPLAY    : out STD_LOGIC_VECTOR(7 downto 0); -- DISPLAY 
        ANODO : out STD_LOGIC_VECTOR(3 downto 0) -- ANODO PARA ENCENDER LOS DISPLAYS
    );
end CONVERTIDORES;

architecture Behavioral of CONVERTIDORES is
    signal CONTEO    : unsigned(16 downto 0) := (others => '0');
    signal SELECCIONADOR  : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal MOSTRAR    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process (RELOJ)
    begin
        if rising_edge(RELOJ) then
            if CONTEO< 100000 then 
                CONTEO<= CONTEO+ 1;
            else 
                SELECCIONADOR <= STD_LOGIC_VECTOR(unsigned(SELECCIONADOR) + 1);
                CONTEO<= (others => '0');
            end if;
        end if;
    end process;

    process (SELECTOR, ULISES, SELECCIONADOR)
    begin
        MOSTRAR <= (others => '0'); 
        if SELECTOR = "00" then

            -- CODIGO GRAY

            ANODO <= "1111";
            DISPLAY <= "00000000";
            case ULISES is
                when "0000" => AIKO <= "00000000";
                when "0001" => AIKO <= "00000001";
                when "0010" => AIKO <= "00000011";
                when "0011" => AIKO <= "00000010";
                when "0100" => AIKO <= "00000110";
                when "0101" => AIKO <= "00000111";
                when "0110" => AIKO <= "00000101";
                when "0111" => AIKO <= "00000100";
                when "1000" => AIKO <= "00001100";
                when "1001" => AIKO <= "00001101";
                when "1010" => AIKO <= "00001111";
                when "1011" => AIKO <= "00001110";
                when "1100" => AIKO <= "00001010";
                when "1101" => AIKO <= "00001011";
                when "1110" => AIKO <= "00001001";
                when others => AIKO <= "00001000";
            end case;


        elsif SELECTOR = "01" then

            -- CODIGO EXCESO3

            ANODO <= "1111";
            DISPLAY <= "00000000";
            case ULISES is
                when "0000" => AIKO <= "00000011";
                when "0001" => AIKO <= "00000100";
                when "0010" => AIKO <= "00000101";
                when "0011" => AIKO <= "00000110";
                when "0100" => AIKO <= "00000111";
                when "0101" => AIKO <= "00001000";
                when "0110" => AIKO <= "00001001";
                when "0111" => AIKO <= "00001010";
                when "1000" => AIKO <= "00001011";
                when "1001" => AIKO <= "00001100";
                when "1010" => AIKO <= "01000011";
                when "1011" => AIKO <= "01000100";
                when "1100" => AIKO <= "01000101";
                when "1101" => AIKO <= "01000110";
                when "1110" => AIKO <= "01000111";
                when others => AIKO <= "01001000";
            end case;



        elsif SELECTOR = "10" then

            -- CODIGO BCD A DOS DISPLAYS

            AIKO <= "00000000";
            case ULISES is
                when "0000" => 
                    ANODO <= "0111";
                    DISPLAY <= "10000001";
                when "0001" =>  
                    ANODO <= "0111";
                    DISPLAY <= "11001111";
                when "0010" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10010010";
                when "0011" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10000110";
                when "0100" =>  
                    ANODO <= "0111";
                    DISPLAY <= "11001100";
                when "0101" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10100100";
                when "0110" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10100000";
                when "0111" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10001110";
                when "1000" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10000000";
                when "1001" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10001100";
                when others =>  
                    ANODO <= "0111";
                    DISPLAY <= "11111111";
            end case;


        else
            -- CODIGO OCTAL (DISPLAY)

            AIKO <= "00000000";
            case SELECCIONADOR is
                when "00" => MOSTRAR <= "0111";
                when others => MOSTRAR <= "1011";
            end case;

            case ULISES is
                when "0000" => 
                    ANODO <= "0111";
                    DISPLAY <= "10000001";
                when "0001" => 
                    ANODO <= "0111";
                    DISPLAY <= "11001111";
                when "0010" => 
                    ANODO <= "0111";
                    DISPLAY <= "10010010";
                when "0011" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10000110";
                when "0100" =>  
                    ANODO <= "0111";
                    DISPLAY <= "11001100";
                when "0101" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10100100";
                when "0110" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10100000";
                when "0111" =>  
                    ANODO <= "0111";
                    DISPLAY <= "10001110"; -- AQUÍ SE USA UN SOLO DISPLAY
                when "1000" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10000001";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when "1001" =>
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "11001111";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when "1010" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10010010";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when "1011" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10000110";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR; 
                when "1100" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "11001100";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when "1101" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10100100";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when "1110" => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10100000";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
                when others => 
                    case MOSTRAR is 
                        when "0111" => DISPLAY <= "10001110";
                        when "1011" => DISPLAY <= "11001111";
                        when others => DISPLAY <= "11111111";
                    end case;
                    ANODO <= MOSTRAR;
            end case;
        end if;
    end process;
end Behavioral;




NET RELOJ LOC = B8;

NET ULISES(3) LOC = N3;
NET ULISES(2) LOC = E2;
NET ULISES(1) LOC = F3;
NET ULISES(0) LOC = G3;

NET SELECTOR(1) LOC = L3;
NET SELECTOR(0) LOC = P11;

NET AIKO(7) LOC = G1;
NET AIKO(6) LOC = P4;
NET AIKO(5) LOC = N4;
NET AIKO(4) LOC = N5;
NET AIKO(3) LOC = P6;
NET AIKO(2) LOC = P7;
NET AIKO(1) LOC = M11;
NET AIKO(0) LOC = M5;

NET DISPLAY(7) LOC = N13;
NET DISPLAY(6) LOC = L14;
NET DISPLAY(5) LOC = H12;
NET DISPLAY(4) LOC = N14;
NET DISPLAY(3) LOC = N11;
NET DISPLAY(2) LOC = P12;
NET DISPLAY(1) LOC = L13;
NET DISPLAY(0) LOC = M12;

NET ANODO(3) LOC = F12;
NET ANODO(2) LOC = J12;
NET ANODO(1) LOC = M13;
NET ANODO(0) LOC = K14;




SELECTOR <= "11" after 100 ns; 
-- 00 BIN A GRAY (LEDS)
-- 01 BIN A EXCESO3 (LEDS)
-- 10 BIN A BCD (DISPLAYS)
-- 11 BIN A OCTAL (DISPLAYS)

ULISES <= "0000" after 100 ns, "0001" after 200 ns, "0011" after 300 ns, "0100" after 400 ns, "0101" after 500 ns, "0110" after 600 ns, "0111" after 700 ns, "1000" after 800 ns,"1001" after 900 ns, "1010" after 1000 ns, "1011" after 1100 ns, "1100" after 1200 ns, "1011" after 1300 ns, "1110" after 1400 ns, "1111" after 1500 ns, "0011" after 1600 ns;




