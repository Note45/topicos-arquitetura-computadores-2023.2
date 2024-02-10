LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_ReservationStationUnit_EntryFinder IS
END ENTITY TB_ReservationStationUnit_EntryFinder;

ARCHITECTURE testbench OF TB_ReservationStationUnit_EntryFinder IS
    COMPONENT ReservationStationUnit_EntryFinder IS
        PORT(
            Busy_Vector         :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            Inst_0_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit_EntryFinder;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';

    SIGNAL BUSY_VECTOR_TB                       : STD_LOGIC_VECTOR(3 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_0_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_1_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_2_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_3_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');

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
    RSU_EF : ReservationStationUnit_EntryFinder
    PORT MAP(
        Busy_Vector => BUSY_VECTOR_TB,

        Inst_0_Entry => INST_0_ENTRY_TB,
        Inst_1_Entry => INST_1_ENTRY_TB,
        Inst_2_Entry => INST_2_ENTRY_TB,
        Inst_3_Entry => INST_3_ENTRY_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Current state of the buffer: no instructions allocated
        BUSY_VECTOR_TB <= "0000";
        WAIT FOR 5 ns;


        --                             Instant 2                             --
        -- Current state of the buffer: Instruction_0 allocated
        BUSY_VECTOR_TB <= "0001";
        WAIT FOR 5 ns;


        --                             Instant 3                             --
        -- Current state of the buffer: Instructions 2 and 3 allocated
        BUSY_VECTOR_TB <= "1100";
        WAIT FOR 5 ns;


        --                             Instant 4                             --
        -- Current state of the buffer: Instructions 0, 1 and 2 allocated
        BUSY_VECTOR_TB <= "0111";
        WAIT FOR 5 ns;


        --                             Instant 5                             --
        -- Current state of the buffer: all Instructions allocated
        BUSY_VECTOR_TB <= "1111";
        WAIT FOR 5 ns;


        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Testing: All positions available;
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                REPORT "Instant 1 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_ENTRY_TB = "000")        REPORT "Instant 1 - Unexpected value of Inst_0_Entry"       SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001")        REPORT "Instant 1 - Unexpected value of Inst_1_Entry"       SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "010")        REPORT "Instant 1 - Unexpected value of Inst_2_Entry"       SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011")        REPORT "Instant 1 - Unexpected value of Inst_3_Entry"       SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 1)               REPORT "Instant 1 - Finishing tests"                        SEVERITY NOTE;


        --                             Instant 2                             --
        -- Testing: Position 0 unavailable;
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                REPORT "Instant 2 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_ENTRY_TB = "100")        REPORT "Instant 2 - Unexpected value of Inst_0_Entry"       SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001")        REPORT "Instant 2 - Unexpected value of Inst_1_Entry"       SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "010")        REPORT "Instant 2 - Unexpected value of Inst_2_Entry"       SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011")        REPORT "Instant 2 - Unexpected value of Inst_3_Entry"       SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 2)               REPORT "Instant 2 - Finishing tests"                        SEVERITY NOTE;


        --                             Instant 3                             --
        -- Testing: Positions 2 and 3 unavailable;
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 3)                REPORT "Instant 3 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_ENTRY_TB = "000")        REPORT "Instant 3 - Unexpected value of Inst_0_Entry"       SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001")        REPORT "Instant 3 - Unexpected value of Inst_1_Entry"       SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100")        REPORT "Instant 3 - Unexpected value of Inst_2_Entry"       SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "100")        REPORT "Instant 3 - Unexpected value of Inst_3_Entry"       SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 3)               REPORT "Instant 3 - Finishing tests"                        SEVERITY NOTE;


        --                             Instant 4                             --
        -- Testing: Positions 0, 1 and 2 unavailable;
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 4)                REPORT "Instant 4 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_ENTRY_TB = "100")        REPORT "Instant 4 - Unexpected value of Inst_0_Entry"       SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "100")        REPORT "Instant 4 - Unexpected value of Inst_1_Entry"       SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100")        REPORT "Instant 4 - Unexpected value of Inst_2_Entry"       SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011")        REPORT "Instant 4 - Unexpected value of Inst_3_Entry"       SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 4)               REPORT "Instant 4 - Finishing tests"                        SEVERITY NOTE;


        --                             Instant 5                             --
        -- Testing: All positions unavailable;
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 5)                REPORT "Instant 5 - Unexpected value on Cycle_Count"        SEVERITY FAILURE;

        ASSERT (INST_0_ENTRY_TB = "100")        REPORT "Instant 5 - Unexpected value of Inst_0_Entry"       SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "100")        REPORT "Instant 5 - Unexpected value of Inst_1_Entry"       SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100")        REPORT "Instant 5 - Unexpected value of Inst_2_Entry"       SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "100")        REPORT "Instant 5 - Unexpected value of Inst_3_Entry"       SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 5)               REPORT "Instant 5 - Finishing tests"                        SEVERITY NOTE;


        WAIT FOR 5 ns;
        WAIT;
    END PROCESS Output_Process;
END ARCHITECTURE testbench;