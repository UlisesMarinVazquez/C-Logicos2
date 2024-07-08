library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SU_RE_MU_EN is
    Port ( CLK : in  STD_LOGIC; -- cristal 50 MHz
           ULISES : in  STD_LOGIC_VECTOR (0 to 3); --numero 1
           AIKO : in  STD_LOGIC_VECTOR (0 to 3);--numero 2
			  SELECTOR : in  STD_LOGIC_VECTOR (0 to 1);--selector
           ANODO : out  STD_LOGIC_VECTOR (0 to 3);
           DISPLAY : out  STD_LOGIC_VECTOR (0 to 6));
end SU_RE_MU_EN;

architecture Behavioral of SU_RE_MU_EN is

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
signal CONTEO : integer range 0 to 100_000; --contador para conseguir una frecuencia de 125HZ en la duracion de cada dysplay(8ms)
signal MUX : STD_LOGIC_VECTOR (0 to 1):= "00"; --entrada del multiplexor para los displays 
signal MUX_SALIDA : STD_LOGIC_VECTOR (0 to 3):= "1111";-- da la salida del multiplexor para los displays
signal NO_BINARIO_BCD : STD_LOGIC_VECTOR (0 to 11);-- contiene un numero binario largo donde cada 4 bits es un numero en bcd


begin

-- process para incrementar y decrementar el contador, tambien para obtener la entrada del multiplexor
process(CLK,CONTEO)
begin 
	if (CLK'event and CLK = '1') then
		if (CONTEO < 100_000) then 
			CONTEO <= CONTEO + 1;
		else 
			MUX <= MUX + 1; 
			CONTEO <= 0;				
		end if;
	end if;
end process;

-- process para la obtencion de la salida para la salida del multiplexor
process(MUX, AIKO, SELECTOR, ULISES)
begin
	case MUX is
		when "00"    => MUX_SALIDA <= "0111";
		when "01"    => MUX_SALIDA <= "1011";
		when "10"    => MUX_SALIDA <= "1101";
		when others  => MUX_SALIDA <= "1110";
	end case;
-- selector y operaciones 
	case SELECTOR is
		when "00" => NO_BINARIO_BCD <= "101010101010"; 
		when "01" => NO_BINARIO_BCD <= suma(ULISES,AIKO);
		when "10" => NO_BINARIO_BCD <= resta(ULISES,AIKO);
		when others => NO_BINARIO_BCD <= multiplicacion(ULISES,AIKO);
	end case;
---------------------------
	if(SELECTOR = "00")then 
		case MUX_SALIDA is 
			when "0111" => DISPLAY <= base(ULISES(0),AIKO(0));
			when "1011" => DISPLAY <= base(ULISES(1),AIKO(1));
			when "1101" => DISPLAY <= base(ULISES(2),AIKO(2));
			when others => DISPLAY <= base(ULISES(3),AIKO(3));
		end case;
	else
		case MUX_SALIDA is 
			when "0111" => DISPLAY <= to_bcd(NO_BINARIO_BCD(0 to 3));
			when "1011" => DISPLAY <= to_bcd(NO_BINARIO_BCD(4 to 7));
			when "1101" => DISPLAY <= to_bcd(NO_BINARIO_BCD(8 to 11));
			when others => DISPLAY <= "1111111";
		end case;
	end if;
end process;

ANODO <= MUX_SALIDA;

end Behavioral;



NET "CLK" LOC = "B8";

NET "ULISES(0)" LOC = "N3"; 
NET "ULISES(1)" LOC = "E2"; 
NET "ULISES(2)" LOC = "F3"; 
NET "ULISES(3)" LOC = "G3";

NET "AIKO(0)" LOC = "B4"; 
NET "AIKO(1)" LOC = "K3"; 
NET "AIKO(2)" LOC = "L3"; 
NET "AIKO(3)" LOC = "P11";


NET "SELECTOR(O)" LOC =  "A7";
NET "SELECTOR(1)" LOC =  "M4";

NET "ANODO(3)" LOC = "P6"; 
NET "ANODO(2)" LOC = "P7"; 
NET "ANODO(1)" LOC = "M11"; 
NET "ANODO(0)" LOC = "M5";


NET "DISPLAY(6)" LOC = "L14"; 
NET "DISPLAY(5)" LOC = "H12"; 
NET "DISPLAY(4)" LOC = "N14"; 
NET "DISPLAY(3)" LOC = "N11"; 
NET "DISPLAY(2)" LOC = "P12"; 
NET "DISPLAY(1)" LOC = "L13"; 
NET "DISPLAY(0)" LOC = "M12";


-- Stimulus process
stim_proc: process
begin		
   -- hold reset state for 100 ns.
   wait for 100 ns;	

   -- Test 1: Addition 3 + 2 = 5 "0101"
   ULISES<= "0011";
   AIKO<= "0010";
   SELECTOR<= "01";  -- Addition
   wait for 20 ns;
   
   -- Test 2: Subtraction 5 - 3 = 2 "0010"
   ULISES<= "0101";
   AIKO<= "0011";
   SELECTOR<= "10";  -- Subtraction
   wait for 20 ns;

   -- MULTIPLICACION 
   ULISES<= "1000";
   AIKO<= "1000";
   SELECTOR<= "11";  -- Addition
   wait for 20 ns;

   -- ENTRADAS
   ULISES<= "0100";
   AIKO<= "0110";
   SELECTOR<= "00";  -- Subtraction
   wait for 20 ns;

   -- End of test
   wait;
end process;