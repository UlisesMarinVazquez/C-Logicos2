library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador is port
 (
    A,B : in std_logic_vector (3 downto 0);
     Z : out std_logic_vector (1 downto 0) );
end comparador;


architecture funcional of comparador is
begin
process (A,B)
    begin

        if A=B then
        Z <= "11";

        elsif A>B then
         Z <= "10" ;

        else 
        Z <= "01";

    end if;

end process;
end funcional;

NET "A3" LOC = "N3"; 
NET "A2" LOC = "E2"; 
NET "A1" LOC = "F3"; 
NET "A0" LOC = "G3"; 
NET "B3" LOC = "B4"; 
NET "B2" LOC = "K3"; 
NET "B1" LOC = "L3"; 
NET "B0" LOC = "P11"; 
NET "Z1" LOC = "G1"; 
NET "Z0" LOC = "P4"; 

A <= "0000" AFTER 100 NS, "0001" AFTER 200 NS, "0010" AFTER 300 NS, "0011" AFTER 400 NS,"0100" AFTER 500 NS,"0101" AFTER 600 NS,"0110" AFTER 700 NS,"0111" AFTER 800 NS,"1000" AFTER 900 NS,"1001" AFTER 1000 NS,"1010" AFTER 1100 NS,"1011" AFTER 1200 NS,"1100" AFTER 1300 NS,"1101" AFTER 1400 NS,"1110" AFTER 1500 NS,"1111" AFTER 1600 NS;
B <= "0000" AFTER 100 NS, "0001" AFTER 200 NS, "0010" AFTER 300 NS, "0011" AFTER 400 NS,"0100" AFTER 500 NS,"0101" AFTER 600 NS,"0110" AFTER 700 NS,"0111" AFTER 800 NS,"1000" AFTER 900 NS,"1001" AFTER 1000 NS,"1010" AFTER 1100 NS,"1011" AFTER 1200 NS,"1100" AFTER 1300 NS,"1101" AFTER 1400 NS,"1110" AFTER 1500 NS,"1111" AFTER 1600 NS;
