library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Convertidores is 
    Port(
        CLK : in std_logic; -- Reloj 
        BCD    : in std_logic_vector(3 downto 0);
        SEL    : in std_logic_vector(1 downto 0); 
        Display1    : out std_logic_vector(7 downto 0);
        Display2   : out std_logic_vector(7 downto 0); 
        AN : out std_logic_vector(3 downto 0) 
    );
end Convertidores;

architecture Behavioral of Convertidores is
    signal cuenta     : unsigned(16 downto 0) := (others => '0');
    signal seleccion  : std_logic_vector(1 downto 0) := "00";
    signal mostrar    : std_logic_vector(3 downto 0) := "0000";
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if cuenta < 100000 then 
                cuenta <= cuenta + 1;
            else 
                seleccion <= std_logic_vector(unsigned(seleccion) + 1);
                cuenta <= (others => '0');
            end if;
        end if;
    end process;

    process (SEL, BCD, seleccion)
    begin
        mostrar <= (others => '0'); 
        if SEL = "00" then
            -- Cdigo Gray 4 bits
            AN <= "1111";
            Display2<= "00000000";
            case BCD is
                when "0000" => Display1 <= "00000000";
                when "0001" => Display1 <= "00000001";
                when "0010" => Display1 <= "00000011";
                when "0011" => Display1 <= "00000010";
                when "0100" => Display1 <= "00000110";
                when "0101" => Display1 <= "00000111";
                when "0110" => Display1 <= "00000101";
                when "0111" => Display1 <= "00000100";
                when "1000" => Display1 <= "00001100";
                when "1001" => Display1 <= "00001101";
                when "1010" => Display1 <= "00001111";
                when "1011" => Display1 <= "00001110";
                when "1100" => Display1 <= "00001010";
                when "1101" => Display1 <= "00001011";
                when "1110" => Display1 <= "00001001";
                when others => Display1 <= "00001000";
            end case;
        elsif SEL = "01" then
            -- Cdigo Exc3 8 bits
            AN <= "1111";
            Display2<= "00000000";
            case BCD is
                when "0000" => Display1 <= "00000011";
                when "0001" => Display1 <= "00000100";
                when "0010" => Display1 <= "00000101";
                when "0011" => Display1 <= "00000110";
                when "0100" => Display1 <= "00000111";
                when "0101" => Display1 <= "00001000";
                when "0110" => Display1 <= "00001001";
                when "0111" => Display1 <= "00001010";
                when "1000" => Display1 <= "00001011";
                when "1001" => Display1 <= "00001100";
                when "1010" => Display1 <= "01000011";
                when "1011" => Display1 <= "01000100";
                when "1100" => Display1 <= "01000101";
                when "1101" => Display1 <= "01000110";
                when "1110" => Display1 <= "01000111";
                when others => Display1 <= "01001000";
            end case;
        elsif SEL = "10" then
            -- Cdigo BCD en display
            Display1 <= "00000000";
            case BCD is
                when "0000" => 
                    AN <= "0111";
                    Display2<= "10000001";
                when "0001" =>  
                    AN <= "0111";
                    Display2<= "11001111";
                when "0010" =>  
                    AN <= "0111";
                    Display2<= "10010010";
                when "0011" =>  
                    AN <= "0111";
                    Display2<= "10000110";
                when "0100" =>  
                    AN <= "0111";
                    Display2<= "11001100";
                when "0101" =>  
                    AN <= "0111";
                    Display2<= "10100100";
                when "0110" =>  
                    AN <= "0111";
                    Display2<= "10100000";
                when "0111" =>  
                    AN <= "0111";
                    Display2<= "10001110";
                when "1000" =>  
                    AN <= "0111";
                    Display2<= "10000000";
                when "1001" =>  
                    AN <= "0111";
                    Display2<= "10001100";
                when others =>  
                    AN <= "0111";
                    Display2<= "11111111";
            end case;
        else
            -- Cdigo Octal en display
            Display1 <= "00000000";
            case seleccion is
                when "00" => mostrar <= "0111";
                when others => mostrar <= "1011";
            end case;

            case BCD is
                when "0000" => 
                    AN <= "0111";
                    Display2<= "10000001";
                    
                when "0001" => 
                    AN <= "0111";
                    Display2<= "11001111";
                when "0010" => 
                    AN <= "0111";
                    Display2<= "10010010";
                when "0011" =>  
                    AN <= "0111";
                    Display2<= "10000110";
                when "0100" =>  
                    AN <= "0111";
                    Display2<= "11001100";
                when "0101" =>  
                    AN <= "0111";
                    Display2<= "10100100";
                when "0110" =>  
                    AN <= "0111";
                    Display2<= "10100000";
                when "0111" =>  
                    AN <= "0111";
                    Display2<= "10001110"; -- hasta aqu es un solo display

                when "1000" => 
                    case mostrar is 
                        when "0111" => Display2<= "10000001"; --10000110
                        when "1011" => Display2<= "11001111"; 
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;
                    
                when "1001" =>
                    case mostrar is 
                        when "0111" => Display2<= "11001111";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;

                when "1010" => 
                    case mostrar is 
                        when "0111" => Display2<= "10010010";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;

                when "1011" => 
                    case mostrar is 
                        when "0111" => Display2<= "10000110";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar; 
                when "1100" => 
                    case mostrar is 
                        when "0111" => Display2<= "11001100";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;
                when "1101" => 
                    case mostrar is 
                        when "0111" => Display2<= "10100100";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;
                when "1110" => 
                    case mostrar is 
                        when "0111" => Display2<= "10100000";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;
                when others => 
                    case mostrar is 
                        when "0111" => Display2<= "10001110";
                        when "1011" => Display2<= "11001111";
                        when others => Display2<= "11111111";
                    end case;
                    AN <= mostrar;
            end case;
        end if;
    end process;
end Behavioral;


NET "SEL(1)" LOC = "N3"; 
NET "SEL(0)" LOC = "E2";

NET "BCD(3)" LOC = "F3";
NET "BCD(2)" LOC = "G3";
NET "BCD(1)" LOC = "B4";
NET "BCD(0)" LOC = "K3";

NET "Display1(0)" LOC = "L14"; 
NET "Display1(1)" LOC = "H12"; 
NET "Display1(2)" LOC = "N14"; 
NET "Display1(3)" LOC = "N11"; 
NET "Display1(4)" LOC = "P12"; 
NET "Display1(5)" LOC = "L13"; 
NET "Display1(6)" LOC = "M12";

NET "Display2(0)" LOC = "L14"; 
NET "Display2(1)" LOC = "H12"; 
NET "Display2(2)" LOC = "N14"; 
NET "Display2(3)" LOC = "N11"; 
NET "Display2(4)" LOC = "P12"; 
NET "Display2(5)" LOC = "L13"; 
NET "Display2(6)" LOC = "M12";

NET "AN(3)" LOC = "F12";
NET "AN(2)" LOC = "J12";
NET "AN(1)" LOC = "M13";
NET "AN(0)" LOC = "K14";