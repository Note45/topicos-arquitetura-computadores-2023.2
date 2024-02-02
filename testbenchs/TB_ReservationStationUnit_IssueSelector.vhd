LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_ReservationStationUnit_IssueSelector IS
END ENTITY TB_ReservationStationUnit_IssueSelector;

ARCHITECTURE testbench OF TB_ReservationStationUnit_IssueSelector IS
    COMPONENT ReservationStationUnit_IssueSelector IS
        PORT(
            Ready_Vector            :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            RSU_Entry_0             :  IN STD_LOGIC_VECTOR(67 DOWNTO 0);
            RSU_Entry_1             :  IN STD_LOGIC_VECTOR(67 DOWNTO 0);
            RSU_Entry_2             :  IN STD_LOGIC_VECTOR(67 DOWNTO 0);
            RSU_Entry_3             :  IN STD_LOGIC_VECTOR(67 DOWNTO 0);
    
            RSU_Entry_Index         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RSU_Entry_Selected      : OUT STD_LOGIC_VECTOR(67 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit_IssueSelector;

    SIGNAL READY_VECTOR_TB                       : STD_LOGIC_VECTOR(3 DOWNTO 0)                  := (OTHERS => '0');

    SIGNAL RSU_ENTRY_0_TB                        : STD_LOGIC_VECTOR(67 DOWNTO 0)                 := (OTHERS => '0');
    SIGNAL RSU_ENTRY_1_TB                        : STD_LOGIC_VECTOR(67 DOWNTO 0)                 := (OTHERS => '0');
    SIGNAL RSU_ENTRY_2_TB                        : STD_LOGIC_VECTOR(67 DOWNTO 0)                 := (OTHERS => '0');
    SIGNAL RSU_ENTRY_3_TB                        : STD_LOGIC_VECTOR(67 DOWNTO 0)                 := (OTHERS => '0');

    SIGNAL RSU_ENTRY_INDEX_TB                    : STD_LOGIC_VECTOR(1 DOWNTO 0)                  := (OTHERS => '0');
    SIGNAL RSU_ENTRY_SELECTED_TB                 : STD_LOGIC_VECTOR(67 DOWNTO 0)                 := (OTHERS => '0');

BEGIN

    -- DUT Instantiation
    RSU_EF : ReservationStationUnit_IssueSelector
    PORT MAP(
        Ready_Vector => READY_VECTOR_TB,

        RSU_Entry_0 => RSU_ENTRY_0_TB,
        RSU_Entry_1 => RSU_ENTRY_1_TB,
        RSU_Entry_2 => RSU_ENTRY_2_TB,
        RSU_Entry_3 => RSU_ENTRY_3_TB,

        RSU_Entry_Index => RSU_ENTRY_INDEX_TB,
        RSU_Entry_Selected => RSU_ENTRY_SELECTED_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Current state of the buffer: no instructions ready
        READY_VECTOR_TB <= "0000";
        WAIT FOR 5 ns;


        --                             Instant 2                             --
        -- Current state of the buffer: Instruction_0 ready
        READY_VECTOR_TB <= "0001";
        RSU_ENTRY_0_TB(0) <= '1';
        WAIT FOR 5 ns;


        --                             Instant 3                             --
        -- Current state of the buffer: Instructions 2 and 3 ready
        READY_VECTOR_TB <= "1100";
        RSU_ENTRY_0_TB(0) <= '0';
        RSU_ENTRY_2_TB(0) <= '1';
        RSU_ENTRY_3_TB(0) <= '1';
        WAIT FOR 5 ns;


        --                             Instant 4                             --
        -- Current state of the buffer: Instructions 0, 1 and 2 ready
        READY_VECTOR_TB <= "0111";
        RSU_ENTRY_0_TB(0) <= '1';
        RSU_ENTRY_1_TB(0) <= '1';
        RSU_ENTRY_2_TB(0) <= '1';
        RSU_ENTRY_3_TB(0) <= '0';
        WAIT FOR 5 ns;


        --                             Instant 5                             --
        -- Current state of the buffer: all Instructions ready
        READY_VECTOR_TB <= "1111";
        RSU_ENTRY_3_TB(0) <= '1';
        WAIT FOR 5 ns;


        REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Instant 1                             --
        -- Testing: No instructions ready;
        WAIT FOR 5 ns;
        ASSERT (RSU_ENTRY_INDEX_TB = "00") REPORT "Instant 1 - Unexpected value of RSU_Entry_Index" SEVERITY FAILURE;
        ASSERT (RSU_ENTRY_SELECTED_TB = "00000000000000000000000000000000000000000000000000000000000000000000") REPORT "Instant 1 - Unexpected value of RSU_Entry_Selected" SEVERITY FAILURE;


        --                             Instant 2                             --
        -- Testing: Instruction 0 ready;
        WAIT FOR 5 ns;
        ASSERT (RSU_ENTRY_INDEX_TB = "00") REPORT "Instant 2 - Unexpected value of RSU_Entry_Index" SEVERITY FAILURE;
        ASSERT (RSU_ENTRY_SELECTED_TB = "00000000000000000000000000000000000000000000000000000000000000000001") REPORT "Instant 2 - Unexpected value of RSU_Entry_Selected" SEVERITY FAILURE;


        --                             Instant 3                             --
        -- Testing: Instructions 2 and 3 ready;
        WAIT FOR 5 ns;
        ASSERT (RSU_ENTRY_INDEX_TB = "10") REPORT "Instant 3 - Unexpected value of RSU_Entry_Index" SEVERITY FAILURE;
        ASSERT (RSU_ENTRY_SELECTED_TB = "00000000000000000000000000000000000000000000000000000000000000000001") REPORT "Instant 3 - Unexpected value of RSU_Entry_Selected" SEVERITY FAILURE;


        --                             Instant 4                             --
        -- Testing: Instructions 0, 1 and 2 ready;
        WAIT FOR 5 ns;
        ASSERT (RSU_ENTRY_INDEX_TB = "00") REPORT "Instant 4 - Unexpected value of RSU_Entry_Index" SEVERITY FAILURE;
        ASSERT (RSU_ENTRY_SELECTED_TB = "00000000000000000000000000000000000000000000000000000000000000000001") REPORT "Instant 4 - Unexpected value of RSU_Entry_Selected" SEVERITY FAILURE;


        --                             Instant 5                             --
        -- Testing: All instructions ready;
        WAIT FOR 5 ns;
        ASSERT (RSU_ENTRY_INDEX_TB = "00") REPORT "Instant 5 - Unexpected value of RSU_Entry_Index" SEVERITY FAILURE;
        ASSERT (RSU_ENTRY_SELECTED_TB = "00000000000000000000000000000000000000000000000000000000000000000001") REPORT "Instant 5 - Unexpected value of RSU_Entry_Selected" SEVERITY FAILURE;


        WAIT FOR 5 ns;
        WAIT;
    END PROCESS Output_Process;
END ARCHITECTURE testbench;