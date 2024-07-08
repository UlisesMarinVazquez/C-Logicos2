library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Practica10_3 is
    port (
        ACARREO_IN : in  std_logic;	--Selector si suma o resta
		  A, B: in  std_logic_vector(3 downto 0); --Vector de valores de ambos digitos
        AN : out std_logic_vector(3 downto 0); --Salida de suma o resta
        ACARREO_OUT: out std_logic --Acarreo
    );
end Practica10_3;

architecture Behavioral of Practica10_3 is
begin

    process (ACARREO_IN, A, B)
        variable temp    : std_logic_vector(3 downto 0); --Declara una variable temporal de 4 bits para almacenar temporalmente el resultado
        variable LOP_temp  : unsigned(3 downto 0);
        variable HER_temp  : unsigned(3 downto 0);
        variable sum     : unsigned(4 downto 0);
    begin
        LOP_temp := unsigned(A);
        HER_temp := unsigned(B);
        
        if ACARREO_IN= '0' then -- Realizar suma con acarreo
            sum := ('0' & LOP_temp) + ('0' & HER_temp);
            temp := std_logic_vector(sum(3 downto 0));
            AN <= temp;
            ACARREO_OUT<= sum(4);
        else -- Realizar resta con acarreo
            sum := ('0' & LOP_temp) + ('1' & (not HER_temp)) + "0001"; -- Suma A, el complemento a 2 de B y el acarreo
            temp := std_logic_vector(sum(3 downto 0));
            AN <= temp;
            ACARREO_OUT<= sum(4);
        end if;
    end process;

end Behavioral;



NET "A(3)" LOC = "N3"; 
NET "A(2)" LOC = "E2"; 
NET "A(1)" LOC = "F3"; 
NET "A(0)" LOC = "G3";

NET "B(3)" LOC = "B4"; 
NET "B(2)" LOC = "K3"; 
NET "B(1)" LOC = "L3"; 
NET "B(0)" LOC = "P11";

NET "ACARREO_IN" LOC = "A7";

NET "ACA" LOC = "N5";
NET "AN(3)" LOC = "P6"; 
NET "AN(2)" LOC = "P7"; 
NET "AN1)" LOC = "M11"; 
NET "AN(0)" LOC = "M5";



-- Stimulus process
stim_proc: process
begin		
   -- hold reset state for 100 ns.
   wait for 100 ns;	

   -- insert stimulus here 

   -- Test 1: Addition 3 + 2 = 5 "0101"
   A<= "0011";
   B <= "0010";
   ACARREO_IN<= '0';  -- Addition
   wait for 20 ns;
   
   -- Test 2: Subtraction 5 - 3 = 2 "0010"
   A<= "0101";
   B <= "0011";
   ACARREO_IN<= '1';  -- Subtraction
   wait for 20 ns;

   -- Test 3: Addition 8 + 8 = 16 "10000"
   A<= "1000";
   B <= "1000";
   ACARREO_IN<= '0';  -- Addition
   wait for 20 ns;

   -- Test 4: Subtraction 4 - 6 "11110"
   A<= "0100";
   B <= "0110";
   ACARREO_IN<= '1';  -- Subtraction
   wait for 20 ns;

   -- End of test
   wait;
end process;