library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity circuito_combinacional is port (
    A,B,C  : in std_logic ;
    F  : out std_logic  );
end circuito_combinacional;


architecture eq_booleanas of circuito_combinacional is
begin

    F <= ((A or B) or (C xnor A))nor (B and C);

end eq_booleanas;

NET "A" LOC = "N3";
NET "B" LOC = "E2";
NET "C" LOC = "F3";
NET "F" LOC = "N5";

A <= '0' AFTER 100 NS, '0' AFTER 200 NS, '0' AFTER 300 NS, '0' AFTER 400 NS,'1' AFTER 500 NS,'1' AFTER 600 NS,'1' AFTER 700 NS,'1' AFTER 800 NS;
B <= '0' AFTER 100 NS, '0' AFTER 200 NS, '1' AFTER 300 NS, '1' AFTER 400 NS,'0' AFTER 500 NS,'0' AFTER 600 NS,'1' AFTER 700 NS,'1' AFTER 800 NS;
C <= '0' AFTER 100 NS, '1' AFTER 200 NS, '0' AFTER 300 NS, '1' AFTER 400 NS,'0' AFTER 500 NS,'1' AFTER 600 NS,'0' AFTER 700 NS,'1' AFTER 800 NS;
