library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Bin_Converter is
    Port (
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        bin_in : in STD_LOGIC_VECTOR (3 downto 0);
        gray_out : out STD_LOGIC_VECTOR (3 downto 0);
        excess3_out : out STD_LOGIC_VECTOR (7 downto 0);
        bcd_out : out STD_LOGIC_VECTOR (6 downto 0);
        octal_out : out STD_LOGIC_VECTOR (6 downto 0)
    );
end Bin_Converter;

architecture Behavioral of Bin_Converter is
begin
    process(sel, bin_in)
    begin
        -- Default outputs
        gray_out <= "0000";
        excess3_out <= "00000000";
        bcd_out <= "1111111";
        octal_out <= "1111111";

        case sel is
            when "00" => 
                -- Convert to Gray Code
                gray_out(3) <= bin_in(3);
                gray_out(2) <= bin_in(3) xor bin_in(2);
                gray_out(1) <= bin_in(2) xor bin_in(1);
                gray_out(0) <= bin_in(1) xor bin_in(0);
            when "01" =>
                -- Convert to Excess-3 Code
                excess3_out <= "0000" & (bin_in + "0011");
            when "10" =>
                -- Convert to BCD (7-segment display code for anode common)
                case bin_in is
                    when "0000" => bcd_out <= "0000001"; -- 0
                    when "0001" => bcd_out <= "1001111"; -- 1
                    when "0010" => bcd_out <= "0010010"; -- 2
                    when "0011" => bcd_out <= "0000110"; -- 3
                    when "0100" => bcd_out <= "1001100"; -- 4
                    when "0101" => bcd_out <= "0100100"; -- 5
                    when "0110" => bcd_out <= "0100000"; -- 6
                    when "0111" => bcd_out <= "0001111"; -- 7
                    when "1000" => bcd_out <= "0000000"; -- 8
                    when "1001" => bcd_out <= "0000100"; -- 9
                    when others => bcd_out <= "1111111"; -- Default case
                end case;
            when "11" =>
                -- Convert to Octal (7-segment display code for anode common)
                case bin_in is
                    when "0000" => octal_out <= "0000001"; -- 0
                    when "0001" => octal_out <= "1001111"; -- 1
                    when "0010" => octal_out <= "0010010"; -- 2
                    when "0011" => octal_out <= "0000110"; -- 3
                    when "0100" => octal_out <= "1001100"; -- 4
                    when "0101" => octal_out <= "0100100"; -- 5
                    when "0110" => octal_out <= "0100000"; -- 6
                    when "0111" => octal_out <= "0001111"; -- 7
                    when others => octal_out <= "1111111"; -- Default case
                end case;
            when others =>
                -- Do nothing, default values are already set
                null;
        end case;
    end process;
end Behavioral;


NET "sel(1)" LOC = "N3"; 
NET "sel(0)" LOC = "E2"; 
NET "bin_in(3)" LOC = "F3";
NET "bin_in(2)" LOC = "G3";
NET "bin_in(1)" LOC = "B4";
NET "bin_in(0)" LOC = "K3";

NET "gray_out(3)" LOC = "G1"; 
NET "gray_out(2)" LOC = "P4"; 
NET "gray_out(1)" LOC = "N4"; 
NET "gray_out(0)" LOC = "N5"; 

NET "excess3_out(7)" LOC = "G1"; 
NET "excess3_out(6)" LOC = "P4"; 
NET "excess3_out(5)" LOC = "N4"; 
NET "excess3_out(4)" LOC = "N5"; 
NET "excess3_out(3)" LOC = "P6"; 
NET "excess3_out(2)" LOC = "P7"; 
NET "excess3_out(1)" LOC = "M11";
NET "excess3_out(0)" LOC = "M5";

NET "bcd_out(0)" LOC = "L14"; 
NET "bcd_out(1)" LOC = "H12"; 
NET "bcd_out(2)" LOC = "N14"; 
NET "bcd_out(3)" LOC = "N11"; 
NET "bcd_out(4)" LOC = "P12"; 
NET "bcd_out(5)" LOC = "L13"; 
NET "bcd_out(6)" LOC = "M12";

