library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity circuito_combinacional is port (
    A,B,C  : in std_logic ;
    F  : out std_logic  );
end circuito_combinacional;


architecture eq_booleanas of circuito_combinacional is
begin

    F <= ((A or B) nor (C xnor A))nor (B and C);

end eq_booleanas;