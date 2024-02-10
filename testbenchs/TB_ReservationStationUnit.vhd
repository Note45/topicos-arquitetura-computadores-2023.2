LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_ReservationStationUnit IS
END ENTITY TB_ReservationStationUnit;

ARCHITECTURE testbench OF TB_ReservationStationUnit IS
    COMPONENT ReservationStationUnit IS
        PORT(
            Clock                           :  IN STD_LOGIC;
            Reset                           :  IN STD_LOGIC;
    
            Functional_Unit_Busy            :  IN STD_LOGIC;                            -- Specifies if the FU associated is available; '0' if true
    
            Integer_FU_Bus_Write_On_RRF     :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
            Multiplier_FU_Bus_Write_On_RRF  :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
            
            Instruction_0                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Valid_S                  :  IN STD_LOGIC;
            Inst_0_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_1                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Valid_S                  :  IN STD_LOGIC;
            Inst_1_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_2                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Valid_S                  :  IN STD_LOGIC;
            Inst_2_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_3                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Valid_S                  :  IN STD_LOGIC;
            Inst_3_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Valid_T                  :  IN STD_LOGIC;
    
            RSU_Buffer_State                : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);         -- RSU_BUSY(3) & RSU_BUSY(2) & RSU_BUSY(1) & RSU_BUSY(0)
            FU_Operand_S                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FU_Operand_T                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';
    SIGNAL RESET_TB                             : STD_LOGIC                             := '0';

    SIGNAL FUNCTIONAL_UNIT_BUSY_TB              : STD_LOGIC                             := '0';

    SIGNAL INTEGER_FU_BUS_WRITE_ON_RRF_TB       : STD_LOGIC_VECTOR(37 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL MULTIPLIER_FU_BUS_WRITE_ON_RRF_TB    : STD_LOGIC_VECTOR(37 DOWNTO 0)         := (OTHERS => '0');
    
    SIGNAL INSTRUCTION_0_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_0_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_VALID_T_TB                    : STD_LOGIC                             := '0';
    
    SIGNAL INSTRUCTION_1_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_1_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL INSTRUCTION_2_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_2_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL INSTRUCTION_3_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_3_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL RSU_BUFFER_STATE_TB                  : STD_LOGIC_VECTOR(3 DOWNTO 0)          := "0000";
    SIGNAL FU_OPERAND_S_TB                      : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL FU_OPERAND_T_TB                      : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');

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
    END PROCESS;


    -- DUT Instantiation
    RSU : ReservationStationUnit
    PORT MAP(
        Clock => CLOCK_TB,
        Reset => RESET_TB,

        Functional_Unit_Busy => FUNCTIONAL_UNIT_BUSY_TB,

        Integer_FU_Bus_Write_On_RRF => INTEGER_FU_BUS_WRITE_ON_RRF_TB,
        Multiplier_FU_Bus_Write_On_RRF => MULTIPLIER_FU_BUS_WRITE_ON_RRF_TB,

        Instruction_0 => INSTRUCTION_0_TB,
        Inst_0_Side_S => INST_0_SIDE_S_TB,
        Inst_0_Valid_S => INST_0_VALID_S_TB,
        Inst_0_Side_T => INST_0_SIDE_T_TB,
        Inst_0_Valid_T => INST_0_VALID_T_TB,
        
        Instruction_1 => INSTRUCTION_1_TB,
        Inst_1_Side_S => INST_1_SIDE_S_TB,
        Inst_1_Valid_S => INST_1_VALID_S_TB,
        Inst_1_Side_T => INST_1_SIDE_T_TB,
        Inst_1_Valid_T => INST_1_VALID_T_TB,

        Instruction_2 => INSTRUCTION_2_TB,
        Inst_2_Side_S => INST_2_SIDE_S_TB,
        Inst_2_Valid_S => INST_2_VALID_S_TB,
        Inst_2_Side_T => INST_2_SIDE_T_TB,
        Inst_2_Valid_T => INST_2_VALID_T_TB,

        Instruction_3 => INSTRUCTION_3_TB,
        Inst_3_Side_S => INST_3_SIDE_S_TB,
        Inst_3_Valid_S => INST_3_VALID_S_TB,
        Inst_3_Side_T => INST_3_SIDE_T_TB,
        Inst_3_Valid_T => INST_3_VALID_T_TB,

        RSU_Buffer_State => RSU_BUFFER_STATE_TB,
        FU_Operand_S => FU_OPERAND_S_TB,
        FU_Operand_T => FU_OPERAND_T_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        -- Testing: Multiple instructions arriving at same cycle;
        -- Testing: Instruction with no operands (Inst_2);
        -- Testing: Instruction with both operands (Inst_3);
        --
        -- Arguments of Instruction_2: AND r23, x1, x4
        --  SIDE_S: value 1
        --  VALID_S: '1' (above is a RRF_TAG to RRF(1) = invalid operand)
        --  SIDE_T: value 4
        --  VALID_T: '1' (above is a RRF_TAG to RRF(4) = invalid operand)
        --
        -- Arguments of Instruction_3: SUB x15, x3, x5
        --  SIDE_S: value 26
        --  VALID_S: '0' (above is an ARF_DATA = valid operand)
        --  SIDE_T: value 31
        --  VALID_T: '0' (above is an ARF_DATA = valid operand)
        INSTRUCTION_2_TB <= "00000000010000001111101110110011";
        INST_2_SIDE_S_TB <= "00000000000000000000000000000001";
        INST_2_VALID_S_TB <= '1';
        INST_2_SIDE_T_TB <= "00000000000000000000000000000100";
        INST_2_VALID_T_TB <= '1';

        INSTRUCTION_3_TB <= "01000000010100011000011110110011";
        INST_3_SIDE_S_TB <= "00000000000000000000000000011010";
        INST_3_VALID_S_TB <= '0';
        INST_3_SIDE_T_TB <= "00000000000000000000000000011111";
        INST_3_VALID_T_TB <= '0';
        WAIT FOR 5 ns;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        -- Testing: Updating operands of an entry with data coming from Functional Units;
        --
        -- Arguments of Instruction_0: OR x28, x7, x0
        --  SIDE_S: value 341
        --  VALID_S: '0' (above is an ARF_DATA = valid operand)
        --  SIDE_T: value 0
        --  VALID_T: '1' (above is a RRF_TAG to RRF(0) = invalid operand)
        --
        -- Updating every entry on RSU that has, as operands:
        --   RRF(1) = 00000000000000000000000000010001 = value 17
        --   RRF(4) = 00000000000000000000000000010100 = value 20
        INTEGER_FU_BUS_WRITE_ON_RRF_TB <= "10000100000000000000000000000000010001";
        MULTIPLIER_FU_BUS_WRITE_ON_RRF_TB <= "10010000000000000000000000000000010100";

        INSTRUCTION_0_TB <= "00000000000000111110111001111110";
        INST_0_SIDE_S_TB <= "00000000000000000000000101010101";
        INST_0_VALID_S_TB <= '0';
        INST_0_SIDE_T_TB <= "00000000000000000000000000000000";
        INST_0_VALID_T_TB <= '1';

        INSTRUCTION_2_TB <= "00000000000000000000000000000000";
        INSTRUCTION_3_TB <= "00000000000000000000000000000000";
        WAIT FOR 5 ns;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        -- Testing: Issuing of Instruction_3 from Cycle 1;
        --
        -- Arguments of Instruction_1: SLT x12, x10, x11
        --  SIDE_S: value -1
        --  VALID_S: '0' (above is an ARF_DATA = valid operand)
        --  SIDE_T: value -1
        --  VALID_T: '0' (above is an ARF_DATA = valid operand)
        --
        -- Updating every entry on RSU that has, as operands:
        --   RRF(0) = 00000000000000000000000000100101 = value 37
        INTEGER_FU_BUS_WRITE_ON_RRF_TB <= "10000000000000000000000000000000100101";

        INSTRUCTION_1_TB <= "00000000101101010010011000110011";
        INST_1_SIDE_S_TB <= "11111111111111111111111111111111";
        INST_1_VALID_S_TB <= '0';
        INST_1_SIDE_T_TB <= "11111111111111111111111111111111";
        INST_1_VALID_T_TB <= '0';

        INSTRUCTION_0_TB <= "00000000000000000000000000000000";
        WAIT FOR 2.6 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '1';
        WAIT FOR 2.4 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '0';


        --                             Cycle 4                             --
        --                           15 to 20 ns
        -- Testing: Issuing of Instruction_2 from Cycle 1;
        INSTRUCTION_1_TB <= "00000000000000000000000000000000";
        WAIT FOR 2.6 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '1';
        WAIT FOR 2.4 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '0';


        --                             Cycle 5                             --
        --                           20 to 25 ns
        -- Testing: Multiple instructions on RSU ready to issue (Inst_2 from Cycle 2 and Inst_1 from Cycle 1);
        -- Testing: Issuing of the first instruction ready on the RSU (LSB to MSB) 
        -- Testing: Issuing of Instruction_0 from Cycle 2;
        WAIT FOR 2.6 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '1';
        WAIT FOR 2.4 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '0';


        --                             Cycle 6                            --
        --                           25 to 30 ns
        -- Testing: Issuing of Instruction_1 from Cycle 3;
        WAIT FOR 2.6 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '1';
        WAIT FOR 2.4 ns;
        FUNCTIONAL_UNIT_BUSY_TB <= '0';


        WAIT;
    END PROCESS Stimulus_Process;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 1)                                        REPORT "Cycle 1 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "00000000000000000000000000000000")   REPORT "Cycle 1 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "00000000000000000000000000000000")   REPORT "Cycle 1 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 1)                                       REPORT "Cycle 1 - Finishing tests"                          SEVERITY NOTE;


        --                             Cycle 2                             --
        --                            5 to 10 ns
        WAIT FOR 5 ns;
        ASSERT (CYCLE_COUNT = 2)                                        REPORT "Cycle 2 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "00000000000000000000000000000000")   REPORT "Cycle 2 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "00000000000000000000000000000000")   REPORT "Cycle 2 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 2)                                       REPORT "Cycle 2 - Finishing tests"                          SEVERITY NOTE;


        --                             Cycle 3                             --
        --                           10 to 15 ns
        -- Testing: Issuing of Instruction_3 from Cycle 1;
        WAIT FOR 2.6 ns;
        ASSERT (CYCLE_COUNT = 3)                                        REPORT "Cycle 3 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "00000000000000000000000000011010")   REPORT "Cycle 3 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "00000000000000000000000000011111")   REPORT "Cycle 3 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 3)                                       REPORT "Cycle 3 - Finishing tests"                          SEVERITY NOTE;
        WAIT FOR 2.4 ns;


        --                             Cycle 4                             --
        --                           15 to 20 ns
        -- Testing: Issuing of Instruction_2 from Cycle 1;
        WAIT FOR 2.6 ns;
        ASSERT (CYCLE_COUNT = 4)                                        REPORT "Cycle 4 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "00000000000000000000000000010001")   REPORT "Cycle 4 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "00000000000000000000000000010100")   REPORT "Cycle 4 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 4)                                       REPORT "Cycle 4 - Finishing tests"                          SEVERITY NOTE;
        WAIT FOR 2.4 ns;


        --                             Cycle 5                             --
        --                           20 to 25 ns
        -- Testing: Multiple instructions on RSU ready to issue (Inst_2 from Cycle 2 and Inst_1 from Cycle 1);
        -- Testing: Issuing of the first instruction ready on the RSU (LSB to MSB) 
        -- Testing: Issuing of Instruction_0 from Cycle 2;
        WAIT FOR 2.6 ns;
        ASSERT (CYCLE_COUNT = 5)                                        REPORT "Cycle 5 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "00000000000000000000000101010101")   REPORT "Cycle 5 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "00000000000000000000000000100101")   REPORT "Cycle 5 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 5)                                       REPORT "Cycle 5 - Finishing tests"                          SEVERITY NOTE;
        WAIT FOR 2.4 ns;


        --                             Cycle 6                             --
        --                           25 to 30 ns
        -- Testing: Issuing of Instruction_1 from Cycle 3;
        WAIT FOR 2.6 ns;
        ASSERT (CYCLE_COUNT = 6)                                        REPORT "Cycle 6 - Unexpected value on Cycle_Count"          SEVERITY FAILURE;

        ASSERT (FU_OPERAND_S_TB = "11111111111111111111111111111111")   REPORT "Cycle 6 - Unexpected value on FU_OPERAND_S_TB"      SEVERITY FAILURE;
        ASSERT (FU_OPERAND_T_TB = "11111111111111111111111111111111")   REPORT "Cycle 6 - Unexpected value on FU_OPERAND_T_TB"      SEVERITY FAILURE;

        ASSERT (CYCLE_COUNT /= 6)                                       REPORT "Cycle 6 - Finishing tests"                          SEVERITY NOTE;
        WAIT FOR 2.4 ns;


        WAIT;
    END PROCESS Output_Process;
END ARCHITECTURE testbench;