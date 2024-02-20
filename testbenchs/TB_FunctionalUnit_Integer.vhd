LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_FunctionalUnit_Integer IS
END ENTITY TB_FunctionalUnit_Integer;

ARCHITECTURE testbench OF TB_FunctionalUnit_Integer IS
    COMPONENT FunctionalUnit_Integer IS
        PORT(
            Identifier                  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);             -- Specifies this type of Functional Unit

            Funct7                      :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);             -- Specifies the instruction
            Funct3                      :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);             -- Specifies the instruction
            RRF_Dest                    :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);             -- Specifies the destination register on RRF
    
            Operand_A                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the first value of the operation
            Operand_B                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the second value of the operation
    
            Result_Bus_Write_On_RRF     : OUT STD_LOGIC_VECTOR(37 DOWNTO 0)             -- VALID_SIGNAL(37) & RRF_DEST(36 DOWNTO 32) & RESULT(31 DOWNTO 0)
        );
    END COMPONENT FunctionalUnit_Integer;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';

    SIGNAL IDENTIFIER_TB                        : STD_LOGIC_VECTOR(1 DOWNTO 0)          := "00";
    SIGNAL FUNCT7_TB                            : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL FUNCT3_TB                            : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL RRF_DEST_TB                          : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";

    SIGNAL OPERAND_A_TB                         : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL OPERAND_B_TB                         : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    
    SIGNAL RESULT_BUS_WRITE_ON_RRF_TB           : STD_LOGIC_VECTOR(37 DOWNTO 0)         := "00000000000000000000000000000000000000";

