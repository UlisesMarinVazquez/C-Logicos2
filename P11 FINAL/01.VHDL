library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CONTADOR9999 is
    Port ( ULISES : in  STD_LOGIC; 
           AIKO : in  STD_LOGIC;  
	       MARIN : in  STD_LOGIC;
		   GONZALEZ : in  STD_LOGIC;
           ANODO : out  STD_LOGIC_VECTOR (0 to 3); -- SELECCIONA EL DISPLAY ANODO COMUN
           DISPLAY : out  STD_LOGIC_VECTOR (0 to 6));
end CONTADOR9999;

architecture Behavioral of CONTADOR9999 is
-- declaracion de funcion
function to_bcd (entrada : STD_LOGIC_VECTOR(0 to 3) ) return STD_LOGIC_VECTOR is 
	variable salida : STD_LOGIC_VECTOR(0 to 6) := "0000000";
	begin 
		case entrada is
			when "0000" => salida := "0000001"; 
			when "0001" => salida := "1001111";
			when "0010" => salida := "0010010";
			when "0011" => salida := "0000110";
			when "0100" => salida := "1001100";
			when "0101" => salida := "0100100";
			when "0110" => salida := "0100000";
			when "0111" => salida := "0001110";
			when "1000" => salida := "0000000";
			when "1001" => salida := "0000100";
			when others => salida := "1111111";
		end case;
		return salida;	
end to_bcd;

-- DECLARACION DE LAS SEÑALES 

signal ULISES_INCREMENTO : integer range 0 to 1_000_000; -- incremnta 1 en cada segundo
signal MARIN_AIKO : integer range 0 to 100_000; -- frecuencia de 125HZ en la duracion de cada dysplay(8ms)
signal MUX : STD_LOGIC_VECTOR (0 to 1):= "00"; --entrada del multiplexor para los displays 
signal MUX_SALIDA : STD_LOGIC_VECTOR (0 to 3):= "1111";-- da la salida del multiplexor para los displays
signal ACARREO_1, ACARREO_2, ACARREO_3, ACARREO_4: STD_LOGIC_VECTOR (0 to 3):="0000";-- ACARREO_4 contiene el ultimo numero

begin

-- process para incrementar y decrementar el CONTADOR9999 y display, tambien para obtener la entrada del multiplexor

process(ULISES,MARIN_AIKO,ULISES_INCREMENTO,AIKO, MARIN, GONZALEZ)
begin 

--CONTADOR9999 de display
	if (ULISES'event and ULISES = '1') then
		if (MARIN_AIKO < 100_000) then 
			MARIN_AIKO <= MARIN_AIKO + 1;
		else 
			MUX <= MUX + 1; 
			MARIN_AIKO <= 0;				
		end if;

--CONTADOR9999 por cada segundo	
		if (ULISES_INCREMENTO < 1_000_000) then 
			ULISES_INCREMENTO <= ULISES_INCREMENTO + 1;
		else 
			ULISES_INCREMENTO <= 0;
			--Algoritmo para llevar la cuenta 
			if(AIKO = '0') then 
				if (ACARREO_4 > "0000") then 
					ACARREO_4 <= ACARREO_4 - 1;
				elsif (ACARREO_3 > "0000") then
					ACARREO_3 <= ACARREO_3 - 1;
					ACARREO_4 <= "1001";
				elsif (ACARREO_2 > "0000") then
					ACARREO_2 <= ACARREO_2 - 1;
					ACARREO_3 <= "1001";
				elsif (ACARREO_1 > "0000") then
					ACARREO_1 <= ACARREO_1 - 1;
					ACARREO_2 <= "1001";
				else
					ACARREO_1 <= "1001";
					ACARREO_2 <= "1001";
					ACARREO_3 <= "1001";
					ACARREO_4 <= "1001";
				end if;
			else
				if (ACARREO_4 < "1001") then 
					ACARREO_4 <= ACARREO_4 + 1;
				elsif (ACARREO_3 < "1001") then
					ACARREO_3 <= ACARREO_3 + 1;
					ACARREO_4 <= "0000";
				elsif (ACARREO_2 < "1001") then
					ACARREO_2 <= ACARREO_2 + 1;
					ACARREO_3 <= "0000";
				elsif (ACARREO_1 < "1001") then
					ACARREO_1 <= ACARREO_1 + 1;
					ACARREO_2 <= "0000";
				else
					ACARREO_1 <= "0000";
					ACARREO_2 <= "0000";
					ACARREO_3 <= "0000";
					ACARREO_4 <= "0000";
				end if;
			end if; 


		end if;
	end if;
	if (MARIN = '1') then
		ACARREO_1 <= "0000";
		ACARREO_2 <= "0000";
		ACARREO_3 <= "0000";
		ACARREO_4 <= "0000";
	elsif (GONZALEZ = '1') then 
		ACARREO_1 <= "1001";
		ACARREO_2 <= "1001";
		ACARREO_3 <= "1001";
		ACARREO_4 <= "0101";
	end if;
end process;

-- process para la obtencion de la salida para la salida del multiplexor
process(MUX,ACARREO_1,ACARREO_2,ACARREO_3,ACARREO_4)
begin
	case MUX is
		when "00"    => MUX_SALIDA <= "0111";
		when "01"    => MUX_SALIDA <= "1011";
		when "10"    => MUX_SALIDA <= "1101";
		when others  => MUX_SALIDA <= "1110";
	end case;
	
	case MUX_SALIDA is 
		when "0111" => DISPLAY <= to_bcd(ACARREO_1);--ACARREO_1;
		when "1011" => DISPLAY <= to_bcd(ACARREO_2);--ACARREO_2;
		when "1101" => DISPLAY <= to_bcd(ACARREO_3);--ACARREO_3;
		when others => DISPLAY <= to_bcd(ACARREO_4);--ACARREO_4;
	end case;
end process;

ANODO <= MUX_SALIDA;

end Behavioral;



NET "ULISES" LOC = "A7"; 
NET "AIKO" LOC = "M4";
NET "MARIN" LOC = "C11"; 
NET "GONZALEZ" LOC = "G12";

NET DISPLAY(0) LOC = L14;
NET DISPLAY(1) LOC = H12;
NET DISPLAY(2) LOC = N14;
NET DISPLAY(3) LOC = N11;
NET DISPLAY(4) LOC = P12;
NET DISPLAY(5) LOC = L13;
NET DISPLAY(6) LOC = M12;

NET ANODO(3) LOC = F12;
NET ANODO(2) LOC = J12;
NET ANODO(1) LOC = M13;
NET ANODO(0) LOC = K14;

