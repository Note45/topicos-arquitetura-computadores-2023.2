LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Compressor_4_2 IS
    PORT(
        A           :   IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        B           :   IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        C           :   IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        D           :   IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        CarryIn     :   IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        S           :   OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        Carry       :   OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        CarryOut    :   OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY Compressor_4_2;

ARCHITECTURE behavior OF Compressor_4_2 IS
BEGIN

    -- Sums up the partial products
    S <= std_logic_vector(signed(A) + signed(B) + signed(C) + signed(D));
    Carry <= "0000000000000000000000000000000000000000000000000000000000000000";
    CarryOut <= "0000000000000000000000000000000000000000000000000000000000000000";

END ARCHITECTURE behavior;