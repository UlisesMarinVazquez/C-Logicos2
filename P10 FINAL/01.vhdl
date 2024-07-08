
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD is 
Port(
	ULISES: in STD_LOGIC_VECTOR(3 downto 0); --ENTRADAS
	AIKO: out STD_LOGIC_VECTOR(6 downto 0);  --SALIDAS DEL DISPLAY
	MAR_GON: out STD_LOGIC_VECTOR(3 downto 0)); -- VAR DE ANODO DE LOS DISPLAYS
end BCD;

architecture Behavioral of BCD is
begin
process (ULISES)
begin
case ULISES is
	when "0000" => AIKO <="0000001";
	when "0001" => AIKO <="1001111";
	when "0010" => AIKO <="0010010";
	when "0011" => AIKO <="0000110";
	when "0100" => AIKO <="1001100";
	when "0101" => AIKO <="0100100";
	when "0110" => AIKO <="0100000";
	when "0111" => AIKO <="0001110";
	when "1000" => AIKO <="0000000";
	when "1001" => AIKO <="0001100";
	when others => AIKO <="1111111";
end case;
MAR_GON <= "1110"; 
end process;

end Behavioral;


NET ULISES(3) LOC = B4;
NET ULISES(2) LOC = K3;
NET ULISES(1) LOC = L3;
NET ULISES(0) LOC = P11;

NET AIKO(6) LOC = L14;
NET AIKO(5) LOC = H12;
NET AIKO(4) LOC = N14;
NET AIKO(3) LOC = N11;
NET AIKO(2) LOC = P12;
NET AIKO(1) LOC = L13;
NET AIKO(0) LOC = M12;

NET MAR_GON(3) LOC = F12;
NET MAR_GON(2) LOC = J12;
NET MAR_GON(1) LOC = M13;
NET MAR_GON(0) LOC = K14;


ULISES<= "0000" after 100 ns, "0001" after 200 ns, "0001" after 300 ns, "0011" after 400 ns, "0100" after 500 ns, "0101" after 600 ns, "0111" after 700 ns, "1000" after 800 ns, "1001" after 900 ns, "1010" after 1000 ns;