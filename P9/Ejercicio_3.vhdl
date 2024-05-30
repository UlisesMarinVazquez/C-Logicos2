library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador is port
 (
    A,B : in std_logic_vector (1 downto 0);
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