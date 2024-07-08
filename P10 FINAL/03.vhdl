library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SUMADORESTADOR is
    port (
        ACARREO_IN : in  STD_LOGIC;	--Selector si suma o resta
		  AIKO, ULISES: in  STD_LOGIC_VECTOR(3 downto 0); --Vector de valores de ambos digitos
        AN : out STD_LOGIC_VECTOR(3 downto 0); --Salida de suma o resta
        ACARREO_OUT: out STD_LOGIC --Acarreo
    );
end SUMADORESTADOR;

architecture Behavioral of SUMADORESTADOR is
begin

    process (ACARREO_IN, AIKO, ULISES)
        variable TEMPORAL    : STD_LOGIC_VECTOR(3 downto 0); --Declara una variable temporal de 4 bits para almacenar temporalmente el resultado
        variable LOP_temp  : unsigned(3 downto 0);
        variable HER_temp  : unsigned(3 downto 0);
        variable SUM   : unsigned(4 downto 0);

    begin
        LOP_temp := unsigned(AIKO);
        HER_temp := unsigned(ULISES);
        
        if ACARREO_IN= '0' then -- Realizar suma con acarreo
            SUM:= ('0' & LOP_temp) + ('0' & HER_temp);
            TEMPORAL := STD_LOGIC_VECTOR(sum(3 downto 0));
            AN <= TEMPORAL;
            ACARREO_OUT<= sum(4);
            
        else -- Realizar resta con acarreo
            SUM:= ('0' & LOP_temp) + ('1' & (not HER_temp)) + "0001"; -- Suma AIKO, el complemento AIKO 2 de ULISES y el acarreo
            TEMPORAL := STD_LOGIC_VECTOR(sum(3 downto 0));
            AN <= TEMPORAL;
            ACARREO_OUT<= sum(4);
        end if;
    end process;

end Behavioral;



NET "AIKO(3)" LOC = "N3"; 
NET "AIKO(2)" LOC = "E2"; 
NET "AIKO(1)" LOC = "F3"; 
NET "AIKO(0)" LOC = "G3";

NET "ULISES(3)" LOC = "B4"; 
NET "ULISES(2)" LOC = "K3"; 
NET "ULISES(1)" LOC = "L3"; 
NET "ULISES(0)" LOC = "P11";

NET "ACARREO_IN" LOC = "A7";

NET "ACARREO_OUT" LOC = "N5";
NET "AN(3)" LOC = "P6"; 
NET "AN(2)" LOC = "P7"; 
NET "AN(1)" LOC = "M11"; 
NET "AN(0)" LOC = "M5";


-- Stimulus process
stim_proc: process
begin		
   -- hold reset state for 100 ns.
   wait for 100 ns;	

   -- Test 1: Addition 3 + 2 = 5 "0101"
   AIKO<= "0011";
   ULISES <= "0010";
   ACARREO_IN<= '0';  -- Addition
   wait for 20 ns;
   
   -- Test 2: Subtraction 5 - 3 = 2 "0010"
   AIKO<= "0101";
   ULISES <= "0011";
   ACARREO_IN<= '1';  -- Subtraction
   wait for 20 ns;

   -- Test 3: Addition 8 + 8 = 16 "10000"
   AIKO<= "1000";
   ULISES <= "1000";
   ACARREO_IN<= '0';  -- Addition
   wait for 20 ns;

   -- Test 4: Subtraction 4 - 6 "11110"
   AIKO<= "0100";
   ULISES <= "0110";
   ACARREO_IN<= '1';  -- Subtraction
   wait for 20 ns;

   -- End of test
   wait;
end process;