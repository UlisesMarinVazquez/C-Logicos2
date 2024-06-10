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
            when "1009" => seg1 <= "0000100"; -- 9
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
            when "1009" => seg2 <= "0000100"; -- 9
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
            when "1009" => seg3 <= "0000100"; -- 9
            when others => seg3 <= "1111111"; -- Default case
        end case;
    end process;

end Behavioral;
