LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_RegisterRenameUnit_TagFinder IS
END ENTITY TB_RegisterRenameUnit_TagFinder;

ARCHITECTURE testbench OF TB_RegisterRenameUnit_TagFinder IS
    COMPONENT RegisterRenameUnit_TagFinder IS
        PORT(
            RRF_Busy_Vector_Slice_0     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_1     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_2     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_3     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    
            Inst_0_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);                     -- IS_VALID(5) & RRF_TAG(4 DOWNTO 0)
            Inst_1_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            Inst_2_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            Inst_3_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit_TagFinder;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';

    SIGNAL RRF_BUSY_VECTOR_SLICE_0_TB           : STD_LOGIC_VECTOR(7 DOWNTO 0)          := "00000000";
    SIGNAL RRF_BUSY_VECTOR_SLICE_1_TB           : STD_LOGIC_VECTOR(7 DOWNTO 0)          := "00000000";
    SIGNAL RRF_BUSY_VECTOR_SLICE_2_TB           : STD_LOGIC_VECTOR(7 DOWNTO 0)          := "00000000";
    SIGNAL RRF_BUSY_VECTOR_SLICE_3_TB           : STD_LOGIC_VECTOR(7 DOWNTO 0)          := "00000000";

    SIGNAL INST_0_RRF_TAG_RD_TB                 : STD_LOGIC_VECTOR(5 DOWNTO 0)          := "000000";
    SIGNAL INST_1_RRF_TAG_RD_TB                 : STD_LOGIC_VECTOR(5 DOWNTO 0)          := "000000";
    SIGNAL INST_2_RRF_TAG_RD_TB                 : STD_LOGIC_VECTOR(5 DOWNTO 0)          := "000000";
    SIGNAL INST_3_RRF_TAG_RD_TB                 : STD_LOGIC_VECTOR(5 DOWNTO 0)          := "000000";

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
    RRU_TF : RegisterRenameUnit_TagFinder
    PORT MAP(
        RRF_Busy_Vector_Slice_0 => RRF_BUSY_VECTOR_SLICE_0_TB,
        RRF_Busy_Vector_Slice_1 => RRF_BUSY_VECTOR_SLICE_1_TB,
        RRF_Busy_Vector_Slice_2 => RRF_BUSY_VECTOR_SLICE_2_TB,
        RRF_Busy_Vector_Slice_3 => RRF_BUSY_VECTOR_SLICE_3_TB,

        Inst_0_RRF_Tag_RD => INST_0_RRF_TAG_RD_TB,
        Inst_1_RRF_Tag_RD => INST_1_RRF_TAG_RD_TB,
        Inst_2_RRF_Tag_RD => INST_2_RRF_TAG_RD_TB,
        Inst_3_RRF_Tag_RD => INST_3_RRF_TAG_RD_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Testing: All RRF entries available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00000000";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00000000";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00000000";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00000000";
        WAIT FOR 5 ns;


        --                             Instant 2                             --
        -- Testing: First entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "10101100";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "11101100";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "10111100";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "10101110";
        WAIT FOR 5 ns;


        --                             Instant 3                             --
        -- Testing: First entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "11101100";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "11010100";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "10111000";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "11010100";
        WAIT FOR 5 ns;


        --                             Instant 4                             --
        -- Testing: First entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "01101000";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "11101000";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "10101000";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00101000";
        WAIT FOR 5 ns;


        --                             Instant 5                             --
        -- Testing: Second entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00000001";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00000001";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00000001";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00000001";
        WAIT FOR 5 ns;


        --                             Instant 6                             --
        -- Testing: Third entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00000011";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00000011";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00000011";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00000011";
        WAIT FOR 5 ns;


        --                             Instant 7                             --
        -- Testing: Fourth entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00000111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00000111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00000111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00000111";
        WAIT FOR 5 ns;


        --                             Instant 8                             --
        -- Testing: Fifth entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00001111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00001111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00001111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00001111";
        WAIT FOR 5 ns;


        --                             Instant 9                             --
        -- Testing: Sixth entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00011111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00011111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00011111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00011111";
        WAIT FOR 5 ns;


        --                             Instant 10                             --
        -- Testing: Seventh entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "00111111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "00111111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "00111111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "00111111";
        WAIT FOR 5 ns;


        --                             Instant 11                             --
        -- Testing: Eighth entry of each RRF slice available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "01111111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "01111111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "01111111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "01111111";
        WAIT FOR 5 ns;


        --                             Instant 12                             --
        -- Testing: None of the RRF entries available;
        RRF_BUSY_VECTOR_SLICE_0_TB <= "11111111";
        RRF_BUSY_VECTOR_SLICE_1_TB <= "11111111";
        RRF_BUSY_VECTOR_SLICE_2_TB <= "11111111";
        RRF_BUSY_VECTOR_SLICE_3_TB <= "11111111";
        WAIT FOR 5 ns;


        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- RRF tag for the RD register of Instruction_0: 00000 = RRF(0)
        -- RRF tag for the RD register of Instruction_1: 01000 = RRF(8)
        -- RRF tag for the RD register of Instruction_2: 10000 = RRF(16)
        -- RRF tag for the RD register of Instruction_3: 11000 = RRF(24)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                            REPORT "Instant 1 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000000")            REPORT "Instant 1 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001000")            REPORT "Instant 1 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010000")            REPORT "Instant 1 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011000")            REPORT "Instant 1 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 1)                           REPORT "Instant 1 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 2                             --
        -- RRF tag for the RD register of Instruction_0: 00000 = RRF(0)
        -- RRF tag for the RD register of Instruction_1: 01000 = RRF(8)
        -- RRF tag for the RD register of Instruction_2: 10000 = RRF(16)
        -- RRF tag for the RD register of Instruction_3: 11000 = RRF(24)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                            REPORT "Instant 2 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000000")            REPORT "Instant 2 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001000")            REPORT "Instant 2 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010000")            REPORT "Instant 2 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011000")            REPORT "Instant 2 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 2)                           REPORT "Instant 2 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 3                             --
        -- RRF tag for the RD register of Instruction_0: 00000 = RRF(0)
        -- RRF tag for the RD register of Instruction_1: 01000 = RRF(8)
        -- RRF tag for the RD register of Instruction_2: 10000 = RRF(16)
        -- RRF tag for the RD register of Instruction_3: 11000 = RRF(24)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 3)                            REPORT "Instant 3 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000000")            REPORT "Instant 3 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001000")            REPORT "Instant 3 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010000")            REPORT "Instant 3 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011000")            REPORT "Instant 3 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 3)                           REPORT "Instant 3 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 4                             --
        -- RRF tag for the RD register of Instruction_0: 00000 = RRF(0)
        -- RRF tag for the RD register of Instruction_1: 01000 = RRF(8)
        -- RRF tag for the RD register of Instruction_2: 10000 = RRF(16)
        -- RRF tag for the RD register of Instruction_3: 11000 = RRF(24)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 4)                            REPORT "Instant 4 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000000")            REPORT "Instant 4 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001000")            REPORT "Instant 4 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010000")            REPORT "Instant 4 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011000")            REPORT "Instant 4 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 4)                           REPORT "Instant 4 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 5                             --
        -- RRF tag for the RD register of Instruction_0: 00001 = RRF(1)
        -- RRF tag for the RD register of Instruction_1: 01001 = RRF(9)
        -- RRF tag for the RD register of Instruction_2: 10001 = RRF(17)
        -- RRF tag for the RD register of Instruction_3: 11001 = RRF(25)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 5)                            REPORT "Instant 5 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000001")            REPORT "Instant 5 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001001")            REPORT "Instant 5 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010001")            REPORT "Instant 5 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011001")            REPORT "Instant 5 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 5)                           REPORT "Instant 5 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 6                             --
        -- RRF tag for the RD register of Instruction_0: 00010 = RRF(2)
        -- RRF tag for the RD register of Instruction_1: 01010 = RRF(10)
        -- RRF tag for the RD register of Instruction_2: 10010 = RRF(18)
        -- RRF tag for the RD register of Instruction_3: 11010 = RRF(26)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 6)                            REPORT "Instant 6 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000010")            REPORT "Instant 6 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001010")            REPORT "Instant 6 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010010")            REPORT "Instant 6 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011010")            REPORT "Instant 6 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 6)                           REPORT "Instant 6 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 7                             --
        -- RRF tag for the RD register of Instruction_0: 00011 = RRF(3)
        -- RRF tag for the RD register of Instruction_1: 01011 = RRF(11)
        -- RRF tag for the RD register of Instruction_2: 10011 = RRF(19)
        -- RRF tag for the RD register of Instruction_3: 11011 = RRF(27)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 7)                            REPORT "Instant 7 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000011")            REPORT "Instant 7 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001011")            REPORT "Instant 7 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010011")            REPORT "Instant 7 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011011")            REPORT "Instant 7 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 7)                           REPORT "Instant 7 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 8                             --
        -- RRF tag for the RD register of Instruction_0: 00100 = RRF(4)
        -- RRF tag for the RD register of Instruction_1: 01100 = RRF(12)
        -- RRF tag for the RD register of Instruction_2: 10100 = RRF(20)
        -- RRF tag for the RD register of Instruction_3: 11100 = RRF(28)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 8)                            REPORT "Instant 8 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000100")            REPORT "Instant 8 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001100")            REPORT "Instant 8 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010100")            REPORT "Instant 8 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011100")            REPORT "Instant 8 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 8)                           REPORT "Instant 8 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 9                             --
        -- RRF tag for the RD register of Instruction_0: 00101 = RRF(5)
        -- RRF tag for the RD register of Instruction_1: 01101 = RRF(13)
        -- RRF tag for the RD register of Instruction_2: 10101 = RRF(21)
        -- RRF tag for the RD register of Instruction_3: 11101 = RRF(29)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 9)                            REPORT "Instant 9 - Unexpected value on Cycle_Count"                SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000101")            REPORT "Instant 9 - Unexpected value on Inst_0_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001101")            REPORT "Instant 9 - Unexpected value on Inst_1_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010101")            REPORT "Instant 9 - Unexpected value on Inst_2_RRF_Tag_RD"          SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011101")            REPORT "Instant 9 - Unexpected value on Inst_3_RRF_Tag_RD"          SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 9)                           REPORT "Instant 9 - Finishing tests"                                SEVERITY NOTE;


        --                             Instant 10                             --
        -- RRF tag for the RD register of Instruction_0: 00110 = RRF(6)
        -- RRF tag for the RD register of Instruction_1: 01110 = RRF(14)
        -- RRF tag for the RD register of Instruction_2: 10110 = RRF(22)
        -- RRF tag for the RD register of Instruction_3: 11110 = RRF(30)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 10)                           REPORT "Instant 10 - Unexpected value on Cycle_Count"               SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000110")            REPORT "Instant 10 - Unexpected value on Inst_0_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001110")            REPORT "Instant 10 - Unexpected value on Inst_1_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010110")            REPORT "Instant 10 - Unexpected value on Inst_2_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011110")            REPORT "Instant 10 - Unexpected value on Inst_3_RRF_Tag_RD"         SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 10)                          REPORT "Instant 10 - Finishing tests"                               SEVERITY NOTE;


        --                             Instant 11                             --
        -- RRF tag for the RD register of Instruction_0: 00111 = RRF(7)
        -- RRF tag for the RD register of Instruction_1: 01111 = RRF(15)
        -- RRF tag for the RD register of Instruction_2: 10111 = RRF(23)
        -- RRF tag for the RD register of Instruction_3: 11111 = RRF(31)
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 11)                           REPORT "Instant 11 - Unexpected value on Cycle_Count"               SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "000111")            REPORT "Instant 11 - Unexpected value on Inst_0_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "001111")            REPORT "Instant 11 - Unexpected value on Inst_1_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "010111")            REPORT "Instant 11 - Unexpected value on Inst_2_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "011111")            REPORT "Instant 11 - Unexpected value on Inst_3_RRF_Tag_RD"         SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 11)                          REPORT "Instant 11 - Finishing tests"                               SEVERITY NOTE;


        --                             Instant 12                             --
        -- RRF tag for the RD register of Instruction_0: xxxxx = INVALID TAG
        -- RRF tag for the RD register of Instruction_1: xxxxx = INVALID TAG
        -- RRF tag for the RD register of Instruction_2: xxxxx = INVALID TAG
        -- RRF tag for the RD register of Instruction_3: xxxxx = INVALID TAG
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 12)                           REPORT "Instant 12 - Unexpected value on Cycle_Count"               SEVERITY FAILURE;

        ASSERT (INST_0_RRF_TAG_RD_TB = "100000")            REPORT "Instant 12 - Unexpected value on Inst_0_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_1_RRF_TAG_RD_TB = "100000")            REPORT "Instant 12 - Unexpected value on Inst_1_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_2_RRF_TAG_RD_TB = "100000")            REPORT "Instant 12 - Unexpected value on Inst_2_RRF_Tag_RD"         SEVERITY FAILURE;
        ASSERT (INST_3_RRF_TAG_RD_TB = "100000")            REPORT "Instant 12 - Unexpected value on Inst_3_RRF_Tag_RD"         SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 12)                          REPORT "Instant 12 - Finishing tests"                               SEVERITY NOTE;


        WAIT;
    END PROCESS Output_Process;


END ARCHITECTURE testbench;