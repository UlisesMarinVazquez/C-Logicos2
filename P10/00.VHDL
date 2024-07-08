library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Convertidores is 
    Port(
        CLK : in std_logic; -- Reloj 
        BCD    : in std_logic_vector(3 downto 0);
        SEL    : in std_logic_vector(1 downto 0); -- Selector
        DISPLAY1    : out std_logic_vector(7 downto 0); -- Cdigo Gray y Exc3
        DISPLAY2    : out std_logic_vector(7 downto 0); -- Display
        AN : out std_logic_vector(3 downto 0) -- Selector de display
    );
end Convertidores;

architecture arqdecos of Convertidores is
    signal cuenta     : unsigned(16 downto 0) := (others => '0');
    signal seleccion  : std_logic_vector(1 downto 0) := "00";
    signal mostrar    : std_logic_vector(3 downto 0) := "0000";
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if cuenta < 100000 then 
                cuenta <= cuenta + 1;
            else 
                seleccion <= std_logic_vector(unsigned(seleccion) + 1);
                cuenta <= (others => '0');
            end if;
        end if;
    end process;

    process (SEL, BCD, seleccion)
    begin
        mostrar <= (others => '0'); -- Inicializacin para evitar latches
        if SEL = "00" then
            -- Cdigo Gray 4 bits
            AN <= "1111";
            DISPLAY2 <= "00000000";
            case BCD is
                when "0000" => DISPLAY1 <= "00000000";
                when "0001" => DISPLAY1 <= "00000001";
                when "0010" => DISPLAY1 <= "00000011";
                when "0011" => DISPLAY1 <= "00000010";
                when "0100" => DISPLAY1 <= "00000110";
                when "0101" => DISPLAY1 <= "00000111";
                when "0110" => DISPLAY1 <= "00000101";
                when "0111" => DISPLAY1 <= "00000100";
                when "1000" => DISPLAY1 <= "00001100";
                when "1001" => DISPLAY1 <= "00001101";
                when "1010" => DISPLAY1 <= "00001111";
                when "1011" => DISPLAY1 <= "00001110";
                when "1100" => DISPLAY1 <= "00001010";
                when "1101" => DISPLAY1 <= "00001011";
                when "1110" => DISPLAY1 <= "00001001";
                when others => DISPLAY1 <= "00001000";
            end case;
        elsif SEL = "01" then
            -- Cdigo Exc3 8 bits
            AN <= "1111";
            DISPLAY2 <= "00000000";
            case BCD is
                when "0000" => DISPLAY1 <= "00000011";
                when "0001" => DISPLAY1 <= "00000100";
                when "0010" => DISPLAY1 <= "00000101";
                when "0011" => DISPLAY1 <= "00000110";
                when "0100" => DISPLAY1 <= "00000111";
                when "0101" => DISPLAY1 <= "00001000";
                when "0110" => DISPLAY1 <= "00001001";
                when "0111" => DISPLAY1 <= "00001010";
                when "1000" => DISPLAY1 <= "00001011";
                when "1001" => DISPLAY1 <= "00001100";
                when "1010" => DISPLAY1 <= "01000011";
                when "1011" => DISPLAY1 <= "01000100";
                when "1100" => DISPLAY1 <= "01000101";
                when "1101" => DISPLAY1 <= "01000110";
                when "1110" => DISPLAY1 <= "01000111";
                when others => DISPLAY1 <= "01001000";
            end case;
        elsif SEL = "10" then
            -- Cdigo BCD en display
            DISPLAY1 <= "00000000";
            case BCD is
                when "0000" => 
                    AN <= "0111";
                    DISPLAY2 <= "10000001";
                when "0001" =>  
                    AN <= "0111";
                    DISPLAY2 <= "11001111";
                when "0010" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10010010";
                when "0011" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10000110";
                when "0100" =>  
                    AN <= "0111";
                    DISPLAY2 <= "11001100";
                when "0101" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10100100";
                when "0110" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10100000";
                when "0111" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10001110";
                when "1000" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10000000";
                when "1001" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10001100";
                when others =>  
                    AN <= "0111";
                    DISPLAY2 <= "11111111";
            end case;
        else
            -- Cdigo Octal en display
            DISPLAY1 <= "00000000";
            case seleccion is
                when "00" => mostrar <= "0111";
                when others => mostrar <= "1011";
            end case;

            case BCD is
                when "0000" => 
                    AN <= "0111";
                    DISPLAY2 <= "10000001";
                when "0001" => 
                    AN <= "0111";
                    DISPLAY2 <= "11001111";
                when "0010" => 
                    AN <= "0111";
                    DISPLAY2 <= "10010010";
                when "0011" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10000110";
                when "0100" =>  
                    AN <= "0111";
                    DISPLAY2 <= "11001100";
                when "0101" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10100100";
                when "0110" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10100000";
                when "0111" =>  
                    AN <= "0111";
                    DISPLAY2 <= "10001110"; -- hasta aqu es un solo display
                when "1000" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10000001";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when "1001" =>
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "11001111";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when "1010" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10010010";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when "1011" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10000110";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar; 
                when "1100" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "11001100";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when "1101" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10100100";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when "1110" => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10100000";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
                when others => 
                    case mostrar is 
                        when "0111" => DISPLAY2 <= "10001110";
                        when "1011" => DISPLAY2 <= "11001111";
                        when others => DISPLAY2 <= "11111111";
                    end case;
                    AN <= mostrar;
            end case;
        end if;
    end process;
