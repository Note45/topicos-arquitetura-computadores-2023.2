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
    
            FU_Operand_S                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FU_Operand_T                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 1 ns;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';
    SIGNAL RESET_TB                             : STD_LOGIC                             := '0';

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

    SIGNAL FU_OPERAND_S_TB                      : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL FU_OPERAND_T_TB                      : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');

BEGIN

    -- Controls the Clock signal
    Clock_Process : PROCESS
    BEGIN
        WAIT FOR CLOCK_PERIOD;
        CLOCK_TB <= NOT CLOCK_TB;
        ASSERT NOW < 10 ns REPORT "Fim" SEVERITY FAILURE;
    END PROCESS;


    -- DUT Instantiation
    RSU : ReservationStationUnit
    PORT MAP(
        Clock => CLOCK_TB,
        Reset => RESET_TB,

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

        FU_Operand_S => FU_OPERAND_S_TB,
        FU_Operand_T => FU_OPERAND_T_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Test 1                             --
        -- Two instructions arriving at same cycle;
        -- Inst_2 has none of the operands; Inst_3 has all of the operands;
        --
        -- Arguments of Instruction_2:
        --  SIDE_S:  value 1
        --  VALID_S: '1' (above is a RRF_TAG to RRF(1) = invalid operand)
        --  SIDE_T: value 4
        --  VALID_T: '1' (above is a RRF_TAG to RRF(4) = invalid operand)
        --
        -- Arguments of Instruction_3:
        --  SIDE_S:  value 26
        --  VALID_S: '0' (above is an ARF_DATA = valid operand)
        --  SIDE_T: value 4
        --  VALID_T: '0' (above is an ARF_DATA = valid operand)
        INSTRUCTION_2_TB <= "11111111111111111111111111111111";
        INST_2_SIDE_S_TB <= "00000000000000000000000000000001";
        INST_2_VALID_S_TB <= '1';
        INST_2_SIDE_T_TB <= "00000000000000000000000000000100";
        INST_2_VALID_T_TB <= '1';

        INSTRUCTION_3_TB <= "11111111111111111111111111111111";
        INST_3_SIDE_S_TB <= "00000000000000000000000000011010";
        INST_3_VALID_S_TB <= '0';
        INST_3_SIDE_T_TB <= "00000000000000000000000000011111";
        INST_3_VALID_T_TB <= '0';
        WAIT FOR 1 ns;

        WAIT FOR 1 ns;

        WAIT FOR 1 ns;

        WAIT FOR 1 ns;

        WAIT FOR 1 ns;

        WAIT FOR 1 ns;

        -- Issuing of Test_1_Inst_3
        ASSERT FU_OPERAND_S_TB = "00000000000000000000000000011010" REPORT "Test 1 - Unexpected value on FU_OPERAND_S_TB" SEVERITY FAILURE;
        ASSERT FU_OPERAND_T_TB = "00000000000000000000000000011111" REPORT "Test 1 - Unexpected value on FU_OPERAND_T_TB" SEVERITY FAILURE;

        WAIT;
    END PROCESS;
END ARCHITECTURE testbench;