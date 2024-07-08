
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ContadorFinal is
    port (
        reloj: in std_logic;
        Enable: out std_logic_vector(3 downto 0);
        swl: in std_logic;
        salida: out std_logic_vector(7 downto 0)
        );
end ContadorFinal;

architecture Behavioral of ContadorFinal is
    --declaracion de señales

    signal segundo: integer range 0 to 99999999;
    signal unidad: integer range 0 to 9;
    signal decenas: integer range 0 to 9 ;
    signal centenas: integer range 0 to 9;
    signal millares: integer range 0 to 9;
    signal bandera: std_logic_vector(2 downto 0);
    signal numero: integer range 0 to 9;
    signal msegundo: integer range 0 to 999999;


    begin
    process (unidad, decenas, centenas, millares, reloj)
    begin
        if rising_edge(reloj) then
            if (swl = '0') then
                unidad <= 0;
                decenas <= 0;
                centenas <= 0;
                end if;
    
            if (segundo = 99999999) then
                    segundo <= 0;
                    if (unidad = 9) then
                        unidad <= 0;
                    else
                        unidad <= unidad + 1;
                    end if;
                    
                    if (unidad = 9) then
                        decenas <= decenas + 1;
                    end if;

                    if (decenas = 9) then
                        unidad <= unidad + 1;
                    end if;

                    if (decenas = 9 and unidad =9) then 
                    decenas <= 0;
                    unidad <= 0;
                    centenas <= centenas + 1;
                    end if;

                    if (centenas = 9 and decenas = 9) then 
                    centenas <= 0;
                    decenas <= 0;
                    unidad <= 0;
                    millares <= millares + 1;
                    end if;

                    if (millares = 9 and decenas = 9 and unidad = 9 and centenas = 9) then
                        decenas <= 0;
                        unidad <= 0;
                        centenas <= 0;
                        millares <= 0;
                    end if ;
                    else
                        segundo <= (segundo) + 1;
                        end if;
            end if;

            end process;
            
            

    process (reloj, unidad, decenas, centenas, millares)
    begin
        if rising_edge(reloj) then
            if msegundo = 69999 then
                msegundo <= 0;
                bandera <= not (bandera);

                if (bandera = "0000") then
                    numero <= unidad;
                    Enable <= "1110";
                    bandera <= "0001";
                    end if;

                    if (bandera = "0001") then
                        numero <= decenas;
                        Enable <= "1101";
                        bandera <= "1101";
                        end if;
                        
                    if (bandera = "1101") then
                        numero <= decenas;
                        Enable <= "1011";
                        bandera <= "1000";
                        end if;

                    if (bandera = "1000") then
                        numero <= decenas;
                        Enable <= "0111";
                        bandera <= "1000";
                        end if;

                        else
                            msegundo <= msegundo + 1;
                    end if;

        case numero is
            when 0 => salida <= "11000000";
            when 1 => salida <= "11111001";
            when 2 => salida <= "10100100";
            when 3 => salida <= "10110000";
            when 4 => salida <= "10011001";
            when 5 => salida <= "10010010";
            when 6 => salida <= "10000010";
            when 7 => salida <= "11111000";
            when 8 => salida <= "10000000";
            when 9 => salida <= "10011000";
            when others => salida <= "11111111";
        end case;
        end if;
    end process;
end Behavioral;

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity ContadorFinal is

    port (

        reloj: in std_logic;

        Enable: out std_logic_vector(3 downto 0);

        swl: in std_logic;

        salida: out std_logic_vector(7 downto 0)

    );

end ContadorFinal;



architecture Behavioral of ContadorFinal is

    -- Signals declaration

    signal segundo: integer range 0 to 9999 := 0;

    signal unidad: integer range 0 to 9 := 0;

    signal decenas: integer range 0 to 9 := 0;

    signal centenas: integer range 0 to 9 := 0;

    signal millares: integer range 0 to 9 := 0;

    signal bandera: std_logic_vector(2 downto 0) := "000";

    signal msegundo: integer range 0 to 69999 := 0;