NET "octal_out(0)" LOC = "L14"; 
NET "octal_out(1)" LOC = "H12"; 
NET "octal_out(2)" LOC = "N14"; 
NET "octal_out(3)" LOC = "N11"; 
NET "octal_out(4)" LOC = "P12"; 
NET "octal_out(5)" LOC = "L13"; 
NET "octal_out(6)" LOC = "M12";

NET "display_enable(3)" LOC = "F12";
NET "display_enable(2)" LOC = "J12";
NET "display_enable(1)" LOC = "M13";
NET "display_enable(0)" LOC = "K14";



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Bin_Converter is
    Port (
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        bin_in : in STD_LOGIC_VECTOR (3 downto 0);
        gray_out : out STD_LOGIC_VECTOR (3 downto 0);
        excess3_out : out STD_LOGIC_VECTOR (7 downto 0);
        bcd_out : out STD_LOGIC_VECTOR (6 downto 0);
        octal_out : out STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out STD_LOGIC_VECTOR (3 downto 0)  -- Signals to enable displays
    );
end Bin_Converter;

architecture Behavioral of Bin_Converter is
begin
    process(sel, bin_in)
    begin
        -- Default outputs
        gray_out <= "0000";
        excess3_out <= "00000000";
        bcd_out <= "1111111";
        octal_out <= "1111111";
        display_enable <= "1111";  -- Disable all displays by default

        case sel is
            when "00" => 
                -- Convert to Gray Code
                gray_out(3) <= bin_in(3);
                gray_out(2) <= bin_in(3) xor bin_in(2);
                gray_out(1) <= bin_in(2) xor bin_in(1);
                gray_out(0) <= bin_in(1) xor bin_in(0);
                display_enable <= "1110";  -- Enable display 0
            when "01" =>
                -- Convert to Excess-3 Code
                excess3_out <= "0000" & (bin_in + "0011");
                display_enable <= "1101";  -- Enable display 1
            when "10" =>
                -- Convert to BCD (7-segment display code for anode common)
                case bin_in is
                    when "0000" => bcd_out <= "0000001"; -- 0
                    when "0001" => bcd_out <= "1001111"; -- 1
                    when "0010" => bcd_out <= "0010010"; -- 2
                    when "0011" => bcd_out <= "0000110"; -- 3
                    when "0100" => bcd_out <= "1001100"; -- 4
                    when "0101" => bcd_out <= "0100100"; -- 5
                    when "0110" => bcd_out <= "0100000"; -- 6
                    when "0111" => bcd_out <= "0001111"; -- 7
                    when "1000" => bcd_out <= "0000000"; -- 8
                    when "1001" => bcd_out <= "0000100"; -- 9
                    when others => bcd_out <= "1111111"; -- Default case
                end case;
                display_enable <= "1011";  -- Enable display 2
            when "11" =>
                -- Convert to Octal (7-segment display code for anode common)
                case bin_in is
                    when "0000" => octal_out <= "0000001"; -- 0
                    when "0001" => octal_out <= "1001111"; -- 1
                    when "0010" => octal_out <= "0010010"; -- 2
                    when "0011" => octal_out <= "0000110"; -- 3
                    when "0100" => octal_out <= "1001100"; -- 4
                    when "0101" => octal_out <= "0100100"; -- 5
                    when "0110" => octal_out <= "0100000"; -- 6
                    when "0111" => octal_out <= "0001111"; -- 7
                    when others => octal_out <= "1111111"; -- Default case
                end case;
                display_enable <= "0111";  -- Enable display 3
            when others =>
                -- Do nothing, default values are already set
                null;
        end case;
    end process;
end Behavioral;



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY simulacion2 IS
END simulacion2;
 
