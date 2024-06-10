--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:58:54 06/05/2024
-- Design Name:   
-- Module Name:   /home/ise/ISE/Practica_9/P9_1/simulacion.vhd
-- Project Name:  P9_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: circuito_combinacional
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
 
ENTITY simulacion IS
END simulacion;
 
ARCHITECTURE eq_booleanas  OF simulacion IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT circuito_combinacional
    PORT(
         A : IN  std_logic;
         B : IN  std_logic;
         C : IN  std_logic;
         F : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic := '0';
   signal B : std_logic := '0';
   signal C : std_logic := '0';

 	--Outputs
   signal F : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circuito_combinacional PORT MAP (
          A => A,
          B => B,
          C => C,
          F => F
        );
A <= '0' AFTER 100 NS, '0' AFTER 200 NS, '0' AFTER 300 NS, '0' AFTER 400 NS,'1' AFTER 500 NS,'1' AFTER 600 NS,'1' AFTER 700 NS,'1' AFTER 800 NS;
B <= '0' AFTER 100 NS, '0' AFTER 200 NS, '1' AFTER 300 NS, '1' AFTER 400 NS,'0' AFTER 500 NS,'0' AFTER 600 NS,'1' AFTER 700 NS,'1' AFTER 800 NS;
C <= '0' AFTER 100 NS, '1' AFTER 200 NS, '0' AFTER 300 NS, '1' AFTER 400 NS,'0' AFTER 500 NS,'1' AFTER 600 NS,'0' AFTER 700 NS,'1' AFTER 800 NS;


END;
