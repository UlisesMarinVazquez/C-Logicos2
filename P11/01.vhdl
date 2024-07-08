

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity contador is

    Port (

        RELOJ : in std_logic;

        DIR : in std_logic;  -- Entrada para dirección del conteo

        AN0, AN1, AN2, AN3 : out std_logic;

        L : out std_logic_vector(6 downto 0)

    );

end contador;



architecture behavioral of contador is

    signal segundo : std_logic;

    signal rapido : std_logic_vector(1 downto 0);

    signal unidades, decenas, centenas, millares : std_logic_vector(3 downto 0) := (others => '0');

    signal digit : std_logic_vector(3 downto 0);

    signal display : std_logic_vector(6 downto 0);

begin

    -- Divisor de frecuencia

    divisor: process (RELOJ)

        variable cuenta: std_logic_vector(27 downto 0) := x"0000000";

    begin

        if rising_edge (RELOJ) then

            if cuenta = x"48009E0" then -- 1 segundo

                cuenta := x"0000000";

            else

                cuenta := cuenta + 1;

            end if;

        end if;

        segundo <= cuenta(24); -- Divide el reloj para obtener 1 Hz

        rapido <= cuenta(19 downto 18); -- Divide el reloj para obtener multiplexado de display

    end process;



    -- Contador ascendente/descendente

    contador: process (segundo)

        variable count : std_logic_vector(15 downto 0) := (others => '0');

    begin

        if rising_edge (segundo) then

            if DIR = '1' then  -- Conteo ascendente

                if count = x"9999" then

                    count := (others => '0');

                else

                    count := count + 1;

                end if;

            else  -- Conteo descendente

                if count = x"0000" then

                    count := x"9999";

                else

                    count := count - 1;

                end if;

            end if;

        end if;



        -- Asignar valores a las señales

        unidades <= count(3 downto 0);

        decenas <= count(7 downto 4);

        centenas <= count(11 downto 8);

        millares <= count(15 downto 12);

    end process;





    -- Selección del dígito a mostrar

    select_digit: process (rapido)

    begin

        case rapido is

            when "00" =>

                digit <= unidades;

                AN0 <= '0'; AN1 <= '1'; AN2 <= '1'; AN3 <= '1';

            when "01" =>

                digit <= decenas;

                AN0 <= '1'; AN1 <= '0'; AN2 <= '1'; AN3 <= '1';

            when "10" =>

                digit <= centenas;

                AN0 <= '1'; AN1 <= '1'; AN2 <= '0'; AN3 <= '1';

            when others =>

                digit <= millares;

                AN0 <= '1'; AN1 <= '1'; AN2 <= '1'; AN3 <= '0';

        end case;

    end process;





    -- Decodificador de 7 segmentos

    with digit select

        display <= "1000000" when "0000", -- 0

                    "1111001" when "0001", -- 1

                    "0100100" when "0010", -- 2

                    "0110000" when "0011", -- 3

                    "0011001" when "0100", -- 4

                    "0010010" when "0101", -- 5

                    "0000010" when "0110", -- 6

                    "1111000" when "0111", -- 7

                    "0000000" when "1000", -- 8

                    "0010000" when "1001", -- 9

                    "1000000" when others; -- 0



    -- Asignación del valor del display

    L <= display;



end behavioral;


NET "RELOJ" LOC = "B8";

NET "DIR" LOC = "A7";

NET "L(6)" LOC = "L14"; 
NET "L(5)" LOC = "H12"; 
NET "L(4)" LOC = "N14"; 
NET "L(3)" LOC = "N11"; 
NET "L(2)" LOC = "P12"; 
NET "L(1)" LOC = "L13"; 
NET "L(0)" LOC = "M12";



NET "AN3" LOC = "F12";
NET "AN2" LOC = "J12";
NET "AN1" LOC = "M13";
NET "AN0" LOC = "K14";


constant RELOJ_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador PORT MAP (
          RELOJ => RELOJ,
          DIR => DIR,
          AN0 => AN0,
          AN1 => AN1,
          AN2 => AN2,
          AN3 => AN3,
          L => L
        );



   -- Clock process definitions

   RELOJ_process :process

   begin

		RELOJ <= '0';

		wait for RELOJ_period/2;

		RELOJ <= '1';

		wait for RELOJ_period/2;

   end process;

 



   -- Stimulus process

   stim_proc: process

   begin		

      -- hold reset state for 100 ns.

      wait for 100 ns;



      -- Stimulus: Count up

      DIR <= '1';

      wait for 1000 ns; -- simulate for a period to observe counting



      -- Stimulus: Count down

      DIR <= '0';

      wait for 1000 ns; -- simulate for a period to observe counting



      -- End simulation

      wait;

   end process;

