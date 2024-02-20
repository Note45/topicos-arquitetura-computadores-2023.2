LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_DecoderUnit IS
END ENTITY TB_DecoderUnit;

ARCHITECTURE testbench OF TB_DecoderUnit IS
    COMPONENT DecoderUnit IS
        PORT(
            Clock               :  IN STD_LOGIC;
            Reset               :  IN STD_LOGIC;

            Instruction_0_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_1_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_2_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_3_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_0_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);   -- REGISTERS_USED(2 DOWNTO 0)
            Inst_0_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_0_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_0_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_1_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_1_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_2_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_2_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_3_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_3_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT DecoderUnit;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';
    SIGNAL RESET_TB                             : STD_LOGIC                             := '0';

    SIGNAL INSTRUCTION_0_IN_TB                  : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_1_IN_TB                  : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_2_IN_TB                  : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_3_IN_TB                  : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

    SIGNAL INSTRUCTION_0_OUT_TB                 : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INST_0_CONTROL_TB                    : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_0_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL INST_0_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_0_RD_TB                         : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_0_RS1_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_0_RS2_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_0_IMM_TB                        : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    
    SIGNAL INSTRUCTION_1_OUT_TB                 : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INST_1_CONTROL_TB                    : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_1_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL INST_1_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_1_RD_TB                         : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_1_RS1_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_1_RS2_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_1_IMM_TB                        : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    
    SIGNAL INSTRUCTION_2_OUT_TB                 : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INST_2_CONTROL_TB                    : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_2_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL INST_2_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_2_RD_TB                         : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_2_RS1_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_2_RS2_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_2_IMM_TB                        : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    
    SIGNAL INSTRUCTION_3_OUT_TB                 : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INST_3_CONTROL_TB                    : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_3_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL INST_3_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL INST_3_RD_TB                         : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_3_RS1_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_3_RS2_TB                        : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL INST_3_IMM_TB                        : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

