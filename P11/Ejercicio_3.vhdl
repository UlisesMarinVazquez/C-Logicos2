library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Arithmetic_Display is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR (2 downto 0);
        B : in STD_LOGIC_VECTOR (2 downto 0);
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        seg0 : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display for least significant digit
        seg1 : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display for most significant digit
        carry : out STD_LOGIC -- Carry/borrow flag for addition and subtraction
    );
end Arithmetic_Display;

architecture Behavioral of Arithmetic_Display is

    signal sum_result : STD_LOGIC_VECTOR (3 downto 0);
    signal sub_result : STD_LOGIC_VECTOR (3 downto 0);
    signal mul_result : STD_LOGIC_VECTOR (6 downto 0);
    signal bin_result : STD_LOGIC_VECTOR (6 downto 0);
    signal result : STD_LOGIC_VECTOR (6 downto 0);
    signal bcd0, bcd1 : STD_LOGIC_VECTOR (3 downto 0);

begin

    process(A, B, sel)
    begin
        sum_result <= ("000" & A) + ("000" & B);
        sub_result <= ("000" & A) - ("000" & B);
        mul_result <= ("000" & A) * ("000" & B);
        bin_result <= ("000" & A) & ("000" & B);

        case sel is
            when "01" =>
                result <= "000" & sum_result;
                carry <= sum_result(3); -- Carry out for addition
            when "10" =>
                result <= "000" & sub_result;
                carry <= sub_result(3); -- Borrow out for subtraction
            when "11" =>
                result <= mul_result;
                carry <= '0'; -- No carry out for multiplication
            when others =>
                result <= bin_result; -- Show binary state of A and B
                carry <= '0';
        end case;
    end process;

    -- Separate the result into two BCD digits
    bcd0 <= result(3 downto 0);
    bcd1 <= result(6 downto 4);

    process(bcd0)
    begin
        case bcd0 is
            when "0000" => seg0 <= "0000001"; -- 0
            when "0001" => seg0 <= "1001111"; -- 1
            when "0010" => seg0 <= "0010010"; -- 2
            when "0011" => seg0 <= "0000110"; -- 3
            when "0100" => seg0 <= "1001100"; -- 4
            when "0101" => seg0 <= "0100100"; -- 5
            when "0110" => seg0 <= "0100000"; -- 6
            when "0111" => seg0 <= "0001111"; -- 7
            when "1000" => seg0 <= "0000000"; -- 8
            when "1001" => seg0 <= "0000100"; -- 9
            when others => seg0 <= "1111111"; -- Default case
        end case;
    end process;

    process(bcd1)
    begin
        case bcd1 is
            when "0000" => seg1 <= "0000001"; -- 0
            when "0001" => seg1 <= "1001111"; -- 1
            when "0010" => seg1 <= "0010010"; -- 2
            when "0011" => seg1 <= "0000110"; -- 3
            when "0100" => seg1 <= "1001100"; -- 4
            when "0101" => seg1 <= "0100100"; -- 5
            when "0110" => seg1 <= "0100000"; -- 6
            when "0111" => seg1 <= "0001111"; -- 7
            when "1000" => seg1 <= "0000000"; -- 8
            when "1001" => seg1 <= "0000100"; -- 9
            when others => seg1 <= "1111111"; -- Default case
        end case;
    end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity arithmetic_operations_display is
    Port (
        SE : in  std_logic_vector(1 downto 0);
        A, B : in  std_logic_vector(3 downto 0);
        resultado : out std_logic_vector(3 downto 0);
        display_segments : out std_logic_vector(6 downto 0)
    );
end arithmetic_operations_display;


architecture Behavioral of arithmetic_operations_display is
    signal temp_result : std_logic_vector(3 downto 0);
    signal temp_display : std_logic_vector(6 downto 0);

    -- Función para convertir resultado a formato de 7 segmentos

    function convert_to_7seg(input : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case input is
            when "0000" => return "0000001"; -- 0
            when "0001" => return "1001111"; -- 1
            when "0010" => return "0010010"; -- 2
            when "0011" => return "0000110"; -- 3
            when "0100" => return "1001100"; -- 4
            when "0101" => return "0100100"; -- 5
            when "0110" => return "0100000"; -- 6
            when "0111" => return "0001111"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0000100"; -- 9
            when others => return "1111111"; -- Para cualquier otro caso
        end case;
    end convert_to_7seg;

begin
    process(SE, A, B)
    begin
        case SE is
            when "01" => -- SUMA
                temp_result <= ('0' & A) + ('0' & B);
                temp_display <= convert_to_7seg(temp_result);

            when "10" => -- RESTA
                temp_result <= ('0' & A) - ('0' & B);
                temp_display <= convert_to_7seg(temp_result);

            when "11" => -- MULTIPLICACIÓN
                temp_result <= ('0' & A) * ('0' & B);
                temp_display <= convert_to_7seg(temp_result);

            when others => -- Mostrar estado de las entradas en binario

                temp_result <= (others => '0');
                temp_display <= convert_to_7seg(A) & convert_to_7seg(B);
        end case;
    end process;

    resultado <= temp_result;
    display_segments <= temp_display;

end Behavioral;




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity calc is
    port(
        a,b: in std_logic_vector (7 downto 0);
        operacion: in std_logic_vector (3 downto 0);
        carry: out std_logic;
        salida: out std_logic_vector (7 downto 0)
    );
end entity calc;

architecture behaviour of calc is
    signal temporal: std_logic_vector (8 downto 0);
    signal resultado: std_logic_vector (7 downto 0);
begin
    process (a,b, resultado)
    begin
        case (operacion) is
            when '0000' =>  -- Suma +
                resultado <= a+b;
            when '0001' =>  --resta 
                resultado <= a-b;
            when '0010' =>  --multiplicación 
                resultado <= std_logic_vector(to_unsigned (to_integer (unsigned(a))*to_integer (unsigned(b))));
            when '0011' => --divison /
                resultado <= std_logic_vector(to_unsigned (to_integer (unsigned(a))/to_integer (unsigned(b))));
            when others
                resultado <= '00000000';
        end case;
    end process;

    salida <= resultado;
    temporal <= ('0'&a) +('0'&b);
    carry<= temporal (8);
end architecture behaviour;