ARCHITECTURE behavior OF simulacion2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Bin_Converter
    PORT(
         sel : IN  std_logic_vector(1 downto 0);
         bin_in : IN  std_logic_vector(3 downto 0);
         gray_out : OUT  std_logic_vector(3 downto 0);
         excess3_out : OUT  std_logic_vector(7 downto 0);
         bcd_out : OUT  std_logic_vector(6 downto 0);
         octal_out : OUT  std_logic_vector(6 downto 0);
         display_enable : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal sel : std_logic_vector(1 downto 0) := (others => '0');
   signal bin_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal gray_out : std_logic_vector(3 downto 0);
   signal excess3_out : std_logic_vector(7 downto 0);
   signal bcd_out : std_logic_vector(6 downto 0);
   signal octal_out : std_logic_vector(6 downto 0);
   signal display_enable : std_logic_vector(3 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Bin_Converter PORT MAP (
          sel => sel,
          bin_in => bin_in,
          gray_out => gray_out,
          excess3_out => excess3_out,
          bcd_out => bcd_out,
          octal_out => octal_out,
          display_enable => display_enable
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- Test each combination of sel and bin_in
      -- sel = "00" (Gray code)
      sel <= "00";
      bin_in <= "0000"; wait for 20 ns;
      bin_in <= "0011"; wait for 20 ns;
      bin_in <= "0111"; wait for 20 ns;
      bin_in <= "1000"; wait for 20 ns;
      bin_in <= "1111"; wait for 20 ns;
      
      -- sel = "01" (Excess-3 code)
      sel <= "01";
      bin_in <= "0000"; wait for 20 ns;
      bin_in <= "0011"; wait for 20 ns;
      bin_in <= "0111"; wait for 20 ns;
      bin_in <= "1000"; wait for 20 ns;
      bin_in <= "1111"; wait for 20 ns;

      -- sel = "10" (BCD)
      sel <= "10";
      bin_in <= "0000"; wait for 20 ns;
      bin_in <= "0011"; wait for 20 ns;
      bin_in <= "0111"; wait for 20 ns;
      bin_in <= "1000"; wait for 20 ns;
      bin_in <= "1111"; wait for 20 ns;

      -- sel = "11" (Octal)
      sel <= "11";
      bin_in <= "0000"; wait for 20 ns;
      bin_in <= "0011"; wait for 20 ns;
      bin_in <= "0111"; wait for 20 ns;
      bin_in <= "1000"; wait for 20 ns;
      bin_in <= "1111"; wait for 20 ns;

      -- Simulation end
      wait;
   end process;

END;



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simulll2 IS
END simulll2;
 
ARCHITECTURE behavior OF simulll2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
   COMPONENT Bin_Converter

    PORT(

         sel : IN  std_logic_vector(1 downto 0);

         bin_in : IN  std_logic_vector(3 downto 0);

         gray_out : OUT  std_logic_vector(3 downto 0);

         excess3_out : OUT  std_logic_vector(7 downto 0);

         bcd_out : OUT  std_logic_vector(6 downto 0);

         octal_out : OUT  std_logic_vector(6 downto 0);

         display_enable : OUT  std_logic_vector(3 downto 0)

        );

    END COMPONENT;

    



   --Inputs

   signal sel : std_logic_vector(1 downto 0) := (others => '0');

   signal bin_in : std_logic_vector(3 downto 0) := (others => '0');



 	--Outputs

   signal gray_out : std_logic_vector(3 downto 0);

   signal excess3_out : std_logic_vector(7 downto 0);

   signal bcd_out : std_logic_vector(6 downto 0);

   signal octal_out : std_logic_vector(6 downto 0);

   signal display_enable : std_logic_vector(3 downto 0);



BEGIN

 

	-- Instantiate the Unit Under Test (UUT)

   uut: Bin_Converter PORT MAP (

          sel => sel,

          bin_in => bin_in,

          gray_out => gray_out,

          excess3_out => excess3_out,

          bcd_out => bcd_out,

          octal_out => octal_out,

          display_enable => display_enable

        );



   -- Stimulus process

   stim_proc: process

   begin		

      -- hold reset state for 100 ns.

      wait for 100 ns;	



      -- Test each combination of sel and bin_in

      -- sel = "00" (Gray code)

      sel <= "00";

      bin_in <= "0000"; wait for 20 ns;

      bin_in <= "0011"; wait for 20 ns;

      bin_in <= "0111"; wait for 20 ns;

      bin_in <= "1000"; wait for 20 ns;

      bin_in <= "1111"; wait for 20 ns;

      

      -- sel = "01" (Excess-3 code)

      sel <= "01";

      bin_in <= "0000"; wait for 20 ns;

      bin_in <= "0011"; wait for 20 ns;

      bin_in <= "0111"; wait for 20 ns;

      bin_in <= "1000"; wait for 20 ns;

      bin_in <= "1111"; wait for 20 ns;



      -- sel = "10" (BCD)

      sel <= "10";

      bin_in <= "0000"; wait for 20 ns;

      bin_in <= "0011"; wait for 20 ns;

      bin_in <= "0111"; wait for 20 ns;

      bin_in <= "1000"; wait for 20 ns;

      bin_in <= "1111"; wait for 20 ns;



      -- sel = "11" (Octal)

      sel <= "11";

      bin_in <= "0000"; wait for 20 ns;

      bin_in <= "0011"; wait for 20 ns;

      bin_in <= "0111"; wait for 20 ns;

      bin_in <= "1000"; wait for 20 ns;

      bin_in <= "1111"; wait for 20 ns;



      -- Simulation end

      wait;

   end process;



END;
'





library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;



-- Entity declaration

entity BCD_to_7segment is

    Port (

        BCD : in STD_LOGIC_VECTOR (3 downto 0);

        Display1 : out STD_LOGIC_VECTOR (6 downto 0);

        Display2 : out STD_LOGIC_VECTOR (6 downto 0);

        AN : out STD_LOGIC_VECTOR (3 downto 0)  -- Anodos de los 4 displayss

    );

end BCD_to_7segment;



-- Architecture definition

architecture Behavioral of BCD_to_7segment is

    signal unit : std_logic_vector(3 downto 0);

    signal tens : std_logic_vector(3 downto 0);

begin



    -- Binary to BCD conversion

    process(BCD)

    begin

        case BCD is

            when "0000" => tens <= "0000"; unit <= "0000"; -- 0

            when "0001" => tens <= "0000"; unit <= "0001"; -- 1

            when "0010" => tens <= "0000"; unit <= "0010"; -- 2

            when "0011" => tens <= "0000"; unit <= "0011"; -- 3

            when "0100" => tens <= "0000"; unit <= "0100"; -- 4

            when "0101" => tens <= "0000"; unit <= "0101"; -- 5

            when "0110" => tens <= "0000"; unit <= "0110"; -- 6

            when "0111" => tens <= "0000"; unit <= "0111"; -- 7

            when "1000" => tens <= "0000"; unit <= "1000"; -- 8

            when "1001" => tens <= "0000"; unit <= "1001"; -- 9

            when "1010" => tens <= "0001"; unit <= "0000"; -- 10

            when "1011" => tens <= "0001"; unit <= "0001"; -- 11

            when "1100" => tens <= "0001"; unit <= "0010"; -- 12

            when "1101" => tens <= "0001"; unit <= "0011"; -- 13

            when "1110" => tens <= "0001"; unit <= "0100"; -- 14

            when "1111" => tens <= "0001"; unit <= "0101"; -- 15

            when others => tens <= "0000"; unit <= "0000"; -- default

        end case;

    end process;



    -- BCD to 7-segment display conversion for units

    process(unit)

    begin

        case unit is

            when "0000" => Display1 <= "0000001"; -- 0

            when "0001" => Display1 <= "1001111"; -- 1

            when "0010" => Display1 <= "0010010"; -- 2

            when "0011" => Display1 <= "0000110"; -- 3

            when "0100" => Display1 <= "1001100"; -- 4 

            when "0101" => Display1 <= "0100100"; -- 5 

            when "0110" => Display1 <= "0100000"; -- 6

            when "0111" => Display1 <= "0001111"; -- 7

            when "1000" => Display1 <= "0000000"; -- 8

            when "1001" => Display1 <= "0000100"; -- 9

            when others => Display1 <= "1111111"; -- blank

        end case;



    end process;



    -- BCD to 7-segment display conversion for tens

    process(tens)

    begin

        case tens is

            when "0000" => Display2 <= "0000001"; -- 0

            when "0001" => Display2 <= "1001111"; -- 1

            when others => Display2 <= "1111111"; -- blank

         end case;
			end process;



    -- Activación de ánodos

    process(BCD)

    begin
	      case BCD is
            when "0000"  => AN <= "1101";
            when others =>AN <= "1110";
           
         end case;

         -- Activar solo el primer y segundo display (anodo bajo activo)

    end process;



end Behavioral;