begin



    -- Process for counting up to 9999

    process (reloj)

    begin

        if rising_edge(reloj) then

            if swl = '0' then  -- Reset condition

                segundo <= 0;

                unidad <= 0;

                decenas <= 0;

                centenas <= 0;

                millares <= 0;

            else

                -- Increment seconds counter

                if segundo = 9999 then

                    segundo <= 0;

                    if unidad = 9 then

                        unidad <= 0;

                        if decenas = 9 then

                            decenas <= 0;

                            if centenas = 9 then

                                centenas <= 0;

                                if millares = 9 then

                                    millares <= 0;

                                else

                                    millares <= millares + 1;

                                end if;

                            else

                                centenas <= centenas + 1;

                            end if;

                        else

                            decenas <= decenas + 1;

                        end if;

                    else

                        unidad <= unidad + 1;

                    end if;

                else

                    segundo <= segundo + 1;

                end if;

            end if;

        end if;

    end process;



    -- Process for displaying current digit on salida

    process (reloj)

        variable numero: integer range 0 to 9;

    begin

        if rising_edge(reloj) then

            if msegundo = 69999 then

                msegundo <= 0;

                

                -- Increment bandera

                if bandera = "011" then

                    bandera <= "000";  -- Reset to "000" after "011"

                else

                    bandera <= std_logic_vector(unsigned(bandera) + 1);

                end if;

                

                case bandera is

                    when "000" =>

                        numero := unidad;

                        Enable <= "1110";

                    when "001" =>

                        numero := decenas;

                        Enable <= "1101";

                    when "010" =>

                        numero := centenas;

                        Enable <= "1011";

                    when "011" =>

                        numero := millares;

                        Enable <= "0111";

                    when others =>

                        numero := 0;  -- Default case, should not occur in valid operation

                        Enable <= "1111";

                end case;

            else

                msegundo <= msegundo + 1;

            end if;

        end if;



        -- Output the corresponding seven-segment code

        case numero is

            when 0 => salida <= "11000000";

            when 1 => salida <= "11111001";

            when 2 => salida <= "10100100";

            when 3 => salida <= "10110000";

            when 4 => salida <= "10011001";

            when 5 => salida <= "10010010";

            when 6 => salida <= "10000010";

            when 7 => salida <= "11111000";

            when 8 => salida <= "10000000";

            when 9 => salida <= "10011000";

            when others => salida <= "11111111";  -- Invalid state, should not occur

        end case;

    end process;



end Behavioral;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ContadorFinal is
    port (
        reloj: in std_logic;
        Enable: out std_logic_vector(3 downto 0);
        swl: in std_logic;
        salida: out std_logic_vector(7 downto 0)
    );
end ContadorFinal;

architecture Behavioral of ContadorFinal is
    -- Signals declaration
    signal segundo: integer range 0 to 9999 := 0;
    signal unidad: integer range 0 to 9 := 0;
    signal decenas: integer range 0 to 9 := 0;
    signal centenas: integer range 0 to 9 := 0;
    signal millares: integer range 0 to 9 := 0;
    signal bandera: std_logic_vector(2 downto 0) := "000";
    signal msegundo: integer range 0 to 69999 := 0;

