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
