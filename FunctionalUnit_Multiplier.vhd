LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FunctionalUnit_Multiplier IS
    PORT(
        Funct3                      :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);             -- Specifies the instruction between all of the M module
        RRF_Dest                    :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);             -- Specifies the destination register on RRF

        Operand_A                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the first value of the operation
        Operand_B                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the second value of the operation

        Result_Bus_Write_On_RRF     : OUT STD_LOGIC_VECTOR(37 DOWNTO 0)             -- VALID_SIGNAL(37) & RRF_DEST(36 DOWNTO 32) & RESULT(31 DOWNTO 0)
    );
END ENTITY FunctionalUnit_Multiplier;

ARCHITECTURE behavior OF FunctionalUnit_Multiplier IS

    -- Booth's Algorithm signals
    SIGNAL Extended_Operand_A   : STD_LOGIC_VECTOR(63 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    SIGNAL Extended_Operand_B   : STD_LOGIC_VECTOR(63 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    SIGNAL Encoded_Operand_B    : STD_LOGIC_VECTOR(64 DOWNTO 0) := "00000000000000000000000000000000000000000000000000000000000000000";

    TYPE GB_BANK IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Grouping_Blocks : GB_BANK := (OTHERS => (OTHERS => '0'));

    TYPE PP_BANK IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Partial_Products : PP_BANK := (OTHERS => (OTHERS => '0'));


    -- Wallace Tree's Compressor
    COMPONENT Compressor_4_2 IS
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
    END COMPONENT Compressor_4_2;

    TYPE CARRY_BANK IS ARRAY(0 TO 14) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Compressors_Carry : CARRY_BANK := (OTHERS => (OTHERS => '0'));

    TYPE COMP_BANK IS ARRAY(0 TO 29) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Compressors_Result : COMP_BANK := (OTHERS => (OTHERS => '0'));


    -- Multiplier signals
    SIGNAL Operation_Result     : STD_LOGIC_VECTOR(63 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000";


BEGIN

    -- Extension of both operands to 64 bits
    WITH Operand_A(31) SELECT Extended_Operand_A <=
        "00000000000000000000000000000000" & Operand_A                      WHEN '0',
        "11111111111111111111111111111111" & Operand_A                      WHEN '1',
        "0000000000000000000000000000000000000000000000000000000000000000"  WHEN OTHERS;

    WITH Operand_B(31) SELECT Extended_Operand_B <=
        "00000000000000000000000000000000" & Operand_B                      WHEN '0',
        "11111111111111111111111111111111" & Operand_B                      WHEN '1',
        "0000000000000000000000000000000000000000000000000000000000000000"  WHEN OTHERS;



    -- Encoding of one of the operands
    Encoded_Operand_B <= Extended_Operand_B & '0';



    -- Three-bit grouping of the encoded operand
    Grouping_Blocks(0) <= Encoded_Operand_B(2 DOWNTO 0);
    Grouping_Blocks(1) <= Encoded_Operand_B(4 DOWNTO 2);
    Grouping_Blocks(2) <= Encoded_Operand_B(6 DOWNTO 4);
    Grouping_Blocks(3) <= Encoded_Operand_B(8 DOWNTO 6);
    Grouping_Blocks(4) <= Encoded_Operand_B(10 DOWNTO 8);
    Grouping_Blocks(5) <= Encoded_Operand_B(12 DOWNTO 10);
    Grouping_Blocks(6) <= Encoded_Operand_B(14 DOWNTO 12);
    Grouping_Blocks(7) <= Encoded_Operand_B(16 DOWNTO 14);
    Grouping_Blocks(8) <= Encoded_Operand_B(18 DOWNTO 16);
    Grouping_Blocks(9) <= Encoded_Operand_B(20 DOWNTO 18);
    Grouping_Blocks(10) <= Encoded_Operand_B(22 DOWNTO 20);
    Grouping_Blocks(11) <= Encoded_Operand_B(24 DOWNTO 22);
    Grouping_Blocks(12) <= Encoded_Operand_B(26 DOWNTO 24);
    Grouping_Blocks(13) <= Encoded_Operand_B(28 DOWNTO 26);
    Grouping_Blocks(14) <= Encoded_Operand_B(30 DOWNTO 28);
    Grouping_Blocks(15) <= Encoded_Operand_B(32 DOWNTO 30);
    Grouping_Blocks(16) <= Encoded_Operand_B(34 DOWNTO 32);
    Grouping_Blocks(17) <= Encoded_Operand_B(36 DOWNTO 34);
    Grouping_Blocks(18) <= Encoded_Operand_B(38 DOWNTO 36);
    Grouping_Blocks(19) <= Encoded_Operand_B(40 DOWNTO 38);
    Grouping_Blocks(20) <= Encoded_Operand_B(42 DOWNTO 40);
    Grouping_Blocks(21) <= Encoded_Operand_B(44 DOWNTO 42);
    Grouping_Blocks(22) <= Encoded_Operand_B(46 DOWNTO 44);
    Grouping_Blocks(23) <= Encoded_Operand_B(48 DOWNTO 46);
    Grouping_Blocks(24) <= Encoded_Operand_B(50 DOWNTO 48);
    Grouping_Blocks(25) <= Encoded_Operand_B(52 DOWNTO 50);
    Grouping_Blocks(26) <= Encoded_Operand_B(54 DOWNTO 52);
    Grouping_Blocks(27) <= Encoded_Operand_B(56 DOWNTO 54);
    Grouping_Blocks(28) <= Encoded_Operand_B(58 DOWNTO 56);
    Grouping_Blocks(29) <= Encoded_Operand_B(60 DOWNTO 58);
    Grouping_Blocks(30) <= Encoded_Operand_B(62 DOWNTO 60);
    Grouping_Blocks(31) <= Encoded_Operand_B(64 DOWNTO 62);



    -- Generation of the partial products
    WITH Grouping_Blocks(0) SELECT Partial_Products(0) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        Extended_Operand_A                                                                                                                                                     WHEN "001" | "010",
        (std_logic_vector(shift_left(signed(Extended_Operand_A), 1)))                                                                                                          WHEN "011",
        (std_logic_vector(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)))                       WHEN "100",
        (std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1))                                              WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(1) SELECT Partial_Products(1) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 2))                                                                                                            WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 2))                                                                   WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 2))  WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 2))       WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(2) SELECT Partial_Products(2) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 4))                                                                                                            WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 4))                                                                   WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 4))  WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 4))       WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(3) SELECT Partial_Products(3) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 6))                                                                                                            WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 6))                                                                   WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 6))  WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 6))       WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(4) SELECT Partial_Products(4) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 8))                                                                                                            WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 8))                                                                   WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 8))  WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 8))       WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(5) SELECT Partial_Products(5) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 10))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 10))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 10)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 10))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(6) SELECT Partial_Products(6) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 12))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 12))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 12)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 12))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(7) SELECT Partial_Products(7) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 14))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 14))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 14)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 14))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(8) SELECT Partial_Products(8) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 16))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 16))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 16)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 16))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(9) SELECT Partial_Products(9) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 18))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 18))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 18)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 18))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(10) SELECT Partial_Products(10) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 20))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 20))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 20)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 20))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(11) SELECT Partial_Products(11) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 22))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 22))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 22)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 22))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(12) SELECT Partial_Products(12) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 24))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 24))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 24)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 24))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(13) SELECT Partial_Products(13) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 26))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 26))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 26)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 26))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(14) SELECT Partial_Products(14) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 28))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 28))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 28)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 28))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(15) SELECT Partial_Products(15) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 30))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 30))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 30)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 30))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(16) SELECT Partial_Products(16) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 32))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 32))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 32)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 32))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(17) SELECT Partial_Products(17) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 34))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 34))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 34)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 34))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(18) SELECT Partial_Products(18) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 36))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 36))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 36)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 36))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(19) SELECT Partial_Products(19) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 38))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 38))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 38)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 38))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(20) SELECT Partial_Products(20) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 40))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 40))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 40)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 40))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(21) SELECT Partial_Products(21) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 42))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 42))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 42)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 42))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(22) SELECT Partial_Products(22) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 44))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 44))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 44)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 44))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(23) SELECT Partial_Products(23) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 46))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 46))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 46)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 46))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(24) SELECT Partial_Products(24) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 48))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 48))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 48)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 48))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(25) SELECT Partial_Products(25) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 50))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 50))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 50)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 50))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(26) SELECT Partial_Products(26) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 52))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 52))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 52)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 52))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(27) SELECT Partial_Products(27) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 54))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 54))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 54)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 54))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(28) SELECT Partial_Products(28) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 56))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 56))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 56)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 56))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(29) SELECT Partial_Products(29) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 58))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 58))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 58)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 58))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(30) SELECT Partial_Products(30) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 60))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 60))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 60)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 60))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;

    WITH Grouping_Blocks(31) SELECT Partial_Products(31) <=
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN "000" | "111",
        std_logic_vector(shift_left(signed(Extended_Operand_A), 62))                                                                                                           WHEN "001" | "010",
        std_logic_vector(shift_left(signed(std_logic_vector(shift_left(signed(Extended_Operand_A), 1))), 62))                                                                  WHEN "011",
        std_logic_vector(shift_left(signed(shift_left(signed(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1), 1)), 62)) WHEN "100",
        std_logic_vector(shift_left(signed(std_logic_vector(signed(Extended_Operand_A XOR "1111111111111111111111111111111111111111111111111111111111111111") + 1)), 62))      WHEN "101" | "110",
        "0000000000000000000000000000000000000000000000000000000000000000"                                                                                                     WHEN OTHERS;



    -- Divides the partial products into groups of four, and allocates them to 4:2 Compressors (Wallace Tree)
    Comp_N0_0 : Compressor_4_2 PORT MAP(Partial_Products(0), Partial_Products(1), Partial_Products(2), Partial_Products(3), "0000000000000000000000000000000000000000000000000000000000000000",
    Compressors_Result(0), Compressors_Result(1), Compressors_Carry(0));
    Comp_N0_1 : Compressor_4_2 PORT MAP(Partial_Products(4), Partial_Products(5), Partial_Products(6), Partial_Products(7), Compressors_Carry(0),
    Compressors_Result(2), Compressors_Result(3), Compressors_Carry(1));
    Comp_N0_2 : Compressor_4_2 PORT MAP(Partial_Products(8), Partial_Products(9), Partial_Products(10), Partial_Products(11), Compressors_Carry(1),
    Compressors_Result(4), Compressors_Result(5), Compressors_Carry(2));
    Comp_N0_3 : Compressor_4_2 PORT MAP(Partial_Products(12), Partial_Products(13), Partial_Products(14), Partial_Products(15), Compressors_Carry(2),
    Compressors_Result(6), Compressors_Result(7), Compressors_Carry(3));
    Comp_N0_4 : Compressor_4_2 PORT MAP(Partial_Products(16), Partial_Products(17), Partial_Products(18), Partial_Products(19), Compressors_Carry(3),
    Compressors_Result(8), Compressors_Result(9), Compressors_Carry(4));
    Comp_N0_5 : Compressor_4_2 PORT MAP(Partial_Products(20), Partial_Products(21), Partial_Products(22), Partial_Products(23), Compressors_Carry(4),
    Compressors_Result(10), Compressors_Result(11), Compressors_Carry(5));
    Comp_N0_6 : Compressor_4_2 PORT MAP(Partial_Products(24), Partial_Products(25), Partial_Products(26), Partial_Products(27), Compressors_Carry(5),
    Compressors_Result(12), Compressors_Result(13), Compressors_Carry(6));
    Comp_N0_7 : Compressor_4_2 PORT MAP(Partial_Products(28), Partial_Products(29), Partial_Products(30), Partial_Products(31), Compressors_Carry(6),
    Compressors_Result(14), Compressors_Result(15), Compressors_Carry(7));

    Comp_N1_0 : Compressor_4_2 PORT MAP(Compressors_Result(0), Compressors_Result(1), Compressors_Result(2), Compressors_Result(3), "0000000000000000000000000000000000000000000000000000000000000000",
    Compressors_Result(16), Compressors_Result(17), Compressors_Carry(8));
    Comp_N1_1 : Compressor_4_2 PORT MAP(Compressors_Result(4), Compressors_Result(5), Compressors_Result(6), Compressors_Result(7), Compressors_Carry(8),
    Compressors_Result(18), Compressors_Result(19), Compressors_Carry(9));
    Comp_N1_2 : Compressor_4_2 PORT MAP(Compressors_Result(8), Compressors_Result(9), Compressors_Result(10), Compressors_Result(11), Compressors_Carry(9),
    Compressors_Result(20), Compressors_Result(21), Compressors_Carry(10));
    Comp_N1_3 : Compressor_4_2 PORT MAP(Compressors_Result(12), Compressors_Result(13), Compressors_Result(14), Compressors_Result(15), Compressors_Carry(10),
    Compressors_Result(22), Compressors_Result(23), Compressors_Carry(11));

    Comp_N2_0 : Compressor_4_2 PORT MAP(Compressors_Result(16), Compressors_Result(17), Compressors_Result(18), Compressors_Result(19), "0000000000000000000000000000000000000000000000000000000000000000",
    Compressors_Result(24), Compressors_Result(25), Compressors_Carry(12));
    Comp_N2_1 : Compressor_4_2 PORT MAP(Compressors_Result(20), Compressors_Result(21), Compressors_Result(22), Compressors_Result(23), Compressors_Carry(12),
    Compressors_Result(26), Compressors_Result(27), Compressors_Carry(13));

    Comp_N3_0 : Compressor_4_2 PORT MAP(Compressors_Result(24), Compressors_Result(25), Compressors_Result(26), Compressors_Result(27), "0000000000000000000000000000000000000000000000000000000000000000",
    Compressors_Result(28), Compressors_Result(29), Compressors_Carry(14));



    -- Sums up the last two compressor results to get the full operation result
    Operation_Result <= std_logic_vector(signed(Compressors_Result(28)) + signed(Compressors_Result(29)));



    -- Selects the result of the instruction according to it's Funct3 field
    WITH Funct3 SELECT Result_Bus_Write_On_RRF <=
        '1' & RRF_Dest & Operation_Result(31 DOWNTO 0)       WHEN "000",     -- MUL
        '1' & RRF_Dest & Operation_Result(63 DOWNTO 32)      WHEN "001",     -- MULH
        '0' & "00000" & "00000000000000000000000000000000"   WHEN OTHERS;





END ARCHITECTURE behavior;