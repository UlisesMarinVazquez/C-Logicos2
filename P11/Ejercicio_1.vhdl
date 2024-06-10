library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_display is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           count_direction : in STD_LOGIC; -- 0: ascendente, 1: descendente
           display : out STD_LOGIC_VECTOR(6 downto 0);
           segment_enable : out STD_LOGIC_VECTOR(3 downto 0));
end contador_display;

architecture Behavioral of contador_display is
    signal contador : STD_LOGIC_VECTOR(15 downto 0); -- Contador de 16 bits (0 a 9999)
    signal display_data : STD_LOGIC_VECTOR(6 downto 0); -- Datos de los display
    signal contador_actual : STD_LOGIC_VECTOR(3 downto 0); -- Contador para cada display
begin
    -- Proceso del contador
    process(clk, reset)
    begin
        if reset = '1' then
            contador <= (others => '0');
        elsif rising_edge(clk) then
            if count_direction = '0' then -- Ascendente
                contador <= contador + 1;
            else -- Descendente
                contador <= contador - 1;
            end if;
        end if;
    end process;

    -- Proceso para dividir el contador en dígitos
    process(contador)
    begin
        contador_actual <= contador(15 downto 12); -- Dígito más significativo
        case contador(15 downto 12) is
            when "0000" =>
                display_data <= "0000001"; -- 0
            when "0001" =>
                display_data <= "1001111"; -- 1
            when "0010" =>
                display_data <= "0010010"; -- 2
            when "0011" =>
                display_data <= "0000110"; -- 3
            when "0100" =>
                display_data <= "1001100"; -- 4
            when "0101" =>
                display_data <= "0100100"; -- 5
            when "0110" =>
                display_data <= "0100000"; -- 6
            when "0111" =>
                display_data <= "0001111"; -- 7
            when "1000" =>
                display_data <= "0000000"; -- 8
            when "1001" =>
                display_data <= "0000100"; -- 9
            when others =>
                display_data <= "1111111"; -- No se espera que ocurra
        end case;
    end process;

    -- Proceso para habilitar los displays
    process(contador_actual)
    begin
        case contador_actual is
            when "0000" =>
                segment_enable <= "1110"; -- Habilita el primer display
            when "0001" =>
                segment_enable <= "1101"; -- Habilita el segundo display
            when "0010" =>
                segment_enable <= "1011"; -- Habilita el tercer display
            when "0011" =>
                segment_enable <= "0111"; -- Habilita el cuarto display
            when others =>
                segment_enable <= "1111"; -- Ningún display habilitado
        end case;
    end process;

    -- Asignación del dato del display
    display <= display_data;

end Behavioral;