end arqdecos;


net CLK loc = B8;

net BCD(3) loc = N3;
net BCD(2) loc = E2;
net BCD(1) loc = F3;
net BCD(0) loc = G3;

net SEL(1) loc = L3;
net SEL(0) loc = P11;

net DISPLAY1(7) loc = G1;
net DISPLAY1(6) loc = P4;
net DISPLAY1(5) loc = N4;
net DISPLAY1(4) loc = N5;
net DISPLAY1(3) loc = P6;
net DISPLAY1(2) loc = P7;
net DISPLAY1(1) loc = M11;
net DISPLAY1(0) loc = M5;

net DISPLAY2(7) loc = N13;
net DISPLAY2(6) loc = L14;
net DISPLAY2(5) loc = H12;
net DISPLAY2(4) loc = N14;
net DISPLAY2(3) loc = N11;
net DISPLAY2(2) loc = P12;
net DISPLAY2(1) loc = L13;
net DISPLAY2(0) loc = M12;

net AN(3) loc = F12;
net AN(2) loc = J12;
net AN(1) loc = M13;
net AN(0) loc = K14;


--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:56:32 06/11/2024
-- Design Name:   
-- Module Name:   /home/ise/VHDL/Ptr10e2/simulacionnew.vhd
-- Project Name:  Ptr10e2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Convertidores
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simulacionnew IS
END simulacionnew;
 
ARCHITECTURE behavior OF simulacionnew IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Convertidores
    PORT(
         CLK : IN  std_logic;
         BCD : IN  std_logic_vector(3 downto 0);
         SEL : IN  std_logic_vector(1 downto 0);
         DISPLAY1 : OUT  std_logic_vector(7 downto 0);
         DISPLAY2 : OUT  std_logic_vector(7 downto 0);
         AN : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal BCD : std_logic_vector(3 downto 0) := (others => '0');
   signal SEL : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal DISPLAY1 : std_logic_vector(7 downto 0);
   signal DISPLAY2 : std_logic_vector(7 downto 0);
   signal AN : std_logic_vector(3 downto 0);

   -- Clock period definitions
   --constant aviCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Convertidores PORT MAP (
          CLK => CLK,
          BCD => BCD,
          SEL => SEL,
          DISPLAY1 => DISPLAY1,
          DISPLAY2 => DISPLAY2,
          AN => AN
        );

   SEL<= "11" after 100 ns; --"01" after 400 ns, "10" after 800 ns, "11" after 1200 ns;
	BCD<= "0000" after 100 ns, "0011" after 200 ns, "1000" after 300 ns, "1111" after 400 ns,
			"0100" after 500 ns, "0111" after 600 ns, "1001" after 700 ns, "1011" after 800 ns,
			"0000" after 900 ns, "0101" after 1000 ns, "1001" after 1100 ns, "1111" after 1200 ns, "0100" after 1300 ns, "0111" after 1400 ns, "1011" after 1500 ns, "0011" after 1600 ns;

 

  

END;
