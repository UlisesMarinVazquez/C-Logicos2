library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BOLETA is
    Port ( CAB : in  STD_LOGIC;
           HER : in  STD_LOGIC;
           CAR : out  STD_LOGIC_VECTOR (0 to 3);
           ALE : out  STD_LOGIC_VECTOR (0 to 6));
end BOLETA;

architecture Behavioral of BOLETA is

--function to_bcd (entrada : std_logic_vector(0 to 3) ) return std_logic_vector is 
--	variable salida : std_logic_vector(0 to 6) := "0000000";
--	begin 0560
--		case entrada is
--			when "0000" => salida := "0000001"; 
--			when "0001" => salida := "1001111";
--			when "0010" => salida := "0010010";
--			when "0011" => salida := "0000110";
--			when "0100" => salida := "1001100";
--			when "0101" => salida := "0100100";
--			when "0110" => salida := "0100000";
--			when "0111" => salida := "0001110";
--			when "1000" => salida := "0000000";
--			when "1001" => salida := "0000100";
--			when others => salida := "1111111";
--		end case;
--		return salida;	
--end to_bcd;

--declaracion de signals
signal LOP_HER : integer range 0 to 100_000; --contador para conseguir una frecuencia de 125HZ en la duracion de cada dysplay(8ms)
signal ALE_ISA : STD_LOGIC_VECTOR (0 to 1):= "00"; --entrada del multiplexor para los displays 
signal ISA_ALE : STD_LOGIC_VECTOR (0 to 3):= "1111";-- da la salida del multiplexor para los displays
signal CAR_1, CAR_2, CAR_3, CAR_4 : STD_LOGIC_VECTOR (0 to 6);-- CAR_4 contiene el ultimo numero

begin


-- process para incrementar y decrementar el contador, tambien para obtener la entrada del multiplexor
process(CAB,LOP_HER)
begin 
	if (CAB'event and CAB = '1') then
		if (LOP_HER < 100_000) then 
			LOP_HER <= LOP_HER + 1;
		else 
			ALE_ISA <= ALE_ISA + 1; 
			LOP_HER <= 0;				
		end if;
	end if;
end process;

-- process para la obtencion de la salida para la salida del multiplexor
process(ALE_ISA, HER)
begin
	case ALE_ISA is
		when "00"    => ISA_ALE <= "0111";
		when "01"    => ISA_ALE <= "1011";
		when "10"    => ISA_ALE <= "1101";
		when others  => ISA_ALE <= "1110";
	end case;
	--case para mostrar la salida en cada display
	
	if (HER = '0')then --boleta alexis

        CAR_1 <= "0000001";
		CAR_2 <= "0001111";
		CAR_3 <= "0000100";
		CAR_4 <= "1001100";
		
	else --boleta isaac


        CAR_1 <= "1001111";
		CAR_2 <= "0000001";
		CAR_3 <= "0000110";
		CAR_4 <= "0000001";
	end if;
		
	case ISA_ALE is 
		when "0111" => ALE <= CAR_1;
		when "1011" => ALE <= CAR_2;
		when "1101" => ALE <= CAR_3;
		when others => ALE <= CAR_4;
	end case;
end process;

CAR <= ISA_ALE;


end Behavioral;



NET CAB LOC = "B8"; 

NET HER LOC = "N3";


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
