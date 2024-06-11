library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity circuito_combinacional is port
 (
    A,B,C,D,E,F : in std_logic ;
    X1,X2,X3,X4 : out std_logic  );
end circuito_combinacional;


architecture eq_booleanas of circuito_combinacional is
begin
    X1 <= (A xnor B);
    X2 <= ((C and D) or (A xnor B)) nand ((E xor F) and (C and D)) ;
    X3 <= (E xor F) and (C and D);
    X4 <= (E xor F) xnor ((E xor F) and (C and D));
end eq_booleanas;

NET "A" LOC = "N3"; 
NET "B" LOC = "E2"; 
NET "C" LOC = "F3"; 
NET "D" LOC = "G3"; 
NET "E" LOC = "B4"; 
NET "F" LOC = "K3"; 
NET "X1" LOC = "G1"; 
NET "X2" LOC = "P4"; 
NET "X3" LOC = "N4"; 
NET "X4" LOC = "N5";


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity circuito_combinacional is port
 (
    A : in  STD_LOGIC_VECTOR (5 downto 0) ;
    X1,X2,X3,X4 : out std_logic  );
end circuito_combinacional;


architecture eq_booleanas of circuito_combinacional is
begin
    X1 <= (A(5) xnor A(4));
    X2 <= ((A(3) and A(2)) or (A xnor A(4))) nand ((A(1) xor A(0)) and (A(3) and A(2))) ;
    X3 <= (A(1) xor A(0)) and (A(3) and A(2));
    X4 <= (A(1) xor A(0)) xnor ((A(1) xor A(0)) and (A(3) and A(2)));
end eq_booleanas;



A <= "000000" AFTER 100 NS, "000001" AFTER 200 NS, "000010" AFTER 300 NS, "000011" AFTER 400 NS,
     "000100" AFTER 500 NS, "000101" AFTER 600 NS, "000110" AFTER 700 NS, "000111" AFTER 800 NS,
     "001000" AFTER 900 NS, "001001" AFTER 1000 NS, "001010" AFTER 1100 NS, "001011" AFTER 1200 NS,
     "001100" AFTER 1300 NS, "001101" AFTER 1400 NS, "001110" AFTER 1500 NS, "001111" AFTER 1600 NS,
     "010000" AFTER 1700 NS, "010001" AFTER 1800 NS, "010010" AFTER 1900 NS, "010011" AFTER 2000 NS,
     "010100" AFTER 2100 NS, "010101" AFTER 2200 NS, "010110" AFTER 2300 NS, "010111" AFTER 2400 NS,
     "011000" AFTER 2500 NS, "011001" AFTER 2600 NS, "011010" AFTER 2700 NS, "011011" AFTER 2800 NS,
     "011100" AFTER 2900 NS, "011101" AFTER 3000 NS, "011110" AFTER 3100 NS, "011111" AFTER 3200 NS,
     "100000" AFTER 3300 NS, "100001" AFTER 3400 NS, "100010" AFTER 3500 NS, "100011" AFTER 3600 NS,
     "100100" AFTER 3700 NS, "100101" AFTER 3800 NS, "100110" AFTER 3900 NS, "100111" AFTER 4000 NS,
     "101000" AFTER 4100 NS, "101001" AFTER 4200 NS, "101010" AFTER 4300 NS, "101011" AFTER 4400 NS,
     "101100" AFTER 4500 NS, "101101" AFTER 4600 NS, "101110" AFTER 4700 NS, "101111" AFTER 4800 NS,
     "110000" AFTER 4900 NS, "110001" AFTER 5000 NS, "110010" AFTER 5100 NS, "110011" AFTER 5200 NS,
     "110100" AFTER 5300 NS, "110101" AFTER 5400 NS, "110110" AFTER 5500 NS, "110111" AFTER 5600 NS,
     "111000" AFTER 5700 NS, "111001" AFTER 5800 NS, "111010" AFTER 5900 NS, "111011" AFTER 6000 NS,
     "111100" AFTER 6100 NS, "111101" AFTER 6200 NS, "111110" AFTER 6300 NS, "111111" AFTER 6400 NS;
