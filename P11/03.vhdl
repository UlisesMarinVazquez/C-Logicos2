library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity arithmetic_operations_display is
    Port (
        SE : in  std_logic_vector(1 downto 0);
        A, B : in  std_logic_vector(3 downto 0);
        AN : out std_logic_vector(3 downto 0);
        display_segments : out std_logic_vector(6 downto 0)
    );
end arithmetic_operations_display;


architecture Behavioral of arithmetic_operations_display is
    signal temp_result : std_logic_vector(3 downto 0);
    signal temp_display : std_logic_vector(6 downto 0);

    -- Función para convertir AN a formato de 7 segmentos

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

    AN <= temp_result;
    display_segments <= temp_display;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity arithmetic_operations_display is
    Port (
        clk : in std_logic;
        SE : in std_logic_vector(1 downto 0);
        A, B : in std_logic_vector(3 downto 0);
        AN : out std_logic_vector(3 downto 0);
        display_segments : out std_logic_vector(6 downto 0)
    );
end arithmetic_operations_display;

architecture Behavioral of arithmetic_operations_display is
    signal temp_result : std_logic_vector(7 downto 0);
    signal display_data : std_logic_vector(27 downto 0); -- 4 * 7 segments
    signal digit_select : integer range 0 to 3 := 0;
    signal refresh_counter : integer range 0 to 1000000 := 0;

    -- Function to convert a 4-bit input to 7-segment display code
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
            when others => return "1111111"; -- For any other case
        end case;
    end convert_to_7seg;

begin
    process(SE, A, B)
    begin
        case SE is
            when "01" => -- SUM
                temp_result <= ('0' & A) + ('0' & B);
            when "10" => -- SUBTRACT
                temp_result <= ('0' & A) - ('0' & B);
            when "11" => -- MULTIPLY
                temp_result <= ('0' & A) * ('0' & B);
            when others => -- Show inputs in binary
                temp_result <= A & B;
        end case;
        
        -- Convert the result to 7-segment display codes for 4 digits
        display_data(6 downto 0)   <= convert_to_7seg(temp_result(3 downto 0));   -- First digit
        display_data(13 downto 7)  <= convert_to_7seg(temp_result(7 downto 4));   -- Second digit
        display_data(20 downto 14) <= convert_to_7seg("0000");                    -- Third digit (unused)
        display_data(27 downto 21) <= convert_to_7seg("0000");                    -- Fourth digit (unused)
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
            if refresh_counter = 100000 then -- Adjust the counter value for your clock speed
                refresh_counter <= 0;
                digit_select <= digit_select + 1;
                if digit_select = 4 then
                    digit_select <= 0;
                end if;
            end if;
        end if;
    end process;

    process(digit_select)
    begin
        case digit_select is
            when 0 =>
                AN <= "1110";
                display_segments <= display_data(6 downto 0);
            when 1 =>
                AN <= "1101";
                display_segments <= display_data(13 downto 7);
            when 2 =>
                AN <= "1011";
                display_segments <= display_data(20 downto 14);
            when 3 =>
                AN <= "0111";
                display_segments <= display_data(27 downto 21);
            when others =>
                AN <= "1111";
        end case;
    end process;
end Behavioral;


NET "clk" LOC = "B8";


NET "A(2)" LOC = "E2"; 
NET "A(1)" LOC = "F3"; 
NET "A(0)" LOC = "G3"; 

NET "B(2)" LOC = "K3"; 
NET "B(1)" LOC = "L3"; 
NET "B(0)" LOC = "P11"; 

NET "selector(1)" LOC = "A7";
NET "selector(0)" LOC = "M4";

NET "seg(6)" LOC = "L14"; 
NET "seg(5)" LOC = "H12"; 
NET "seg(4)" LOC = "N14"; 
NET "seg(3)" LOC = "N11"; 
NET "seg(2)" LOC = "P12"; 
NET "seg(1)" LOC = "L13"; 
NET "seg(0)" LOC = "M12";


NET "an(3)" LOC = "F12";
NET "an(2)" LOC = "J12";
NET "an(1)" LOC = "M13";
NET "an(0)" LOC = "K14";


-- Stimulus process
stim_proc: process
begin		
   -- hold reset state for 100 ns.
   wait for 100 ns;	

   -- insert stimulus here 

   -- Test 1: Addition 3 + 2 = 5 "0101"
   A<= "0011";
   B <= "0010";
   selector<= "01";  -- Addition
   wait for 20 ns;
   
   -- Test 2: Subtraction 5 - 3 = 2 "0010"
   A<= "0101";
   B <= "0011";
   selector<= "10";  -- Subtraction
   wait for 20 ns;

   -- Test 3: Addition 8 + 8 = 16 "10000"
   A<= "0100";
   B <= "0100";
   selector<= "11";  -- Addition
   wait for 20 ns;

   -- Test 4: Subtraction 4 - 6 "11110"
   A<= "0100";
   B <= "0110";
   selector<= "00";  -- Subtraction
   wait for 20 ns;

   -- End of test
   wait;
end process;