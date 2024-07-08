library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CONTADOR is
    Port ( CAB : in  STD_LOGIC;
           HER : in  STD_LOGIC;
			  LOP : in  STD_LOGIC;
			  SAL : in  STD_LOGIC;
           CAR : out  STD_LOGIC_VECTOR (0 to 3);
           ALE : out  STD_LOGIC_VECTOR (0 to 6));
end CONTADOR;

architecture Behavioral of CONTADOR is
-- declaracion de funcion
function to_bcd (entrada : std_logic_vector(0 to 3) ) return std_logic_vector is 
	variable salida : std_logic_vector(0 to 6) := "0000000";
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

--declaracion de signals
signal CAB_SAL : integer range 0 to 1_000_000; --contador para incremntar 1 en cada segundo
signal LOP_HER : integer range 0 to 100_000; --contador para conseguir una frecuencia de 125HZ en la duracion de cada dysplay(8ms)
signal ALE_ISA : STD_LOGIC_VECTOR (0 to 1):= "00"; --entrada del multiplexor para los displays 
signal ISA_ALE : STD_LOGIC_VECTOR (0 to 3):= "1111";-- da la salida del multiplexor para los displays
signal CAR_1, CAR_2, CAR_3, CAR_4: STD_LOGIC_VECTOR (0 to 3):="0000";-- CAR_4 contiene el ultimo numero

begin

-- process para incrementar y decrementar el contador(contador y display), tambien para obtener la entrada del multiplexor
process(CAB,LOP_HER,CAB_SAL,HER, LOP, SAL)
begin 
--contador de display
	if (CAB'event and CAB = '1') then
		if (LOP_HER < 100_000) then 
			LOP_HER <= LOP_HER + 1;
		else 
			ALE_ISA <= ALE_ISA + 1; 
			LOP_HER <= 0;				
		end if;
--contador por cada segundo	
		if (CAB_SAL < 1_000_000) then 
			CAB_SAL <= CAB_SAL + 1;
		else 
			CAB_SAL <= 0;
			--Algoritmo para llevar la cuenta 
			if(HER = '0') then 
				if (CAR_4 > "0000") then 
					CAR_4 <= CAR_4 - 1;
				elsif (CAR_3 > "0000") then
					CAR_3 <= CAR_3 - 1;
					CAR_4 <= "1001";
				elsif (CAR_2 > "0000") then
					CAR_2 <= CAR_2 - 1;
					CAR_3 <= "1001";
				elsif (CAR_1 > "0000") then
					CAR_1 <= CAR_1 - 1;
					CAR_2 <= "1001";
				else
					CAR_1 <= "1001";
					CAR_2 <= "1001";
					CAR_3 <= "1001";
					CAR_4 <= "1001";
				end if;
			else
				if (CAR_4 < "1001") then 
					CAR_4 <= CAR_4 + 1;
				elsif (CAR_3 < "1001") then
					CAR_3 <= CAR_3 + 1;
					CAR_4 <= "0000";
				elsif (CAR_2 < "1001") then
					CAR_2 <= CAR_2 + 1;
					CAR_3 <= "0000";
				elsif (CAR_1 < "1001") then
					CAR_1 <= CAR_1 + 1;
					CAR_2 <= "0000";
				else
					CAR_1 <= "0000";
					CAR_2 <= "0000";
					CAR_3 <= "0000";
					CAR_4 <= "0000";
				end if;
			end if; 
			------------------------------------------------
		end if;
	end if;
	if (LOP = '1') then
		CAR_1 <= "0000";
		CAR_2 <= "0000";
		CAR_3 <= "0000";
		CAR_4 <= "0000";
	elsif (SAL = '1') then 
		CAR_1 <= "1001";
		CAR_2 <= "1001";
		CAR_3 <= "1001";
		CAR_4 <= "0101";
	end if;
end process;

-- process para la obtencion de la salida para la salida del multiplexor
process(ALE_ISA,CAR_1,CAR_2,CAR_3,CAR_4)
begin
	case ALE_ISA is
		when "00"    => ISA_ALE <= "0111";
		when "01"    => ISA_ALE <= "1011";
		when "10"    => ISA_ALE <= "1101";
		when others  => ISA_ALE <= "1110";
	end case;
	
	case ISA_ALE is 
		when "0111" => ALE <= to_bcd(CAR_1);--CAR_1;
		when "1011" => ALE <= to_bcd(CAR_2);--CAR_2;
		when "1101" => ALE <= to_bcd(CAR_3);--CAR_3;
		when others => ALE <= to_bcd(CAR_4);--CAR_4;
	end case;
end process;

CAR <= ISA_ALE;

end Behavioral;



NET CAB LOC = "B8"; 

NET HER LOC = "N3";
NET LOP LOC = "E2";
NET SAL LOC = "F3";


NET ALE(0) LOC = L14;
NET ALE(1) LOC = H12;
NET ALE(2) LOC = N14;
NET ALE(3) LOC = N11;
NET ALE(4) LOC = P12;
NET ALE(5) LOC = L13;
NET ALE(6) LOC = M12;

NET CAR(3) LOC = F12;
NET CAR(2) LOC = J12;
NET CAR(1) LOC = M13;
NET CAR(0) LOC = K14;
