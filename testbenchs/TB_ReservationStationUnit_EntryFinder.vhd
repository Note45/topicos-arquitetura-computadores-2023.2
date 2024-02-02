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

    SIGNAL BUSY_VECTOR_TB                       : STD_LOGIC_VECTOR(3 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_0_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_1_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_2_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL INST_3_ENTRY_TB                      : STD_LOGIC_VECTOR(2 DOWNTO 0)                  := (OTHERS => '0');

BEGIN

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


        REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Testing: All positions available;
        WAIT FOR 5 ns;
        ASSERT (INST_0_ENTRY_TB = "000") REPORT "Instant 1 - Unexpected value of Inst_0_Entry" SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001") REPORT "Instant 1 - Unexpected value of Inst_1_Entry" SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "010") REPORT "Instant 1 - Unexpected value of Inst_2_Entry" SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011") REPORT "Instant 1 - Unexpected value of Inst_3_Entry" SEVERITY FAILURE;


        --                             Instant 2                             --
        -- Testing: Position 0 unavailable;
        WAIT FOR 5 ns;
        ASSERT (INST_0_ENTRY_TB = "100") REPORT "Instant 2 - Unexpected value of Inst_0_Entry" SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001") REPORT "Instant 2 - Unexpected value of Inst_1_Entry" SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "010") REPORT "Instant 2 - Unexpected value of Inst_2_Entry" SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011") REPORT "Instant 2 - Unexpected value of Inst_3_Entry" SEVERITY FAILURE;


        --                             Instant 3                             --
        -- Testing: Positions 2 and 3 unavailable;
        WAIT FOR 5 ns;
        ASSERT (INST_0_ENTRY_TB = "000") REPORT "Instant 3 - Unexpected value of Inst_0_Entry" SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "001") REPORT "Instant 3 - Unexpected value of Inst_1_Entry" SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100") REPORT "Instant 3 - Unexpected value of Inst_2_Entry" SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "100") REPORT "Instant 3 - Unexpected value of Inst_3_Entry" SEVERITY FAILURE;


        --                             Instant 4                             --
        -- Testing: Positions 0, 1 and 2 unavailable;
        WAIT FOR 5 ns;
        ASSERT (INST_0_ENTRY_TB = "100") REPORT "Instant 4 - Unexpected value of Inst_0_Entry" SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "100") REPORT "Instant 4 - Unexpected value of Inst_1_Entry" SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100") REPORT "Instant 4 - Unexpected value of Inst_2_Entry" SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "011") REPORT "Instant 4 - Unexpected value of Inst_3_Entry" SEVERITY FAILURE;


        --                             Instant 5                             --
        -- Testing: All positions unavailable;
        WAIT FOR 5 ns;
        ASSERT (INST_0_ENTRY_TB = "100") REPORT "Instant 5 - Unexpected value of Inst_0_Entry" SEVERITY FAILURE;
        ASSERT (INST_1_ENTRY_TB = "100") REPORT "Instant 5 - Unexpected value of Inst_1_Entry" SEVERITY FAILURE;
        ASSERT (INST_2_ENTRY_TB = "100") REPORT "Instant 5 - Unexpected value of Inst_2_Entry" SEVERITY FAILURE;
        ASSERT (INST_3_ENTRY_TB = "100") REPORT "Instant 5 - Unexpected value of Inst_3_Entry" SEVERITY FAILURE;


        WAIT FOR 5 ns;
        WAIT;
    END PROCESS Output_Process;
END ARCHITECTURE testbench;