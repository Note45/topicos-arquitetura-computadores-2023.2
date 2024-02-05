LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_RiscV_Processor IS
END ENTITY TB_RiscV_Processor;

ARCHITECTURE testbench OF TB_RiscV_Processor IS
    COMPONENT RiscV_Processor IS
        PORT(
            Clock               :  IN STD_LOGIC;
            Reset               :  IN STD_LOGIC;
    
            IO_0                :  IN UNSIGNED(31 DOWNTO 0);
            IO_1                :  IN UNSIGNED(31 DOWNTO 0);
            IO_2                :  IN UNSIGNED(31 DOWNTO 0);
            IO_3                :  IN UNSIGNED(31 DOWNTO 0);
    
            Instruction_0       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_1       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_2       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_3       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT RiscV_Processor;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';
    SIGNAL RESET_TB                             : STD_LOGIC                             := '0';

    SIGNAL IO_0_TB                              : UNSIGNED(31 DOWNTO 0)                 := "00000000000000000000000000000000";
    SIGNAL IO_1_TB                              : UNSIGNED(31 DOWNTO 0)                 := "00000000000000000000000000000000";
    SIGNAL IO_2_TB                              : UNSIGNED(31 DOWNTO 0)                 := "00000000000000000000000000000000";
    SIGNAL IO_3_TB                              : UNSIGNED(31 DOWNTO 0)                 := "00000000000000000000000000000000";

    SIGNAL INSTRUCTION_0_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_1_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_2_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";
    SIGNAL INSTRUCTION_3_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

BEGIN

    -- Controls the Clock signal
    Clock_Process : PROCESS
    BEGIN
        CLOCK_TB <= '0';
        WAIT FOR CLOCK_PERIOD/2;
        CLOCK_TB <= '1';
        CYCLE_COUNT <= CYCLE_COUNT + 1;
        WAIT FOR CLOCK_PERIOD/2;

        IF (CYCLE_COUNT = 7) THEN
            REPORT "END OF TESTBENCH" SEVERITY FAILURE;
        END IF;
    END PROCESS Clock_Process;


    -- DUT Instantiation
    RiscV : RiscV_Processor
    PORT MAP(
        Clock => CLOCK_TB,
        Reset => RESET_TB,

        IO_0 => IO_0_TB,
        IO_1 => IO_1_TB,
        IO_2 => IO_2_TB,
        IO_3 => IO_3_TB,

        Instruction_0 => INSTRUCTION_0_TB,
        Instruction_1 => INSTRUCTION_1_TB,
        Instruction_2 => INSTRUCTION_2_TB,
        Instruction_3 => INSTRUCTION_3_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN
        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN
        WAIT;
    END PROCESS Output_Process;

    
END ARCHITECTURE testbench;