BEGIN

    -- Controls the Clock signal
    Clock_Process : PROCESS
    BEGIN
        CLOCK_TB <= '0';
        WAIT FOR CLOCK_PERIOD/2;
        CLOCK_TB <= '1';
        CYCLE_COUNT <= CYCLE_COUNT + 1;
        WAIT FOR CLOCK_PERIOD/2;

        IF (CYCLE_COUNT = 10) THEN
            REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        END IF;
    END PROCESS Clock_Process;


    -- DUT Instantiation
    FU_Int : FunctionalUnit_Integer
    PORT MAP(
        Identifier => IDENTIFIER_TB,

        Funct7 => FUNCT7_TB,
        Funct3 => FUNCT3_TB,
        RRF_Dest => RRF_DEST_TB,

        Operand_A => OPERAND_A_TB,
        Operand_B => OPERAND_B_TB,

        Result_Bus_Write_On_RRF => RESULT_BUS_WRITE_ON_RRF_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN
        WAIT FOR 2.5 ns;

        --                             Cycle 1                             --
        --                            0 to 5 ns
        --
        --   Functs:     0000000 & 000   (Instruction ADD)
        --   RRF_Dest:   01010           (RRF(10))
        --   Operand_A:  990225
        --   Operand_B: -563607
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "000";
        RRF_DEST_TB <= "01010";
        OPERAND_A_TB <= "00000000000011110001110000010001";
        OPERAND_B_TB <= "11111111111101110110011001101001";
        WAIT FOR 5 ns;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        --
        --   Functs:     0100000 & 000   (Instruction SUB)
        --   RRF_Dest:   11101           (RRF(29))
        --   Operand_A:  811443
        --   Operand_B:  258282
        FUNCT7_TB <= "0100000";
        FUNCT3_TB <= "000";
        RRF_DEST_TB <= "11101";
        OPERAND_A_TB <= "00000000000011000110000110110011";
        OPERAND_B_TB <= "00000000000000111111000011101010";
        WAIT FOR 5 ns;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        --
        --   Functs:     0000000 & 001   (Instruction SLL)
        --   RRF_Dest:   01110           (RRF(14))
        --   Operand_A:  56978
        --   Operand_B:      9
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "001";
        RRF_DEST_TB <= "01110";
        OPERAND_A_TB <= "00000000000000001101111010010010";
        OPERAND_B_TB <= "00000000000000000000000000001001";
        WAIT FOR 5 ns;


        --                             Cycle 4                             --
        --                           15 to 20 ns
        --
        --   Functs:     0000000 & 010   (Instruction SLT)
        --   RRF_Dest:   01011           (RRF(11))
        --   Operand_A:  1013863
        --   Operand_B:        3
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "010";
        RRF_DEST_TB <= "01011";
        OPERAND_A_TB <= "00000000000011110111100001100111";
        OPERAND_B_TB <= "00000000000000000000000000000011";
        WAIT FOR 5 ns;


        --                             Cycle 5                             --
        --                           20 to 25 ns
        --
        --   Functs:     0000000 & 011   (Instruction SLTU)
        --   RRF_Dest:   11000           (RRF(24))
        --   Operand_A:  -51709
        --   Operand_B:       4
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "011";
        RRF_DEST_TB <= "11000";
        OPERAND_A_TB <= "11111111111111110011011000000011";
        OPERAND_B_TB <= "00000000000000000000000000000100";
        WAIT FOR 5 ns;


        --                             Cycle 6                             --
        --                           25 to 30 ns
        --
        --   Functs:     0000000 & 100   (Instruction XOR)
        --   RRF_Dest:   11010           (RRF(26))
        --   Operand_A: -884592
        --   Operand_B: -844542
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "100";
        RRF_DEST_TB <= "11010";
        OPERAND_A_TB <= "00000000000011110001110000010001";
        OPERAND_B_TB <= "11111111111101110110011001101001";
        WAIT FOR 5 ns;


        --                             Cycle 7                             --
        --                           30 to 35 ns
        --
        --   Functs:     0000000 & 101   (Instruction SRL)
        --   RRF_Dest:   00001           (RRF(1))
        --   Operand_A: -706673
        --   Operand_B:       2
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "101";
        RRF_DEST_TB <= "00001";
        OPERAND_A_TB <= "11111111111101010011011110001111";
        OPERAND_B_TB <= "00000000000000000000000000000010";
        WAIT FOR 5 ns;


        --                             Cycle 8                             --
        --                           35 to 40 ns
        --
        --   Functs:     0100000 & 101   (Instruction SRA)
        --   RRF_Dest:   11011           (RRF(27))
        --   Operand_A:  827630
        --   Operand_B:      18
        FUNCT7_TB <= "0100000";
        FUNCT3_TB <= "101";
        RRF_DEST_TB <= "11011";
        OPERAND_A_TB <= "00000000000011001010000011101110";
        OPERAND_B_TB <= "00000000000000000000000000010010";
        WAIT FOR 5 ns;


        --                             Cycle 9                             --
        --                           40 to 45 ns
        --
        --   Functs:     0000000 & 110   (Instruction OR)
        --   RRF_Dest:   11000           (RRF(24))
        --   Operand_A:  62289
        --   Operand_B:  545374
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "110";
        RRF_DEST_TB <= "11000";
        OPERAND_A_TB <= "00000000000000001111001101010001";
        OPERAND_B_TB <= "00000000000010000101001001011110";
        WAIT FOR 5 ns;


        --                             Cycle 10                             --
        --                           45 to 50 ns
        --
        --   Functs:     0000000 & 111   (Instruction AND)
        --   RRF_Dest:   01110           (RRF(14))
        --   Operand_A: -377818
        --   Operand_B:   71071
        FUNCT7_TB <= "0000000";
        FUNCT3_TB <= "111";
        RRF_DEST_TB <= "01110";
        OPERAND_A_TB <= "11111111111110100011110000100110";
        OPERAND_B_TB <= "00000000000000010001010110011111";
        WAIT FOR 5 ns;
        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01010 (RRF(10))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000001101000001001111010b = 426618 (990225 + -563607)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                                                        REPORT "Cycle 1 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000001101000001001111010")   
        REPORT "Cycle 1 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10101000000000000001101000001001111010")
        REPORT "Cycle 1 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 1)                                                       REPORT "Cycle 1 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11101 (RRF(29))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000010000111000011001001b = 553161 (811443 - 258282)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                                                        REPORT "Cycle 2 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000010000111000011001001")   
        REPORT "Cycle 2 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11110100000000000010000111000011001001")
        REPORT "Cycle 2 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 2)                                                       REPORT "Cycle 2 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01110 (RRF(14))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000001101111010010010000000000b = 29172736
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 3)                                                        REPORT "Cycle 3 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000001101111010010010000000000")   
        REPORT "Cycle 3 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10111000000001101111010010010000000000")
        REPORT "Cycle 3 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 3)                                                       REPORT "Cycle 3 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 4                             --+
        --                           15 to 20 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01011 (RRF(11))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000000000000000000b = 0
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 4)                                                        REPORT "Cycle 4 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000000000000000000")   
        REPORT "Cycle 4 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10101100000000000000000000000000000000")
        REPORT "Cycle 4 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 4)                                                       REPORT "Cycle 4 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 5                             --
        --                           20 to 25 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11000 (RRF(24))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000000000000000000b = 0
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 5)                                                        REPORT "Cycle 5 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000000000000000000")   
        REPORT "Cycle 5 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11100000000000000000000000000000000000")
        REPORT "Cycle 5 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 5)                                                       REPORT "Cycle 5 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 6                             --
        --                           25 to 30 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11010 (RRF(26))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  11111111111110000111101001111000b = 4294474360
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 6)                                                        REPORT "Cycle 6 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "11111111111110000111101001111000")   
        REPORT "Cycle 6 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11101011111111111110000111101001111000")
        REPORT "Cycle 6 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 6)                                                       REPORT "Cycle 6 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 7                             --
        --                           30 to 35 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 00001 (RRF(1))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00111111111111010100110111100011b = 1073565155
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 7)                                                        REPORT "Cycle 7 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00111111111111010100110111100011")   
        REPORT "Cycle 7 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10000100111111111111010100110111100011")
        REPORT "Cycle 7 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 7)                                                       REPORT "Cycle 7 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 8                             --
        --                           35 to 40 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11011 (RRF(27))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000000000000000011b = 3
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 8)                                                        REPORT "Cycle 8 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000000000000000011")   
        REPORT "Cycle 8 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11101100000000000000000000000000000011")
        REPORT "Cycle 8 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 8)                                                       REPORT "Cycle 8 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 9                             --
        --                           40 to 45 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11000 (RRF(24))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000010001111001101011111b = 586591
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 9)                                                        REPORT "Cycle 9 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000010001111001101011111")   
        REPORT "Cycle 9 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11100000000000000010001111001101011111")
        REPORT "Cycle 9 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 9)                                                       REPORT "Cycle 9 - Finishing tests"                              SEVERITY NOTE;




        --                             Cycle 10                             --
        --                           45 to 50 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01110 (RRF(14))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000001010000000110b = 5126
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 10)                                                        REPORT "Cycle 10 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000001010000000110")   
        REPORT "Cycle 10 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10111000000000000000000001010000000110")
        REPORT "Cycle 10 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 10)                                                       REPORT "Cycle 10 - Finishing tests"                              SEVERITY NOTE;
        WAIT;
    END PROCESS Output_Process;


END ARCHITECTURE testbench;