LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FunctionalUnit_Integer is
    PORT(
        Identifier                  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);             -- Specifies this type of Functional Unit

        Funct7                      :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);             -- Specifies the instruction
        Funct3                      :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);             -- Specifies the instruction
        RRF_Dest                    :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);             -- Specifies the destination register on RRF

        Operand_A                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the first value of the operation
        Operand_B                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the second value of the operation

        Result_Bus_Write_On_RRF     : OUT STD_LOGIC_VECTOR(37 DOWNTO 0)             -- VALID_SIGNAL(37) & RRF_DEST(36 DOWNTO 32) & RESULT(31 DOWNTO 0)
    );
END FunctionalUnit_Integer;

ARCHITECTURE behavior of FunctionalUnit_Integer is
    SIGNAL Sign_Operand_A : SIGNED(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL Sign_Operand_B : SIGNED(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL Unsign_Operand_A : UNSIGNED(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL Unsign_Operand_B : UNSIGNED(31 DOWNTO 0) := "00000000000000000000000000000000";
BEGIN

    Sign_Operand_A <= signed(Operand_A);
    Sign_Operand_B <= signed(Operand_B);
    Unsign_Operand_A <= unsigned(Operand_A);
    Unsign_Operand_B <= unsigned(Operand_B);

    -- Selects the result of the instruction according to it's Funct7 and Funct3 field
    Result_Bus_Write_On_RRF <= '1' & RRF_Dest & std_logic_vector(Sign_Operand_A + Sign_Operand_B) WHEN (Funct7 = "0000000" AND Funct3 = "000") ELSE -- ADD
                               '1' & RRF_Dest & std_logic_vector(Sign_Operand_A - Sign_Operand_B) WHEN (Funct7 = "0100000" AND Funct3 = "000") ELSE -- SUB
                               '1' & RRF_Dest & std_logic_vector(shift_left(Unsign_Operand_A, to_integer(Sign_Operand_B))) WHEN (Funct7 = "0000000" AND Funct3 = "001") ELSE -- SLL
                               '1' & RRF_Dest & "00000000000000000000000000000001" WHEN (Funct7 = "0000000" AND Funct3 = "010" AND (Sign_Operand_A < Sign_Operand_B)) ELSE -- SLT
                               '1' & RRF_Dest & "00000000000000000000000000000000" WHEN (Funct7 = "0000000" AND Funct3 = "010" AND (Sign_Operand_A >= Sign_Operand_B)) ELSE -- SLT
                               '1' & RRF_Dest & "00000000000000000000000000000001" WHEN (Funct7 = "0000000" AND Funct3 = "011" AND (Unsign_Operand_A < Unsign_Operand_B)) ELSE -- SLTU
                               '1' & RRF_Dest & "00000000000000000000000000000000" WHEN (Funct7 = "0000000" AND Funct3 = "011" AND (Unsign_Operand_A >= Unsign_Operand_B)) ELSE -- SLTU
                               '1' & RRF_Dest & (Operand_A XOR Operand_B) WHEN (Funct7 = "0000000" AND Funct3 = "100") ELSE -- XOR
                               '1' & RRF_Dest & std_logic_vector(shift_right(Unsign_Operand_A, to_integer(Sign_Operand_B))) WHEN (Funct7 = "0000000" AND Funct3 = "101") ELSE -- SRL
                               '1' & RRF_Dest & std_logic_vector(shift_right(Sign_Operand_A, to_integer(Sign_Operand_B))) WHEN (Funct7 = "0100000" AND Funct3 = "101") ELSE -- SRA
                               '1' & RRF_Dest & (Operand_A OR Operand_B) WHEN (Funct7 = "0000000" AND Funct3 = "110") ELSE -- OR
                               '1' & RRF_Dest & (Operand_A AND Operand_B) WHEN (Funct7 = "0000000" AND Funct3 = "111") ELSE -- AND
                               "00000000000000000000000000000000000000";

    -- Identifies this type of Functional Unit to the RSU
    Identifier <= "00";

END ARCHITECTURE behavior; -- archIU