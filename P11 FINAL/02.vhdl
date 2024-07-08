library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BOLETA is
    Port ( AIKO: in  STD_LOGIC;
           ULISES : in  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR (0 to 3);
           DISPLAY : out  STD_LOGIC_VECTOR (0 to 6));
end BOLETA;

architecture Behavioral of BOLETA is


signal CLK : integer range 0 to 100_000; 
signal TEMP : STD_LOGIC_VECTOR (0 to 1):= "00"; 
signal ANODO : STD_LOGIC_VECTOR (0 to 3):= "1111";
signal AN_1, AN_2, AN_3, AN_4 : STD_LOGIC_VECTOR (0 to 6);

begin


process(AIKO,CLK)
begin 
	if (AIKO'event and AIKO= '1') then
		if (CLK < 100_000) then 
			CLK <= CLK + 1;
		else 
			TEMP <= TEMP + 1; 
			CLK <= 0;				
		end if;
	end if;
end process;

process(TEMP, ULISES)
begin
	case TEMP is
		when "00"    => ANODO <= "0111";
		when "01"    => ANODO <= "1011";
		when "10"    => ANODO <= "1101";
		when others  => ANODO <= "1110";
	end case;
	
	if (ULISES = '0')then --BOLETA ULISES
		AN_1 <= "0000001";
		AN_2 <= "0001111";
		AN_3 <= "0000100";
		AN_4 <= "1001100";
		
	else --BOLETA AIKO
		AN_1 <= "1001111";
		AN_2 <= "0000001";
		AN_3 <= "0000110";
		AN_4 <= "0000001";
	end if;
		
	case ANODO is 
		when "0111" => DISPLAY <= AN_1;
		when "1011" => DISPLAY <= AN_2;
		when "1101" => DISPLAY <= AN_3;
		when others => DISPLAY <= AN_4;
	end case;
end process;

AN <= ANODO;


end Behavioral;



NET "CLK" LOC = "B8";

NET "AIKO" LOC = "N3";
NET "ULISES" LOC = "E2";

NET "DISPLAY(6)" LOC = "L14"; 
NET "DISPLAY(5)" LOC = "H12"; 
NET "DISPLAY(4)" LOC = "N14"; 
NET "DISPLAY(3)" LOC = "N11"; 
NET "DISPLAY(2)" LOC = "P12"; 
NET "DISPLAY(1)" LOC = "L13"; 
NET "DISPLAY(0)" LOC = "M12";



NET "AN(3)" LOC = "F12";
NET "AN(2)" LOC = "J12";
NET "AN(1)" LOC = "M13";
NET "AN(0)" LOC = "K14";



--------------------------------------------------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

 

ENTITY simul IS

END simul;

 

ARCHITECTURE behavior OF simul IS 

 

    -- Component Declaration for the Unit Under Test (UUT)

 

    COMPONENT BOLETA

    PORT(

         AIKO: IN  std_logic;

         ULISES : IN  std_logic;

         AN : OUT  std_logic_vector(0 to 3);

         DISPLAY : OUT  std_logic_vector(0 to 6)

        );

    END COMPONENT;

    



   --Inputs

   signal AIKO: std_logic := '0';

   signal ULISES : std_logic := '0';



 	--Outputs

   signal AN : std_logic_vector(0 to 3);

   signal DISPLAY : std_logic_vector(0 to 6);

   

   constant AIKO_period : time := 10 ns;

 

BEGIN

 

	-- Instantiate the Unit Under Test (UUT)

   uut: BOLETA PORT MAP (

          AIKO=> AIKO,

          ULISES => ULISES,

          AN => AN,

          DISPLAY => DISPLAY

        );



   -- Clock process definitions

   AIKO_process : process

   begin

		AIKO<= '0';

		wait for AIKO_period/2;

		AIKO<= '1';

		wait for AIKO_period/2;

   end process;

 



   -- Stimulus process

   stim_proc: process

   begin		

      -- hold reset state for 100 ns.

      wait for 100 ns;	



      -- insert stimulus here 

      -- Test case 1: ULISES = 0 (BOLETA ULISES)

      ULISES <= '0';

      wait for 500 ns;



      -- Test case 2: ULISES = 1 (BOLETA AIKO)

      ULISES <= '1';

      wait for 500 ns;



      -- End simulation

      wait;

   end process;



END behavior;
