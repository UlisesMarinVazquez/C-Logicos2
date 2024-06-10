library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder_Subtractor is
    Port (
        A : in STD_LOGIC_VECTOR (3 downto 0);
        B : in STD_LOGIC_VECTOR (3 downto 0);
        mode : in STD_LOGIC; -- 0 for addition, 1 for subtraction
        Sum : out STD_LOGIC_VECTOR (3 downto 0);
        Cout : out STD_LOGIC; -- Carry out/borrow out
        Overflow : out STD_LOGIC -- Overflow flag
    );
end Adder_Subtractor;

architecture Behavioral of Adder_Subtractor is
    signal B_internal : STD_LOGIC_VECTOR (3 downto 0);
    signal Carry : STD_LOGIC_VECTOR (4 downto 0);
begin
    process(A, B, mode)
    begin
        if mode = '1' then
            B_internal <= not B + 1; -- Complemento a dos para resta
        else
            B_internal <= B;
        end if;

        Carry(0) <= mode; -- Carry in es 1 para resta, 0 para suma

        -- Suma bit a bit con el carry
        for i in 0 to 3 loop
            Sum(i) <= A(i) xor B_internal(i) xor Carry(i);
            Carry(i+1) <= (A(i) and B_internal(i)) or (A(i) and Carry(i)) or (B_internal(i) and Carry(i));
        end loop;

        Cout <= Carry(4);

        -- Detecta overflow (para números con signo)
        Overflow <= Carry(3) xor Carry(4);
    end process;
end Behavioral;