begin

    -- Process for counting up to 9999
    process (reloj)
    begin
        if rising_edge(reloj) then
            if swl = '0' then  -- Reset condition
                segundo <= 0;
                unidad <= 0;
                decenas <= 0;
                centenas <= 0;
                millares <= 0;
            else
                -- Increment seconds counter
                if segundo = 9999 then
                    segundo <= 0;
                    if unidad = 9 then
                        unidad <= 0;
                        if decenas = 9 then
                            decenas <= 0;
                            if centenas = 9 then
                                centenas <= 0;
                                if millares = 9 then
                                    millares <= 0;
                                else
                                    millares <= millares + 1;
                                end if;
                            else
                                centenas <= centenas + 1;
                            end if;
                        else
                            decenas <= decenas + 1;
                        end if;
                    else
                        unidad <= unidad + 1;
                    end if;
                else
                    segundo <= segundo + 1;
                end if;
            end if;
        end if;
    end process;

    -- Process for displaying current digit on salida
    process (reloj)
        variable numero: integer range 0 to 9;
    begin
        if rising_edge(reloj) then
            if msegundo = 69999 then
                msegundo <= 0;
                
                -- Increment bandera
                if bandera = "011" then
                    bandera <= "000";  -- Reset to "000" after "011"
                else
                    bandera <= std_logic_vector(unsigned(bandera) + 1);
                end if;
                
                case bandera is
                    when "000" =>
                        numero := unidad;
                        Enable <= "1110";
                    when "001" =>
                        numero := decenas;
                        Enable <= "1101";
                    when "010" =>
                        numero := centenas;
                        Enable <= "1011";
                    when "011" =>
                        numero := millares;
                        Enable <= "0111";
                    when others =>
                        numero := 0;  -- Default case, should not occur in valid operation
                        Enable <= "1111";
                end case;
            else
                msegundo <= msegundo + 1;
            end if;
        end if;

        -- Output the corresponding seven-segment code
        case numero is
            when 0 => salida <= "11000000";
            when 1 => salida <= "11111001";
            when 2 => salida <= "10100100";
            when 3 => salida <= "10110000";
            when 4 => salida <= "10011001";
            when 5 => salida <= "10010010";
            when 6 => salida <= "10000010";
            when 7 => salida <= "11111000";
            when 8 => salida <= "10000000";
            when 9 => salida <= "10011000";
            when others => salida <= "11111111";  -- Invalid state, should not occur
        end case;
    end process;

end Behavioral;


NET "reloj" loc = "B8";

NET "swl" LOC = "N3";


NET "salida(0)" LOC = "L14"; 
NET "salida(1)" LOC = "H12"; 
NET "salida(2)" LOC = "N14"; 
NET "salida(3)" LOC = "N11"; 
NET "salida(4)" LOC = "P12"; 
NET "salida(5)" LOC = "L13"; 
NET "salida(6)" LOC = "M12";
NET "salida(7)" LOC = "N13";



NET "Enable(3)" LOC = "F12";
NET "Enable(2)" LOC = "J12";
NET "Enable(1)" LOC = "M13";
NET "Enable(0)" LOC = "K14";

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SIMUIL is
end SIMUIL;

architecture behavior of SIMUIL is
    -- Component declaration
    component ContadorFinal
        port (
            reloj: in std_logic;
            Enable: out std_logic_vector(3 downto 0);
            swl: in std_logic;
            salida: out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals for testbench
    signal reloj_tb: std_logic := '0';
    signal swl_tb: std_logic := '0';
    signal Enable_tb: std_logic_vector(3 downto 0);
    signal salida_tb: std_logic_vector(7 downto 0);

    -- Clock process
    constant periodo_reloj: time := 10 ns;  -- Periodo del reloj en ns

    begin
    reloj_process: process
    begin
        while now < 500 ns loop  -- Simular por un tiempo suficiente
            reloj_tb <= '0';
            wait for periodo_reloj / 2;
            reloj_tb <= '1';
            wait for periodo_reloj / 2;
        end loop;
        wait;
    end process reloj_process;

    -- Stimulus process
    stimulus_process: process
    begin
        wait for 20 ns;  -- Espera inicial antes de activar swl
        swl_tb <= '1';  -- Activa swl para iniciar el contador
        
        wait for 200 ns;  -- Espera para simular el comportamiento
        
        -- Puedes añadir más cambios en swl_tb aquí si deseas simular más eventos
        
        wait;
    end process stimulus_process;

    -- Instantiate the DUT (Device Under Test)
    uut: ContadorFinal port map (
        reloj => reloj_tb,
        Enable => Enable_tb,
        swl => swl_tb,
        salida => salida_tb
    );

end behavior;

NET "CLR" loc = "B8";
NET "CLK1" loc = "B8";
NET "CLK2" loc = "B8";

NET "X" LOC = "N3";


NET "Q(6)" LOC = "L14"; 
NET "Q(5)" LOC = "H12"; 
NET "Q(4)" LOC = "N14"; 
NET "Q(3)" LOC = "N11"; 
NET "Q(2)" LOC = "P12"; 
NET "Q(1)" LOC = "L13"; 
NET "Q(0)" LOC = "M12";


NET "Y(3)" LOC = "F12";
NET "Y(2)" LOC = "J12";
NET "Y(1)" LOC = "M13";
NET "Y(0)" LOC = "K14";