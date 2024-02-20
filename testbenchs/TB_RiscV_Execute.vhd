LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_RiscV_Execute IS
END ENTITY TB_RiscV_Execute;

ARCHITECTURE testbench OF TB_RiscV_Execute IS
    COMPONENT RiscV_Execute IS
        PORT(
            Clock                           :  IN STD_LOGIC;
            Reset                           :  IN STD_LOGIC;
    
            FU_Identifier                   :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Integer_FU_Bus_Write_On_RRF     :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
            Multiplier_FU_Bus_Write_On_RRF  :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
            
            Instruction_0                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Funct7                   :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_0_Funct3                   :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_0_RRF_Dest                 :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Valid_S                  :  IN STD_LOGIC;
            Inst_0_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_1                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Funct7                   :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_1_Funct3                   :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_RRF_Dest                 :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Valid_S                  :  IN STD_LOGIC;
            Inst_1_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_2                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Funct7                   :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_2_Funct3                   :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_RRF_Dest                 :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Valid_S                  :  IN STD_LOGIC;
            Inst_2_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Valid_T                  :  IN STD_LOGIC;
    
            Instruction_3                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Funct7                   :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_3_Funct3                   :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_RRF_Dest                 :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_Side_S                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Valid_S                  :  IN STD_LOGIC;
            Inst_3_Side_T                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Valid_T                  :  IN STD_LOGIC;
    
            RSU_Buffer_State                : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);         -- RSU_BUSY(3) & RSU_BUSY(2) & RSU_BUSY(1) & RSU_BUSY(0)
            FU_Funct7                       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            FU_Funct3                       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            FU_Operand_S                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FU_Operand_T                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT RiscV_Execute;

    SIGNAL CLOCK_PERIOD                         : TIME                                  := 5 ns;
    SIGNAL CYCLE_COUNT                          : INTEGER                               := 0;
    SIGNAL CLOCK_TB                             : STD_LOGIC                             := '0';
    SIGNAL RESET_TB                             : STD_LOGIC                             := '0';

    SIGNAL FU_IDENTIFIER_TB                     : STD_LOGIC_VECTOR(1 DOWNTO 0)          := "00";
    SIGNAL INTEGER_FU_BUS_WRITE_ON_RRF_TB       : STD_LOGIC_VECTOR(37 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL MULTIPLIER_FU_BUS_WRITE_ON_RRF_TB    : STD_LOGIC_VECTOR(37 DOWNTO 0)         := (OTHERS => '0');
    
    SIGNAL INSTRUCTION_0_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_0_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_0_RRF_DEST_TB                   : STD_LOGIC_VECTOR(4 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_0_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_0_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_0_VALID_T_TB                    : STD_LOGIC                             := '0';
    
    SIGNAL INSTRUCTION_1_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_1_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_1_RRF_DEST_TB                   : STD_LOGIC_VECTOR(4 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_1_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_1_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_1_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL INSTRUCTION_2_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_2_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_2_RRF_DEST_TB                   : STD_LOGIC_VECTOR(4 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_2_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_2_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_2_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL INSTRUCTION_3_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_FUNCT7_TB                     : STD_LOGIC_VECTOR(6 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_3_FUNCT3_TB                     : STD_LOGIC_VECTOR(2 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_3_RRF_DEST_TB                   : STD_LOGIC_VECTOR(4 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL INST_3_SIDE_S_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_VALID_S_TB                    : STD_LOGIC                             := '0';
    SIGNAL INST_3_SIDE_T_TB                     : STD_LOGIC_VECTOR(31 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL INST_3_VALID_T_TB                    : STD_LOGIC                             := '0';

    SIGNAL RSU_BUFFER_STATE_TB                  : STD_LOGIC_VECTOR(3 DOWNTO 0)          := "0000";
    SIGNAL FU_FUNCT7_TB                         : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL FU_FUNCT3_TB                         : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL FU_RRF_DEST_TB                       : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
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
    Execute_Step: RiscV_Execute
    PORT MAP(
        Clock => CLOCK_TB,
        Reset => RESET_TB,

        FU_Identifier => FU_IDENTIFIER_TB,
        Integer_FU_Bus_Write_On_RRF => INTEGER_FU_BUS_WRITE_ON_RRF_TB,
        Multiplier_FU_Bus_Write_On_RRF => MULTIPLIER_FU_BUS_WRITE_ON_RRF_TB,

        Instruction_0 => INSTRUCTION_0_TB,
        Inst_0_Funct7 => INST_0_FUNCT7_TB,
        Inst_0_Funct3 => INST_0_FUNCT3_TB,
        Inst_0_RRF_Dest => INST_0_RRF_DEST_TB,
        Inst_0_Side_S => INST_0_SIDE_S_TB,
        Inst_0_Valid_S => INST_0_VALID_S_TB,
        Inst_0_Side_T => INST_0_SIDE_T_TB,
        Inst_0_Valid_T => INST_0_VALID_T_TB,
        
        Instruction_1 => INSTRUCTION_1_TB,
        Inst_1_Funct7 => INST_1_FUNCT7_TB,
        Inst_1_Funct3 => INST_1_FUNCT3_TB,
        Inst_1_RRF_Dest => INST_1_RRF_DEST_TB,
        Inst_1_Side_S => INST_1_SIDE_S_TB,
        Inst_1_Valid_S => INST_1_VALID_S_TB,
        Inst_1_Side_T => INST_1_SIDE_T_TB,
        Inst_1_Valid_T => INST_1_VALID_T_TB,

        Instruction_2 => INSTRUCTION_2_TB,
        Inst_2_Funct7 => INST_2_FUNCT7_TB,
        Inst_2_Funct3 => INST_2_FUNCT3_TB,
        Inst_2_RRF_Dest => INST_2_RRF_DEST_TB,
        Inst_2_Side_S => INST_2_SIDE_S_TB,
        Inst_2_Valid_S => INST_2_VALID_S_TB,
        Inst_2_Side_T => INST_2_SIDE_T_TB,
        Inst_2_Valid_T => INST_2_VALID_T_TB,

        Instruction_3 => INSTRUCTION_3_TB,
        Inst_3_Funct7 => INST_3_FUNCT7_TB,
        Inst_3_Funct3 => INST_3_FUNCT3_TB,
        Inst_3_RRF_Dest => INST_3_RRF_DEST_TB,
        Inst_3_Side_S => INST_3_SIDE_S_TB,
        Inst_3_Valid_S => INST_3_VALID_S_TB,
        Inst_3_Side_T => INST_3_SIDE_T_TB,
        Inst_3_Valid_T => INST_3_VALID_T_TB
    );


    -- Main testing process
    Stimulus_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        -- Arguments of Instruction_2: OR r5, x23, x23
        --  SIDE_S: value 1
        --  VALID_S: '1' (above is an register = invalid operand)
        --  SIDE_T: value 4
        --  VALID_T: '1' (above is an register = invalid operand)
        --
        -- Arguments of Instruction_3: OR r23, x1, x4
        --  SIDE_S: value 1
        --  VALID_S: '0' (above is an ARF_DATA = valid operand)
        --  SIDE_T: value 4
        --  VALID_T: '0' (above is an ARF_DATA = valid operand)
        INSTRUCTION_2_TB <= "00000001011110111111001000110011";
        INST_2_FUNCT7_TB <= "0000000";
        INST_2_FUNCT3_TB <= "110";
        INST_2_RRF_DEST_TB <= "00100";
        INST_2_SIDE_S_TB <= "00000000000000000000000000010111";
        INST_2_VALID_S_TB <= '1';
        INST_2_SIDE_T_TB <= "00000000000000000000000000010111";
        INST_2_VALID_T_TB <= '1';

        INSTRUCTION_3_TB <= "00000000010000001111101110110011";
        INST_3_FUNCT7_TB <= "0000000";
        INST_3_FUNCT3_TB <= "110";
        INST_3_RRF_DEST_TB <= "10111";
        INST_3_SIDE_S_TB <= "00000000000000000000000000000111";
        INST_3_VALID_S_TB <= '0';
        INST_3_SIDE_T_TB <= "00000000000000000000000000011000";
        INST_3_VALID_T_TB <= '0';
        WAIT FOR 5 ns;

        INSTRUCTION_2_TB <= "00000000000000000000000000000000";
        INSTRUCTION_3_TB <= "00000000000000000000000000000000";
        WAIT FOR 5 ns;

        WAIT FOR 5 ns;
        WAIT;
    END PROCESS;


    -- Test verification process
    Output_Process : PROCESS
    BEGIN

        --                             Cycle 1                             --
        --                            0 to 5 ns
        WAIT FOR 5 ns;

        WAIT FOR 5 ns;

        WAIT FOR 5 ns;
        WAIT;
    END PROCESS;
END ARCHITECTURE testbench;