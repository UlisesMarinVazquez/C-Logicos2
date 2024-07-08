library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BCD_to_7Segment is
    Port ( BCD : in  STD_LOGIC_VECTOR (3 downto 0);
            AN: in STD_LOGIC_VECTOR (3 downto 0);
           Display1 : out STD_LOGIC_VECTOR (6 downto 0)); -- 7 segmentos: a, b, c, d, e, f, g
end BCD_to_7Segment;

architecture Behavioral of BCD_to_7Segment is
begin
    process(BCD)
    begin
        case BCD is
            when "0000" => Display1 <= "0000001"; -- 0
            when "0001" => Display1 <= "1001111"; -- 1
            when "0010" => Display1 <= "0010010"; -- 2
            when "0011" => Display1 <= "0000110"; -- 3
            when "0100" => Display1 <= "1001100"; -- 4
            when "0101" => Display1 <= "0100100"; -- 5
            when "0110" => Display1 <= "0100000"; -- 6
            when "0111" => Display1 <= "0001111"; -- 7
            when "1000" => Display1 <= "0000000"; -- 8
            when "1001" => Display1 <= "0000100"; -- 9
            when others => Display1 <= "1111111"; -- Apagado
            AN <= "1110"; -- Activar solo el primer display (anodo bajo activo)
        end case;
    end process;
end Behavioral;


NET "BCD(0)" LOC = "N3"; 
NET "BCD(1)" LOC = "E2"; 
NET "BCD(2)" LOC = "F3"; 
NET "BCD(3)" LOC = "G3"; 

NET "Display1(6)" LOC = "L14"; 
NET "Display1(5)" LOC = "H12"; 
NET "Display1(4)" LOC = "N14"; 
NET "Display1(3)" LOC = "N11"; 
NET "Display1(2)" LOC = "P12"; 
NET "Display1(1)" LOC = "L13"; 
NET "Display1(0)" LOC = "M12";

NET "AN(0)" LOC = "F12";
NET "AN(1)" LOC = "J12"; 
NET "AN(2)" LOC = "M13"; 
NET "AN(3)" LOC = "K14";

BCD <= "0000" AFTER 100 NS, "0001" AFTER 200 NS, "0010" AFTER 300 NS, "0011" AFTER 400 NS, "0100" AFTER 500 NS, "0101" AFTER 600 NS, "0110" AFTER 700 NS, "0111" AFTER 800 NS, "1000" AFTER 900 NS, "1001" AFTER 1000 NS, "1010" AFTER 1100 NS, "1011" AFTER 1200 NS, "1100" AFTER 1300 NS, "1101" AFTER 1400 NS, "1110" AFTER 1500 NS, "1111" AFTER 1600 NS; 
