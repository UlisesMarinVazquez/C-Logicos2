library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CALCULADORA is
    Port ( CAB : in  STD_LOGIC;-- cristal 50 MHz
           HER : in  STD_LOGIC_VECTOR (0 to 3);--numero 1
           LOP : in  STD_LOGIC_VECTOR (0 to 3);--numero 2
		   SAL : in  STD_LOGIC_VECTOR (0 to 1);--selector
           CAR : out  STD_LOGIC_VECTOR (0 to 3);
           ALE : out  STD_LOGIC_VECTOR (0 to 6));
end CALCULADORA;

architecture Behavioral of CALCULADORA is

--Funciones 

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
			when "1010" => salida := "1111111";
			when "1111"	=> salida := "1111110";--signo de menos
			when others => salida := "1111111";
		end case;
		return salida;	
end to_bcd;

function suma (a : std_logic_vector(0 to 3); b : std_logic_vector(0 to 3)) return std_logic_vector is 
	variable salida : std_logic_vector(0 to 11) := "101000000000";
	variable AUX_1,AUX_2 : std_logic_vector(0 to 3);
	variable c : std_logic_vector(0 to 4);
	
	begin 
		if (a > "1001") then 
			AUX_1 := a - "1010";
			salida := salida + "10000";
		else 
			AUX_1 := a;
		end if;
		
		if (b > "1001") then 
			AUX_2 := b - "1010";
			salida := salida + "10000";
		else 
			AUX_2 := b;
		end if;
		
		c := ('0' & AUX_1) + ('0' & AUX_2);
		 
		if(c > "1001") then 
			salida := salida + (c - "1010") + "10000";
		else 
			salida := salida + c;
		end if;
		return salida;	
end suma;

function resta (a : std_logic_vector(0 to 3); b : std_logic_vector(0 to 3)) return std_logic_vector is 
	variable salida : std_logic_vector(0 to 11) := "101000000000";
	variable c : std_logic_vector(0 to 3);
	
	begin 
		if(B <= A) then 
			salida := salida + (A - B);
		else
			c := not(a + not(B));
			salida := salida + "10100000000";
			if(c > "1001") then 
				salida := salida + (c - "1010") + "0000010000";
			else
				salida := salida + c;
			end if;
		end if;
		return salida;	
end resta;

function multiplicacion (numero : std_logic_vector(0 to 3); cuenta : std_logic_vector(0 to 3)) return std_logic_vector is 
	
	variable sumatoria : std_logic_vector(0 to 11) := "000000000000";
	variable AUX_1, AUX_2 : std_logic_vector(0 to 11) := "000000000000";
	--variable ciclos : integer := to_integer(unsigned(cuenta));
	
	begin 
	
	for i in cuenta'range loop
		AUX_1 := suma(numero, sumatoria(8 to 11));
		if ((AUX_1(4 to 7) + sumatoria(4 to 7)) < "1010") then 
			sumatoria := sumatoria(0 to 3) & (sumatoria(4 to 7) + AUX_1(4 to 7)) & AUX_1(8 to 11);
		else 
			AUX_2 := suma(AUX_1( 4 to 7), sumatoria(4 to 7));
			sumatoria := (sumatoria(0 to 3) + AUX_2(4 to 7)) & (AUX_2(8 to 11) + AUX_1(4 to 7)) & AUX_1(8 to 11); 
		end if;
	end loop;
	
	if(sumatoria(0 to 3) > "1010") then 
		sumatoria := sumatoria - "101000000000";
	end if;		
	
	return sumatoria;
end multiplicacion;

function base (a : std_logic; b : std_logic ) return std_logic_vector is 
	variable salida : std_logic_vector(0 to 6) := "0000000";
	
	begin 
		case a is 
			when    '0' => salida := "0000000";
			when others => salida := "1000000";
		end case;
		case b is 
			when    '0' => salida := salida + "0000000";
			when others => salida := salida + "0001000";
		end case;
	
	return not(salida);	
end base;

--declaracion de signals
signal LOP_HER : integer range 0 to 100_000; --contador para conseguir una frecuencia de 125HZ en la duracion de cada dysplay(8ms)
signal ALE_ISA : STD_LOGIC_VECTOR (0 to 1):= "00"; --entrada del multiplexor para los displays 
signal ISA_ALE : STD_LOGIC_VECTOR (0 to 3):= "1111";-- da la salida del multiplexor para los displays
signal CAR_SAL : STD_LOGIC_VECTOR (0 to 11);-- contiene un numero bianario largo donde cada 4 bits es un numero en bcd


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
process(ALE_ISA, LOP, SAL, HER)
begin
	case ALE_ISA is
		when "00"    => ISA_ALE <= "0111";
		when "01"    => ISA_ALE <= "1011";
		when "10"    => ISA_ALE <= "1101";
		when others  => ISA_ALE <= "1110";
	end case;
-- selector y operaciones 
	case SAL is
		when "00" => CAR_SAL <= "101010101010"; 
		when "01" => CAR_SAL <= suma(HER,LOP);
		when "10" => CAR_SAL <= resta(HER,LOP);
		when others => CAR_SAL <= multiplicacion(HER,LOP);
	end case;
---------------------------
	if(SAL = "00")then 
		case ISA_ALE is 
			when "0111" => ALE <= base(HER(0),LOP(0));
			when "1011" => ALE <= base(HER(1),LOP(1));
			when "1101" => ALE <= base(HER(2),LOP(2));
			when others => ALE <= base(HER(3),LOP(3));
		end case;
	else
		case ISA_ALE is 
			when "0111" => ALE <= to_bcd(CAR_SAL(0 to 3));
			when "1011" => ALE <= to_bcd(CAR_SAL(4 to 7));
			when "1101" => ALE <= to_bcd(CAR_SAL(8 to 11));
			when others => ALE <= "1111111";
		end case;
	end if;
end process;

CAR <= ISA_ALE;

end Behavioral;



NET CAB LOC = "B8"; 

NET SAL(0) LOC = "A7";
NET SAL(1) LOC = "M4";

NET HER(0) LOC = "N3";
NET HER(1) LOC = "E2";
NET HER(2) LOC = "F3";
NET HER(3) LOC = "G3";

NET LOP(0) LOC = "B4";
NET LOP(1) LOC = "K3";
NET LOP(2) LOC = "L3";
NET LOP(3) LOC = "P11";






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