BEGIN

    -- Controls the Clock signal
    Clock_Process : PROCESS
    BEGIN
        CLOCK_TB <= '0';
        WAIT FOR CLOCK_PERIOD/2;
        CLOCK_TB <= '1';
        CYCLE_COUNT <= CYCLE_COUNT + 1;
        WAIT FOR CLOCK_PERIOD/2;

        IF (CYCLE_COUNT = 12) THEN
            REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        END IF;
    END PROCESS Clock_Process;


    -- DUT Instantiation
    Decoder : DecoderUnit
    PORT MAP(
        Clock => CLOCK_TB,
        Reset => RESET_TB,

        Instruction_0_In => INSTRUCTION_0_IN_TB,
        Instruction_1_In => INSTRUCTION_1_IN_TB,
        Instruction_2_In => INSTRUCTION_2_IN_TB,
        Instruction_3_In => INSTRUCTION_3_IN_TB,

        Instruction_0_Out => INSTRUCTION_0_OUT_TB,
        Inst_0_Control => INST_0_CONTROL_TB,
        Inst_0_Funct7 => INST_0_FUNCT7_TB,
        Inst_0_Funct3 => INST_0_FUNCT3_TB,
        Inst_0_RD => INST_0_RD_TB,
        Inst_0_RS1 => INST_0_RS1_TB,
        Inst_0_RS2 => INST_0_RS2_TB,
        Inst_0_Imm => INST_0_IMM_TB,

        Instruction_1_Out => INSTRUCTION_1_OUT_TB,
        Inst_1_Control => INST_1_CONTROL_TB,
        Inst_1_Funct7 => INST_1_FUNCT7_TB,
        Inst_1_Funct3 => INST_1_FUNCT3_TB,
        Inst_1_RD => INST_1_RD_TB,
        Inst_1_RS1 => INST_1_RS1_TB,
        Inst_1_RS2 => INST_1_RS2_TB,
        Inst_1_Imm => INST_1_IMM_TB,

        Instruction_2_Out => INSTRUCTION_2_OUT_TB,
        Inst_2_Control => INST_2_CONTROL_TB,
        Inst_2_Funct7 => INST_2_FUNCT7_TB,
        Inst_2_Funct3 => INST_2_FUNCT3_TB,
        Inst_2_RD => INST_2_RD_TB,
        Inst_2_RS1 => INST_2_RS1_TB,
        Inst_2_RS2 => INST_2_RS2_TB,
        Inst_2_Imm => INST_2_IMM_TB,

        Instruction_3_Out => INSTRUCTION_3_OUT_TB,
        Inst_3_Control => INST_3_CONTROL_TB,
        Inst_3_Funct7 => INST_3_FUNCT7_TB,
        Inst_3_Funct3 => INST_3_FUNCT3_TB,
        Inst_3_RD => INST_3_RD_TB,
        Inst_3_RS1 => INST_3_RS1_TB,
        Inst_3_RS2 => INST_3_RS2_TB,
        Inst_3_Imm => INST_3_IMM_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        --
        -- Instruction_0: ADD r4, r30, r7
        -- Instruction_1: SUB r31, r11, r3
        -- Instruction_2: SLL r3, r4, r10
        -- Instruction_3: SLT r11, r9, r17
        INSTRUCTION_0_IN_TB <= "00000000011111110000001000110011";
        INSTRUCTION_1_IN_TB <= "01000000001101011000111110110011";
        INSTRUCTION_2_IN_TB <= "00000000101000100001000110110011";
        INSTRUCTION_3_IN_TB <= "00000001000101001010010110110011";
        WAIT FOR 5 ns;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        --
        -- Instruction_0: SLTU r31, r23, r26
        -- Instruction_1: XOR r15, r12, r5
        -- Instruction_2: SRL r28, r0, r11
        -- Instruction_3: SRA r2, r11, r13
        INSTRUCTION_0_IN_TB <= "00000001101010111011111110110011";
        INSTRUCTION_1_IN_TB <= "00000000010101100100011110110011";
        INSTRUCTION_2_IN_TB <= "00000000101100000101111000110011";
        INSTRUCTION_3_IN_TB <= "01000000110101011101000100110011";
        WAIT FOR 5 ns;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        --
        -- Instruction_0: OR r25, r11, r21
        -- Instruction_1: AND r6, r5, r13
        -- Instruction_2: MUL r23, r6, r18
        -- Instruction_3: MULH r5, r4, r24
        INSTRUCTION_0_IN_TB <= "00000001010101011110110010110011";
        INSTRUCTION_1_IN_TB <= "00000000110100101111001100110011";
        INSTRUCTION_2_IN_TB <= "00000011001000110000101110110011";
        INSTRUCTION_3_IN_TB <= "00000011100000100001001010110011";
        WAIT FOR 5 ns;


        --                             Cycle 4                             --
        --                           15 to 20 ns
        --
        -- Instruction_0: MULHSU r5, r29, r25
        -- Instruction_1: MULHU r14, r20, r18
        -- Instruction_2: DIV r7, r29, r28
        -- Instruction_3: DIVU r27, r31, r25
        INSTRUCTION_0_IN_TB <= "00000011100111101010001010110011";
        INSTRUCTION_1_IN_TB <= "00000011001010100011011100110011";
        INSTRUCTION_2_IN_TB <= "00000011110011101100001110110011";
        INSTRUCTION_3_IN_TB <= "00000011100111111101110110110011";
        WAIT FOR 5 ns;


        --                             Cycle 5                             --
        --                           20 to 25 ns
        --
        -- Instruction_0: REM r4, r27, r19
        -- Instruction_1: REMU r30, r12, r25
        -- Instruction_2: JALR r25, r3, 2365
        -- Instruction_3: LB r13, r28, 3062
        INSTRUCTION_0_IN_TB <= "00000011001111011110001000110011";
        INSTRUCTION_1_IN_TB <= "00000011100101100111111100110011";
        INSTRUCTION_2_IN_TB <= "10010011110100011000110011100111";
        INSTRUCTION_3_IN_TB <= "10111111011011100000011010000011";
        WAIT FOR 5 ns;

        
        --                             Cycle 6                             --
        --                           25 to 30 ns
        --
        -- Instruction_0: LH r5, r16, 679
        -- Instruction_1: LW r26, r14, 2692
        -- Instruction_2: LBU r17, r12, 3106
        -- Instruction_3: LHU r13, r26, 3967
        INSTRUCTION_0_IN_TB <= "00101010011110000001001010000011";
        INSTRUCTION_1_IN_TB <= "10101000010001110010110100000011";
        INSTRUCTION_2_IN_TB <= "11000010001001100100100010000011";
        INSTRUCTION_3_IN_TB <= "11110111111111010101011010000011";
        WAIT FOR 5 ns;


        --                             Cycle 7                             --
        --                           30 to 35 ns
        --
        -- Instruction_0: ADDI r30, r1, 1280
        -- Instruction_1: SLTI r14, r19, 2238
        -- Instruction_2: SLTIU r8, r0, 3357
        -- Instruction_3: XORI r30, r0, 2451
        INSTRUCTION_0_IN_TB <= "01010000000000001000111100010011";
        INSTRUCTION_1_IN_TB <= "10001011111010011010011100010011";
        INSTRUCTION_2_IN_TB <= "11010001110100000011010000010011";
        INSTRUCTION_3_IN_TB <= "10011001001100000100111100010011";
        WAIT FOR 5 ns;


        --                             Cycle 8                             --
        --                           35 to 40 ns
        --
        -- Instruction_0: ORI r30, r5, 111
        -- Instruction_1: ANDI r18, r17, 300
        -- Instruction_2: SLLI r13, r3, 22
        -- Instruction_3: SRLI r20, r6, 9
        INSTRUCTION_0_IN_TB <= "00000110111100101110111100010011";
        INSTRUCTION_1_IN_TB <= "00010010110010001111100100010011";
        INSTRUCTION_2_IN_TB <= "00000001011000011001011010010011";
        INSTRUCTION_3_IN_TB <= "00000000100100110101101000010011";
        WAIT FOR 5 ns;


        --                             Cycle 9                             --
        --                           40 to 45 ns
        --
        -- Instruction_0: SRAI r3, r19, 23
        -- Instruction_1: SB r30, r13, 1260
        -- Instruction_2: SH r15, r5, 1942
        -- Instruction_3: SW r4, r0, 727
        INSTRUCTION_0_IN_TB <= "00000001011110011101000110010011"; 
        INSTRUCTION_1_IN_TB <= "11011000110111110000010010100011";
        INSTRUCTION_2_IN_TB <= "00101100010101111001011110100011"; 
        INSTRUCTION_3_IN_TB <= "10101110000000100010001010100011";
        WAIT FOR 5 ns;


        --                             Cycle 10                             --
        --                           45 to 50 ns
        --
        -- Instruction_0: BEQ r16, r2, 1561
        -- Instruction_1: BNE r9, r18, 1941
        -- Instruction_2: BLT r28, r28, 1748
        -- Instruction_3: BGE r26, r15, 164
        INSTRUCTION_0_IN_TB <= "01000010001010000000100111100011";
        INSTRUCTION_1_IN_TB <= "01110011001001001001010111100011";
        INSTRUCTION_2_IN_TB <= "01011011110011100100010011100011";
        INSTRUCTION_3_IN_TB <= "00010100111111010101010001100011";
        WAIT FOR 5 ns;


        --                             Cycle 11                             --
        --                           50 to 55 ns
        --
        -- Instruction_0: BLTU r29, r12, 768
        -- Instruction_1: BGEU r26, r23, 1600
        -- Instruction_2: LUI r10, 214083
        -- Instruction_3: AUIPC r22, 22874
        INSTRUCTION_0_IN_TB <= "01100000110011101110000001100011";
        INSTRUCTION_1_IN_TB <= "01001001011111010111000011100011";
        INSTRUCTION_2_IN_TB <= "00110100010001000011010100110111";
        INSTRUCTION_3_IN_TB <= "00000101100101011010101100010111";
        WAIT FOR 5 ns;


        --                             Cycle 12                             --
        --                           55 to 60 ns
        --
        -- Instruction_0: JAL r27, 97236
        -- Instruction_1: INVALID OPERATION
        INSTRUCTION_0_IN_TB <= "01111010100000101111110111101111"; 
        INSTRUCTION_1_IN_TB <= "11000111100001100110010110011111";
        WAIT FOR 5 ns;


        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        --
        -- Instruction_0: ADD r4, r30, r7
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 000
        --         RD: 00100
        --        RS1: 11110
        --        RS2: 00111
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_1: SUB r31, r11, r3
        --    Control: 111
        --     Funct7: 0100000
        --     Funct3: 000
        --         RD: 11111
        --        RS1: 01011
        --        RS2: 00011
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_2: SLL r3, r4, r10
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 001
        --         RD: 00011
        --        RS1: 00100
        --        RS2: 01010
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_3: SLT r11, r9, r17
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 010
        --         RD: 01011
        --        RS1: 01001
        --        RS2: 10001
        --  Immediate: 00000000000000000000000000000000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                                        REPORT "Cycle 1 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "111")                              REPORT "Cycle 1 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 1 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "000")                               REPORT "Cycle 1 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00100")                                 REPORT "Cycle 1 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "11110")                                REPORT "Cycle 1 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00111")                                REPORT "Cycle 1 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 1 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "111")                              REPORT "Cycle 1 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0100000")                           REPORT "Cycle 1 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "000")                               REPORT "Cycle 1 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "11111")                                 REPORT "Cycle 1 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "01011")                                REPORT "Cycle 1 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00011")                                REPORT "Cycle 1 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 1 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "111")                              REPORT "Cycle 1 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 1 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "001")                               REPORT "Cycle 1 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "00011")                                 REPORT "Cycle 1 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00100")                                REPORT "Cycle 1 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "01010")                                REPORT "Cycle 1 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 1 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "111")                              REPORT "Cycle 1 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 1 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "010")                               REPORT "Cycle 1 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "01011")                                 REPORT "Cycle 1 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "01001")                                REPORT "Cycle 1 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "10001")                                REPORT "Cycle 1 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 1 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 1)                                       REPORT "Cycle 1 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 2                             --
        --                            5 to 10 ns
        --
        -- Instruction_0: SLTU r31, r23, r26
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 011
        --         RD: 11111
        --        RS1: 10111
        --        RS2: 11010
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_1: XOR r15, r12, r5
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 100
        --         RD: 01111
        --        RS1: 01100
        --        RS2: 00101
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_2: SRL r28, r0, r11
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 101
        --         RD: 11100
        --        RS1: 00000
        --        RS2: 01011
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_3: SRA r2, r11, r13
        --    Control: 111
        --     Funct7: 0100000
        --     Funct3: 101
        --         RD: 00010
        --        RS1: 01011
        --        RS2: 01101
        --  Immediate: 00000000000000000000000000000000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                                        REPORT "Cycle 2 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "111")                              REPORT "Cycle 2 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 2 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "011")                               REPORT "Cycle 2 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "11111")                                 REPORT "Cycle 2 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "10111")                                REPORT "Cycle 2 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "11010")                                REPORT "Cycle 2 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 2 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "111")                              REPORT "Cycle 2 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 2 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "100")                               REPORT "Cycle 2 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "01111")                                 REPORT "Cycle 2 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "01100")                                REPORT "Cycle 2 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00101")                                REPORT "Cycle 2 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 2 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "111")                              REPORT "Cycle 2 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 2 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "101")                               REPORT "Cycle 2 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "11100")                                 REPORT "Cycle 2 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00000")                                REPORT "Cycle 2 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "01011")                                REPORT "Cycle 2 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 2 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "111")                              REPORT "Cycle 2 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0100000")                           REPORT "Cycle 2 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "101")                               REPORT "Cycle 2 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "00010")                                 REPORT "Cycle 2 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "01011")                                REPORT "Cycle 2 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "01101")                                REPORT "Cycle 2 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 2 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 2)                                       REPORT "Cycle 2 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 3                             --
        --                           10 to 15 ns
        --
        -- Instruction_0: OR r25, r11, r21
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 110
        --         RD: 11001
        --        RS1: 01011
        --        RS2: 10101
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_1: AND r6, r5, r13
        --    Control: 111
        --     Funct7: 0000000
        --     Funct3: 111
        --         RD: 00110
        --        RS1: 00101
        --        RS2: 01101
        --  Immediate: 0

        -- Instruction_2: MUL r23, r6, r18
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 000
        --         RD: 10111
        --        RS1: 00110
        --        RS2: 10010
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_3: MULH r5, r4, r24
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 001
        --         RD: 00101
        --        RS1: 00100
        --        RS2: 11000
        --  Immediate: 00000000000000000000000000000000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 3)                                        REPORT "Cycle 3 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "111")                              REPORT "Cycle 3 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 3 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "110")                               REPORT "Cycle 3 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "11001")                                 REPORT "Cycle 3 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "01011")                                REPORT "Cycle 3 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "10101")                                REPORT "Cycle 3 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 3 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "111")                              REPORT "Cycle 3 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 3 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "111")                               REPORT "Cycle 3 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "00110")                                 REPORT "Cycle 3 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "00101")                                REPORT "Cycle 3 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "01101")                                REPORT "Cycle 3 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 3 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "111")                              REPORT "Cycle 3 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000001")                           REPORT "Cycle 3 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "000")                               REPORT "Cycle 3 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "10111")                                 REPORT "Cycle 3 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00110")                                REPORT "Cycle 3 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "10010")                                REPORT "Cycle 3 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 3 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "111")                              REPORT "Cycle 3 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000001")                           REPORT "Cycle 3 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "001")                               REPORT "Cycle 3 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "00101")                                 REPORT "Cycle 3 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "00100")                                REPORT "Cycle 3 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "11000")                                REPORT "Cycle 3 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 3 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 3)                                       REPORT "Cycle 3 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 4                             --
        --                           15 to 20 ns
        --
        -- Instruction_0: MULHSU r5, r29, r25
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 010
        --         RD: 00101
        --        RS1: 11101
        --        RS2: 11001
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_1: MULHU r14, r20, r18
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 011
        --         RD: 01110
        --        RS1: 10100
        --        RS2: 10010
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_2: DIV r7, r29, r28
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 100
        --         RD: 00111
        --        RS1: 11101
        --        RS2: 11100
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_3: DIVU r27, r31, r25
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 101
        --         RD: 11011
        --        RS1: 11111
        --        RS2: 11001
        --  Immediate: 00000000000000000000000000000000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 4)                                        REPORT "Cycle 4 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "111")                              REPORT "Cycle 4 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000001")                           REPORT "Cycle 4 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "010")                               REPORT "Cycle 4 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00101")                                 REPORT "Cycle 4 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "11101")                                REPORT "Cycle 4 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "11001")                                REPORT "Cycle 4 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 4 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "111")                              REPORT "Cycle 4 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000001")                           REPORT "Cycle 4 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "011")                               REPORT "Cycle 4 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "01110")                                 REPORT "Cycle 4 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "10100")                                REPORT "Cycle 4 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "10010")                                REPORT "Cycle 4 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 4 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "111")                              REPORT "Cycle 4 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000001")                           REPORT "Cycle 4 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "100")                               REPORT "Cycle 4 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "00111")                                 REPORT "Cycle 4 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "11101")                                REPORT "Cycle 4 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "11100")                                REPORT "Cycle 4 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 4 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "111")                              REPORT "Cycle 4 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000001")                           REPORT "Cycle 4 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "101")                               REPORT "Cycle 4 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "11011")                                 REPORT "Cycle 4 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "11111")                                REPORT "Cycle 4 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "11001")                                REPORT "Cycle 4 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 4 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 4)                                       REPORT "Cycle 4 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 5                             --
        --                           20 to 25 ns
        --
        -- Instruction_0: REM r4, r27, r19
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 110
        --         RD: 00100
        --        RS1: 11011
        --        RS2: 10011
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_1: REMU r30, r12, r25
        --    Control: 111
        --     Funct7: 0000001
        --     Funct3: 111
        --         RD: 11110
        --        RS1: 01100
        --        RS2: 11001
        --  Immediate: 00000000000000000000000000000000

        -- Instruction_2: JALR r25, r3, 2365
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 000
        --         RD: 11001
        --        RS1: 00011
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111100100111101

        -- Instruction_3: LB r13, r28, 3062
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 000
        --         RD: 01101
        --        RS1: 11100
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111101111110110
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 5)                                        REPORT "Cycle 5 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "111")                              REPORT "Cycle 5 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000001")                           REPORT "Cycle 5 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "110")                               REPORT "Cycle 5 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00100")                                 REPORT "Cycle 5 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "11011")                                REPORT "Cycle 5 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "10011")                                REPORT "Cycle 5 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 5 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "111")                              REPORT "Cycle 5 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000001")                           REPORT "Cycle 5 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "111")                               REPORT "Cycle 5 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "11110")                                 REPORT "Cycle 5 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "01100")                                REPORT "Cycle 5 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "11001")                                REPORT "Cycle 5 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 5 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "110")                              REPORT "Cycle 5 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 5 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "000")                               REPORT "Cycle 5 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "11001")                                 REPORT "Cycle 5 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00011")                                REPORT "Cycle 5 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00000")                                REPORT "Cycle 5 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "11111111111111111111100100111101")     REPORT "Cycle 5 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "110")                              REPORT "Cycle 5 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 5 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "000")                               REPORT "Cycle 5 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "01101")                                 REPORT "Cycle 5 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "11100")                                REPORT "Cycle 5 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 5 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "11111111111111111111101111110110")     REPORT "Cycle 5 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 5)                                       REPORT "Cycle 5 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 6                             --
        --                           25 to 30 ns
        --
        -- Instruction_0: LH r5, r16, 679
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 001
        --         RD: 00101
        --        RS1: 10000
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000001010100111

        -- Instruction_1: LW r26, r14, 2692
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 010
        --         RD: 11010
        --        RS1: 01110
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111101010000100

        -- Instruction_2: LBU r17, r12, 3106
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 100
        --         RD: 10001
        --        RS1: 01100
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111110000100010

        -- Instruction_3: LHU r13, r26, 3967
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 101
        --         RD: 01101
        --        RS1: 11010
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111111101111111
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 6)                                        REPORT "Cycle 6 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "110")                              REPORT "Cycle 6 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 6 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "001")                               REPORT "Cycle 6 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00101")                                 REPORT "Cycle 6 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "10000")                                REPORT "Cycle 6 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00000")                                REPORT "Cycle 6 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000001010100111")     REPORT "Cycle 6 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "110")                              REPORT "Cycle 6 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 6 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "010")                               REPORT "Cycle 6 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "11010")                                 REPORT "Cycle 6 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "01110")                                REPORT "Cycle 6 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00000")                                REPORT "Cycle 6 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "11111111111111111111101010000100")     REPORT "Cycle 6 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "110")                              REPORT "Cycle 6 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 6 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "100")                               REPORT "Cycle 6 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "10001")                                 REPORT "Cycle 6 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "01100")                                REPORT "Cycle 6 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00000")                                REPORT "Cycle 6 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "11111111111111111111110000100010")     REPORT "Cycle 6 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "110")                              REPORT "Cycle 6 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 6 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "101")                               REPORT "Cycle 6 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "01101")                                 REPORT "Cycle 6 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "11010")                                REPORT "Cycle 6 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 6 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "11111111111111111111111101111111")     REPORT "Cycle 6 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 6)                                       REPORT "Cycle 6 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 7                             --
        --                           30 to 35 ns
        --
        -- Instruction_0: ADDI r30, r1, 1280
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 000
        --         RD: 11110
        --        RS1: 00001
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000010100000000

        -- Instruction_1: SLTI r14, r19, 2238
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 010
        --         RD: 01110
        --        RS1: 10011
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111100010111110

        -- Instruction_2: SLTIU r8, r0, 3357
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 011
        --         RD: 01000
        --        RS1: 00000
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111110100011101

        -- Instruction_3: XORI r30, r0, 2451
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 100
        --         RD: 11110
        --        RS1: 00000
        --        RS2: xxxxx
        --  Immediate: 11111111111111111111100110010011
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 7)                                        REPORT "Cycle 7 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "110")                              REPORT "Cycle 7 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 7 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "000")                               REPORT "Cycle 7 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "11110")                                 REPORT "Cycle 7 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "00001")                                REPORT "Cycle 7 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000010100000000")     REPORT "Cycle 7 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "110")                              REPORT "Cycle 7 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 7 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "010")                               REPORT "Cycle 7 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "01110")                                 REPORT "Cycle 7 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "10011")                                REPORT "Cycle 7 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "11111111111111111111100010111110")     REPORT "Cycle 7 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "110")                              REPORT "Cycle 7 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 7 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "011")                               REPORT "Cycle 7 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "01000")                                 REPORT "Cycle 7 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "11111111111111111111110100011101")     REPORT "Cycle 7 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "110")                              REPORT "Cycle 7 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 7 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "100")                               REPORT "Cycle 7 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "11110")                                 REPORT "Cycle 7 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 7 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "11111111111111111111100110010011")     REPORT "Cycle 7 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 7)                                       REPORT "Cycle 7 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 8                             --
        --                           35 to 40 ns
        --
        -- Instruction_0: ORI r30, r5, 111
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 110
        --         RD: 11110
        --        RS1: 00101
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000000001101111

        -- Instruction_1: ANDI r18, r17, 300
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 111
        --         RD: 10010
        --        RS1: 10001
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000000100101100

        -- Instruction_2: SLLI r13, r3, 22
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 001
        --         RD: 01101
        --        RS1: 00011
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000000000010110

        -- Instruction_3: SRLI r20, r6, 9
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 101
        --         RD: 10100
        --        RS1: 00110
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000000000001001
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 8)                                        REPORT "Cycle 8 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "110")                              REPORT "Cycle 8 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 8 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "110")                               REPORT "Cycle 8 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "11110")                                 REPORT "Cycle 8 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "00101")                                REPORT "Cycle 8 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00000")                                REPORT "Cycle 8 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000001101111")     REPORT "Cycle 8 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "110")                              REPORT "Cycle 8 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 8 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "111")                               REPORT "Cycle 8 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "10010")                                 REPORT "Cycle 8 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "10001")                                REPORT "Cycle 8 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00000")                                REPORT "Cycle 8 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000100101100")     REPORT "Cycle 8 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "110")                              REPORT "Cycle 8 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 8 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "001")                               REPORT "Cycle 8 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "01101")                                 REPORT "Cycle 8 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00011")                                REPORT "Cycle 8 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00000")                                REPORT "Cycle 8 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000000000010110")     REPORT "Cycle 8 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "110")                              REPORT "Cycle 8 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 8 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "101")                               REPORT "Cycle 8 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "10100")                                 REPORT "Cycle 8 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "00110")                                REPORT "Cycle 8 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 8 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000000001001")     REPORT "Cycle 8 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 8)                                       REPORT "Cycle 8 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 9                             --
        --                           40 to 45 ns
        --
        -- Instruction_0: SRAI r3, r19, 23
        --    Control: 110
        --     Funct7: xxxxxxx
        --     Funct3: 101
        --         RD: 00011
        --        RS1: 10011
        --        RS2: xxxxx
        --  Immediate: 00000000000000000000000000010111

        -- Instruction_1: SB r30, r13, 1260
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 000
        --         RD: xxxxx
        --        RS1: 11110
        --        RS2: 01101
        --  Immediate: 11111111111111111111110110001001

        -- Instruction_2: SH r15, r5, 1942
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 001
        --         RD: xxxxx
        --        RS1: 01111
        --        RS2: 00101
        --  Immediate: 00000000000000000000001011001111 

        -- Instruction_3: SW r4, r0, 727
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 010
        --         RD: xxxxx
        --        RS1: 00100
        --        RS2: 00000
        --  Immediate: 11111111111111111111101011100101
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 9)                                        REPORT "Cycle 9 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "110")                              REPORT "Cycle 9 - Unexpected value of Inst_0_Control"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 9 - Unexpected value of Inst_0_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "101")                               REPORT "Cycle 9 - Unexpected value of Inst_0_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00011")                                 REPORT "Cycle 9 - Unexpected value of Inst_0_RD"          SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "10011")                                REPORT "Cycle 9 - Unexpected value of Inst_0_RSl"         SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00000")                                REPORT "Cycle 9 - Unexpected value of Inst_0_RS2"         SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000000000010111")     REPORT "Cycle 9 - Unexpected value of Inst_0_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "011")                              REPORT "Cycle 9 - Unexpected value of Inst_1_Control"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 9 - Unexpected value of Inst_1_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "000")                               REPORT "Cycle 9 - Unexpected value of Inst_1_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "00000")                                 REPORT "Cycle 9 - Unexpected value of Inst_1_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "11110")                                REPORT "Cycle 9 - Unexpected value of Inst_1_RSl"         SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "01101")                                REPORT "Cycle 9 - Unexpected value of Inst_1_RS2"         SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "11111111111111111111110110001001")     REPORT "Cycle 9 - Unexpected value of Inst_1_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "011")                              REPORT "Cycle 9 - Unexpected value of Inst_2_Control"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 9 - Unexpected value of Inst_2_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "001")                               REPORT "Cycle 9 - Unexpected value of Inst_2_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "00000")                                 REPORT "Cycle 9 - Unexpected value of Inst_2_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "01111")                                REPORT "Cycle 9 - Unexpected value of Inst_2_RSl"         SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00101")                                REPORT "Cycle 9 - Unexpected value of Inst_2_RS2"         SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000001011001111")     REPORT "Cycle 9 - Unexpected value of Inst_2_Immediate"   SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "011")                              REPORT "Cycle 9 - Unexpected value of Inst_3_Control"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 9 - Unexpected value of Inst_3_Funct7"      SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "010")                               REPORT "Cycle 9 - Unexpected value of Inst_3_Funct3"      SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "00000")                                 REPORT "Cycle 9 - Unexpected value of Inst_3_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "00100")                                REPORT "Cycle 9 - Unexpected value of Inst_3_RSl"         SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 9 - Unexpected value of Inst_3_RS2"         SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "11111111111111111111101011100101")     REPORT "Cycle 9 - Unexpected value of Inst_3_Immediate"   SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 9)                                       REPORT "Cycle 9 - Finishing tests"                        SEVERITY NOTE;



        --                             Cycle 10                             --
        --                           45 to 50 ns
        --
        -- Instruction_0: BEQ r16, r2, 1561
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 000
        --         RD: xxxxx
        --        RS1: 10000
        --        RS2: 00010
        --  Immediate: 00000000000000000000110000110010

        -- Instruction_1: BNE r9, r18, 1941
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 001
        --         RD: xxxxx
        --        RS1: 01001
        --        RS2: 10010
        --  Immediate: 00000000000000000000111100101010

        -- Instruction_2: BLT r28, r28, 1748
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 100
        --         RD: xxxxx
        --        RS1: 11100
        --        RS2: 11100
        --  Immediate: 00000000000000000000110110101000

        -- Instruction_3: BGE r26, r15, 164
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 101
        --         RD: xxxxx
        --        RS1: 11010
        --        RS2: 01111
        --  Immediate: 00000000000000000000000101001000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 10)                                       REPORT "Cycle 10 - Unexpected value on Cycle_Count"       SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "011")                              REPORT "Cycle 10 - Unexpected value of Inst_0_Control"    SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 10 - Unexpected value of Inst_0_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "000")                               REPORT "Cycle 10 - Unexpected value of Inst_0_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00000")                                 REPORT "Cycle 10 - Unexpected value of Inst_0_RD"         SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "10000")                                REPORT "Cycle 10 - Unexpected value of Inst_0_RSl"        SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00010")                                REPORT "Cycle 10 - Unexpected value of Inst_0_RS2"        SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000110000110010")     REPORT "Cycle 10 - Unexpected value of Inst_0_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "011")                              REPORT "Cycle 10 - Unexpected value of Inst_1_Control"    SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 10 - Unexpected value of Inst_1_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "001")                               REPORT "Cycle 10 - Unexpected value of Inst_1_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "00000")                                 REPORT "Cycle 10 - Unexpected value of Inst_1_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "01001")                                REPORT "Cycle 10 - Unexpected value of Inst_1_RSl"        SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "10010")                                REPORT "Cycle 10 - Unexpected value of Inst_1_RS2"        SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000111100101010")     REPORT "Cycle 10 - Unexpected value of Inst_1_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "011")                              REPORT "Cycle 10 - Unexpected value of Inst_2_Control"    SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 10 - Unexpected value of Inst_2_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "100")                               REPORT "Cycle 10 - Unexpected value of Inst_2_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "00000")                                 REPORT "Cycle 10 - Unexpected value of Inst_2_RD"         SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "11100")                                REPORT "Cycle 10 - Unexpected value of Inst_2_RSl"        SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "11100")                                REPORT "Cycle 10 - Unexpected value of Inst_2_RS2"        SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00000000000000000000110110101000")     REPORT "Cycle 10 - Unexpected value of Inst_2_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "011")                              REPORT "Cycle 10 - Unexpected value of Inst_3_Control"    SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 10 - Unexpected value of Inst_3_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "101")                               REPORT "Cycle 10 - Unexpected value of Inst_3_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "00000")                                 REPORT "Cycle 10 - Unexpected value of Inst_3_RD"         SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "11010")                                REPORT "Cycle 10 - Unexpected value of Inst_3_RSl"        SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "01111")                                REPORT "Cycle 10 - Unexpected value of Inst_3_RS2"        SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000000000000000000000101001000")     REPORT "Cycle 10 - Unexpected value of Inst_3_Immediate"  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 10)                                      REPORT "Cycle 10 - Finishing tests"                       SEVERITY NOTE;



        --                             Cycle 11                             --
        --                           50 to 55 ns
        --
        -- Instruction_0: BLTU r29, r12, 768
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 110
        --         RD: xxxxx
        --        RS1: 11101
        --        RS2: 01100
        --  Immediate: 00000000000000000000011000000000

        -- Instruction_1: BGEU r26, r23, 1600
        --    Control: 011
        --     Funct7: xxxxxxx
        --     Funct3: 111
        --         RD: xxxxx
        --        RS1: 11010
        --        RS2: 10111
        --  Immediate: 00000000000000000000110010000000

        -- Instruction_2: LUI r10, 214083
        --    Control: 100
        --     Funct7: xxxxxxx
        --     Funct3: xxx
        --         RD: 01010
        --        RS1: xxxxx
        --        RS2: xxxxx
        --  Immediate: 00110100010001000011000000000000

        -- Instruction_3: AUIPC r22, 22874
        --    Control: 100
        --     Funct7: xxxxxxx
        --     Funct3: xxx
        --         RD: 10110
        --        RS1: xxxxx
        --        RS2: xxxxx
        --  Immediate: 00000101100101011010000000000000
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 11)                                       REPORT "Cycle 11 - Unexpected value on Cycle_Count"       SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "011")                              REPORT "Cycle 11 - Unexpected value of Inst_0_Control"    SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 11 - Unexpected value of Inst_0_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "110")                               REPORT "Cycle 11 - Unexpected value of Inst_0_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "00000")                                 REPORT "Cycle 11 - Unexpected value of Inst_0_RD"         SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "11101")                                REPORT "Cycle 11 - Unexpected value of Inst_0_RSl"        SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "01100")                                REPORT "Cycle 11 - Unexpected value of Inst_0_RS2"        SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000000000011000000000")     REPORT "Cycle 11 - Unexpected value of Inst_0_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "011")                              REPORT "Cycle 11 - Unexpected value of Inst_1_Control"    SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 11 - Unexpected value of Inst_1_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "111")                               REPORT "Cycle 11 - Unexpected value of Inst_1_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "00000")                                 REPORT "Cycle 11 - Unexpected value of Inst_1_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "11010")                                REPORT "Cycle 11 - Unexpected value of Inst_1_RSl"        SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "10111")                                REPORT "Cycle 11 - Unexpected value of Inst_1_RS2"        SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000110010000000")     REPORT "Cycle 11 - Unexpected value of Inst_1_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_2_CONTROL_TB = "100")                              REPORT "Cycle 11 - Unexpected value of Inst_2_Control"    SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT7_TB = "0000000")                           REPORT "Cycle 11 - Unexpected value of Inst_2_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_2_FUNCT3_TB = "000")                               REPORT "Cycle 11 - Unexpected value of Inst_2_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_2_RD_TB = "01010")                                 REPORT "Cycle 11 - Unexpected value of Inst_2_RD"         SEVERITY FAILURE;
        ASSERT (INST_2_RS1_TB = "00000")                                REPORT "Cycle 11 - Unexpected value of Inst_2_RSl"        SEVERITY FAILURE;
        ASSERT (INST_2_RS2_TB = "00000")                                REPORT "Cycle 11 - Unexpected value of Inst_2_RS2"        SEVERITY FAILURE;
        ASSERT (INST_2_IMM_TB = "00110100010001000011000000000000")     REPORT "Cycle 11 - Unexpected value of Inst_2_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_3_CONTROL_TB = "100")                              REPORT "Cycle 11 - Unexpected value of Inst_3_Control"    SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT7_TB = "0000000")                           REPORT "Cycle 11 - Unexpected value of Inst_3_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_3_FUNCT3_TB = "000")                               REPORT "Cycle 11 - Unexpected value of Inst_3_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_3_RD_TB = "10110")                                 REPORT "Cycle 11 - Unexpected value of Inst_3_RD"         SEVERITY FAILURE;
        ASSERT (INST_3_RS1_TB = "00000")                                REPORT "Cycle 11 - Unexpected value of Inst_3_RSl"        SEVERITY FAILURE;
        ASSERT (INST_3_RS2_TB = "00000")                                REPORT "Cycle 11 - Unexpected value of Inst_3_RS2"        SEVERITY FAILURE;
        ASSERT (INST_3_IMM_TB = "00000101100101011010000000000000")     REPORT "Cycle 11 - Unexpected value of Inst_3_Immediate"  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 11)                                      REPORT "Cycle 11 - Finishing tests"                       SEVERITY NOTE;



        --                             Cycle 12                             --
        --                           55 to 60 ns
        --
        -- Instruction_0: JAL r27, 97236
        --    Control: 100
        --     Funct7: xxxxxxx
        --     Funct3: xxx
        --         RD: 11011
        --        RS1: xxxxx
        --        RS2: xxxxx
        --  Immediate: 00000000000000101111011110101000

        -- Instruction_1: INVALID OPERATION
        --    Control: xxx
        --     Funct7: xxxxxxx
        --     Funct3: xxx
        --         RD: xxxxx
        --        RS1: xxxxx
        --        RS2: xxxxx
        --  Immediate: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 12)                                       REPORT "Cycle 12 - Unexpected value on Cycle_Count"       SEVERITY FAILURE;

        ASSERT (INST_0_CONTROL_TB = "100")                              REPORT "Cycle 12 - Unexpected value of Inst_0_Control"    SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT7_TB = "0000000")                           REPORT "Cycle 12 - Unexpected value of Inst_0_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_0_FUNCT3_TB = "000")                               REPORT "Cycle 12 - Unexpected value of Inst_0_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_0_RD_TB = "11011")                                 REPORT "Cycle 12 - Unexpected value of Inst_0_RD"         SEVERITY FAILURE;
        ASSERT (INST_0_RS1_TB = "00000")                                REPORT "Cycle 12 - Unexpected value of Inst_0_RSl"        SEVERITY FAILURE;
        ASSERT (INST_0_RS2_TB = "00000")                                REPORT "Cycle 12 - Unexpected value of Inst_0_RS2"        SEVERITY FAILURE;
        ASSERT (INST_0_IMM_TB = "00000000000000101111011110101000")     REPORT "Cycle 12 - Unexpected value of Inst_0_Immediate"  SEVERITY FAILURE;

        ASSERT (INST_1_CONTROL_TB = "000")                              REPORT "Cycle 12 - Unexpected value of Inst_1_Control"    SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT7_TB = "0000000")                           REPORT "Cycle 12 - Unexpected value of Inst_1_Funct7"     SEVERITY FAILURE;
        ASSERT (INST_1_FUNCT3_TB = "000")                               REPORT "Cycle 12 - Unexpected value of Inst_1_Funct3"     SEVERITY FAILURE;
        ASSERT (INST_1_RD_TB = "00000")                                 REPORT "Cycle 12 - Unexpected value of Inst_1_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RS1_TB = "00000")                                REPORT "Cycle 12 - Unexpected value of Inst_1_RSl"        SEVERITY FAILURE;
        ASSERT (INST_1_RS2_TB = "00000")                                REPORT "Cycle 12 - Unexpected value of Inst_1_RS2"        SEVERITY FAILURE;
        ASSERT (INST_1_IMM_TB = "00000000000000000000000000000000")     REPORT "Cycle 12 - Unexpected value of Inst_1_Immediate"  SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 12)                                      REPORT "Cycle 12 - Finishing tests"                       SEVERITY NOTE;



        WAIT;
    END PROCESS Output_Process;


END ARCHITECTURE testbench;