LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_FunctionalUnit_Multiplier IS
END ENTITY TB_FunctionalUnit_Multiplier;

ARCHITECTURE testbench OF TB_FunctionalUnit_Multiplier IS
    COMPONENT FunctionalUnit_Multiplier IS
        PORT(
            Funct3                      :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);             -- Specifies the instruction between all of the M module
            RRF_Dest                    :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);             -- Specifies the destination register on RRF
    
            Operand_A                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the first value of the operation
            Operand_B                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the second value of the operation
    
            Result_Bus_Write_On_RRF     : OUT STD_LOGIC_VECTOR(37 DOWNTO 0)             -- VALID_SIGNAL(37) & RRF_DEST(36 DOWNTO 32) & RESULT(31 DOWNTO 0)
        );
    END COMPONENT FunctionalUnit_Multiplier;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';

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

        IF (CYCLE_COUNT = 4) THEN
            REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        END IF;
    END PROCESS Clock_Process;


    -- DUT Instantiation
    FU_Mult : FunctionalUnit_Multiplier
    PORT MAP(
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
        -- Testing: MUL instruction; Positive values; Bigger value on operand A
        --
        --      Funct3:   000   (Instruction MUL)
        --    RRF_Dest: 01111   (RRF(15))
        --   Operand_A:   320
        --   Operand_B:    19
        FUNCT3_TB <= "000";
        RRF_DEST_TB <= "01111";
        OPERAND_A_TB <= "00000000000000000000000101000000";
        OPERAND_B_TB <= "00000000000000000000000000010011";
        WAIT FOR 5 ns;

        
        --                             Cycle 2                             --
        --                            5 to 10 ns
        -- Testing: MUL instruction; Positive and negative values; Negative value on operand A
        --
        --      Funct3:    000   (Instruction MUL)
        --    RRF_Dest:  01110   (RRF(14))
        --   Operand_A: -11899
        --   Operand_B:      5
        FUNCT3_TB <= "000";
        RRF_DEST_TB <= "01110";
        OPERAND_A_TB <= "11111111111111111101000110000101";
        OPERAND_B_TB <= "00000000000000000000000000000101";
        WAIT FOR 5 ns;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        -- Testing: MULH instruction; Negative and positive values; Bigger value on operand B
        --
        --      Funct3:   001   (Instruction MULH)
        --    RRF_Dest: 10001   (RRF(17))
        --   Operand_A: -9717
        --   Operand_B: 14100
        FUNCT3_TB <= "001";
        RRF_DEST_TB <= "10001";
        OPERAND_A_TB <= "11111111111111111101101000001011";
        OPERAND_B_TB <= "00000000000000000011011100010100";
        WAIT FOR 5 ns;


        --                             Cycle 4                             --
        --                           15 to 20 ns
        -- Testing: MULH instruction; Zero value; Negative value on operand B
        --
        --      Funct3:    001   (Instruction MULH)
        --    RRF_Dest:  11111   (RRF(31))
        --   Operand_A:      0
        --   Operand_B: -12994
        FUNCT3_TB <= "001";
        RRF_DEST_TB <= "11111";
        OPERAND_A_TB <= "00000000000000000000000000000000";
        OPERAND_B_TB <= "11111111111111111100110100111110";
        WAIT FOR 5 ns;
        WAIT;
    END PROCESS;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01111 (RRF(15))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000001011111000000b = 6080 (320 * 19) (32 LSB)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                                                        REPORT "Cycle 1 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000001011111000000")   
        REPORT "Cycle 1 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10111100000000000000000001011111000000")
        REPORT "Cycle 1 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;
        
        ASSERT (CYCLE_COUNT /= 1)                                                       REPORT "Cycle 1 - Finishing tests"                              SEVERITY NOTE;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 01110 (RRF(14))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  11111111111111110001011110011001b = -59495 (-11899 * 5) (32 LSB)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                                                        REPORT "Cycle 2 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "11111111111111110001011110011001")   
        REPORT "Cycle 2 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "10111011111111111111110001011110011001")
        REPORT "Cycle 2 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 2)                                                       REPORT "Cycle 2 - Finishing tests"                              SEVERITY NOTE;
        
        
        --                             Cycle 3                             --
        --                           10 to 15 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 10001 (RRF(17))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  11111111111111111111111111111111b = -1 (-9717 * 14100) (32 MSB)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 3)                                                        REPORT "Cycle 3 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "11111111111111111111111111111111")   
        REPORT "Cycle 3 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11000111111111111111111111111111111111")
        REPORT "Cycle 3 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 3)                                                       REPORT "Cycle 3 - Finishing tests"                              SEVERITY NOTE;
        
        
        --                             Cycle 4                             --
        --                           15 to 20 ns
        -- Expected result:
        --   Result_Bus_Write_On_RRF(37):           1
        --   Result_Bus_Write_On_RRF(36 DOWNTO 32): 11111 (RRF(31))
        --   Result_Bus_Write_On_RRF(31 DOWNTO 0):  00000000000000000000000000000000b = 0 (0 * -12994) (32 MSB)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 4)                                                        REPORT "Cycle 4 - Unexpected value on Cycle_Count"              SEVERITY FAILURE;

        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0) /= "00000000000000000000000000000000")   
        REPORT "Cycle 4 - Result value: " & integer'image(to_integer(signed(RESULT_BUS_WRITE_ON_RRF_TB(31 DOWNTO 0))))                                  SEVERITY NOTE;
        ASSERT (RESULT_BUS_WRITE_ON_RRF_TB = "11111100000000000000000000000000000000")
        REPORT "Cycle 4 - Unexpected value on Result_Bus_Write_On_RRF"                                                                                  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 4)                                                       REPORT "Cycle 4 - Finishing tests"                              SEVERITY NOTE;
        
        
        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;