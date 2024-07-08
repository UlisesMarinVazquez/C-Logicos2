library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display_Selector is
    Port (
        sel : in STD_LOGIC; -- Selector de números
        seg0 : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display for the least significant digit
        seg1 : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
        seg2 : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment display
        seg3 : out STD_LOGIC_VECTOR (6 downto 0)  -- 7-segment display for the most significant digit
    );
end Display_Selector;

architecture Behavioral of Display_Selector is
    signal digit0, digit1, digit2, digit3 : STD_LOGIC_VECTOR (3 downto 0); -- BCD digits
begin
    process(sel)
    begin
        if sel = '0' then
            -- Display "1030"
            digit3 <= "0001"; -- 1
            digit2 <= "0000"; -- 0
            digit1 <= "0011"; -- 3
            digit0 <= "0000"; -- 0
        else
            -- Display "3507"
            digit3 <= "0011"; -- 3
            digit2 <= "0101"; -- 5
            digit1 <= "0000"; -- 0
            digit0 <= "0111"; -- 7
        end if;
    end process;

    -- BCD to 7-segment decoding
    process(digit0)
    begin
        case digit0 is
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

    process(digit1)
    begin
        case digit1 is
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

    process(digit2)
    begin
        case digit2 is
            when "0000" => seg2 <= "0000001"; -- 0
            when "0001" => seg2 <= "1001111"; -- 1
            when "0010" => seg2 <= "0010010"; -- 2
            when "0011" => seg2 <= "0000110"; -- 3
            when "0100" => seg2 <= "1001100"; -- 4
            when "0101" => seg2 <= "0100100"; -- 5
            when "0110" => seg2 <= "0100000"; -- 6
            when "0111" => seg2 <= "0001111"; -- 7
            when "1000" => seg2 <= "0000000"; -- 8
            when "1001" => seg2 <= "0000100"; -- 9
            when others => seg2 <= "1111111"; -- Default case
        end case;
    end process;

    process(digit3)
    begin
        case digit3 is
            when "0000" => seg3 <= "0000001"; -- 0
            when "0001" => seg3 <= "1001111"; -- 1
            when "0010" => seg3 <= "0010010"; -- 2
            when "0011" => seg3 <= "0000110"; -- 3
            when "0100" => seg3 <= "1001100"; -- 4
            when "0101" => seg3 <= "0100100"; -- 5
            when "0110" => seg3 <= "0100000"; -- 6
            when "0111" => seg3 <= "0001111"; -- 7
            when "1000" => seg3 <= "0000000"; -- 8
            when "1001" => seg3 <= "0000100"; -- 9
            when others => seg3 <= "1111111"; -- Default case
        end case;
    end process;

end Behavioral;


library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Display_Controller is

    Port (

        CLK         : in  STD_LOGIC;

        RESET       : in  STD_LOGIC;

        SELECTOR    : in  STD_LOGIC;  -- Selector input (0 or 1)

        SEGMENT_OUT : out STD_LOGIC_VECTOR (6 downto 0);  -- 7-segment data output

        ANODE       : out STD_LOGIC_VECTOR (3 downto 0);  -- Anode control for 4 displays

        DIGIT_SEL   : inout STD_LOGIC_VECTOR (3 downto 0)   -- Display selection (0 to 3)

    );

end Display_Controller;



architecture Behavioral of Display_Controller is

    signal digit0, digit1, digit2, digit3, digit5, digit7 : STD_LOGIC_VECTOR(6 downto 0);

begin



    -- Segment data for displaying "1030" and "3507"

    digit0 <= "0000001";  -- 0

    digit1 <= "1001111";  -- 1

    digit2 <= "0000110";  -- 3

    digit3 <= "0000110";  -- 7

    digit5 <= "0100100";  -- 5

    digit7 <= "0001111";  -- 7



    -- Display multiplexing process

    process (CLK, RESET)

    begin

        if RESET = '1' then

            DIGIT_SEL <= "0000";  -- Start with display 0

            ANODE <= "1110";      -- Enable display 0, disable others

            SEGMENT_OUT <= digit0;

        elsif rising_edge(CLK) then

            case DIGIT_SEL is

                when "0000" =>

                    if SELECTOR = '0' then

                        SEGMENT_OUT <= digit0;

                    else

                        SEGMENT_OUT <= digit3;

                    end if;

                    ANODE <= "1110";  -- Enable display 0

                    DIGIT_SEL <= "0001";  -- Move to display 1
						  

                when "0001" =>

                    if SELECTOR = '0' then

                        SEGMENT_OUT <= digit0;

                    else

                        SEGMENT_OUT <= digit3;

                    end if;

                    ANODE <= "1101";  -- Enable display 1

                    DIGIT_SEL <= "0010";  -- Move to display 2
						  

                when "0010" =>

                    if SELECTOR = '0' then

                        SEGMENT_OUT <= digit3;

                    else

                        SEGMENT_OUT <= digit5;

                    end if;

                    ANODE <= "1011";  -- Enable display 2

                    DIGIT_SEL <= "0011";  -- Move to display 3
						  

                when "0011" =>

                    if SELECTOR = '0' then

                        SEGMENT_OUT <= digit0;

                    else

                        SEGMENT_OUT <= digit7;

                    end if;

                    ANODE <= "0111";  -- Enable display 3

                    DIGIT_SEL <= "0000";  -- Wrap around to display 0

                when others =>

                    null;

            end case;

        end if;

    end process;



end Behavioral;


NET "CLK" loc = "B8";

NET "RESET" LOC = "N3";


NET "SEGMENT_OUT(6)" LOC = "L14"; 
NET "SEGMENT_OUT(5)" LOC = "H12"; 
NET "SEGMENT_OUT(4)" LOC = "N14"; 
NET "SEGMENT_OUT(3)" LOC = "N11"; 
NET "SEGMENT_OUT(2)" LOC = "P12"; 
NET "SEGMENT_OUT(1)" LOC = "L13"; 
NET "SEGMENT_OUT(0)" LOC = "M12";


NET "ANODE(3)" LOC = "F12";
NET "ANODE(2)" LOC = "J12";
NET "ANODE(1)" LOC = "M13";
NET "ANODE(0)" LOC = "K14";