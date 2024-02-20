LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RiscV_Execute IS
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
--Multiplier_FU_Bus_Write_On_RRF  :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
--        Integer_FU_Bus_Write_On_RRF     :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
    );
END ENTITY RiscV_Execute;

ARCHITECTURE behavior OF RiscV_Execute IS

    COMPONENT ReservationStationUnit IS
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
            FU_RRF_Dest                     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            FU_Operand_S                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FU_Operand_T                    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit;

    SIGNAL INT_IDENTIFIER                   : STD_LOGIC_VECTOR(1 DOWNTO 0)          := "00";
    SIGNAL INT_RESULT_FU_BUS_WRITE_ON_RRF      : STD_LOGIC_VECTOR(37 DOWNTO 0)         := "00000000000000000000000000000000000000";
    SIGNAL RSU_MULTIPLIER_FU_BUS_WRITE_ON_RRF   : STD_LOGIC_VECTOR(37 DOWNTO 0)     := "00000000000000000000000000000000000000";
    SIGNAL INT_BUFFER_STATE                     : STD_LOGIC_VECTOR(3 DOWNTO 0)      := "0000";
    SIGNAL INT_FU_FUNCT7                        : STD_LOGIC_VECTOR(6 DOWNTO 0)      := "0000000";
    SIGNAL INT_FU_FUNCT3                        : STD_LOGIC_VECTOR(2 DOWNTO 0)      := "000";
    SIGNAL INT_FU_RRF_DEST                      : STD_LOGIC_VECTOR(4 DOWNTO 0)      := "00000";
    SIGNAL INT_FU_OPERAND_S                     : STD_LOGIC_VECTOR(31 DOWNTO 0)     := "00000000000000000000000000000000";
    SIGNAL INT_FU_OPERAND_T                     : STD_LOGIC_VECTOR(31 DOWNTO 0)     := "00000000000000000000000000000000";

    COMPONENT FunctionalUnit_Integer IS
        PORT(
            Identifier                  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);             -- Specifies this type of Functional Unit
    
            Funct7                      :  IN STD_LOGIC_VECTOR(6 DOWNTO 0);             -- Specifies the instruction
            Funct3                      :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);             -- Specifies the instruction
            RRF_Dest                    :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);             -- Specifies the destination register on RRF
    
            Operand_A                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the first value of the operation
            Operand_B                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);            -- Specifies the second value of the operation
    
            Result_Bus_Write_On_RRF     : OUT STD_LOGIC_VECTOR(37 DOWNTO 0)             -- VALID_SIGNAL(37) & RRF_DEST(36 DOWNTO 32) & RESULT(31 DOWNTO 0)
        );
    END COMPONENT FunctionalUnit_Integer;

--    SIGNAL INT_RESULT_FU_BUS_WRITE_ON_RRF      : STD_LOGIC_VECTOR(37 DOWNTO 0)         := "00000000000000000000000000000000000000";

BEGIN

    -- RSU instantiation
    Integer_RSU : ReservationStationUnit PORT MAP(
        Clock => Clock,
        Reset => Reset,

        FU_Identifier => INT_IDENTIFIER,
        Integer_FU_Bus_Write_On_RRF => INT_RESULT_FU_BUS_WRITE_ON_RRF,
        Multiplier_FU_Bus_Write_On_RRF => RSU_MULTIPLIER_FU_BUS_WRITE_ON_RRF,

        Instruction_0 => Instruction_0,
        Inst_0_Funct7 => Inst_0_Funct7,
        Inst_0_Funct3 => Inst_0_Funct3,
        Inst_0_RRF_Dest => Inst_0_RRF_Dest,
        Inst_0_Side_S => Inst_0_Side_S,
        Inst_0_Valid_S => Inst_0_Valid_S,
        Inst_0_Side_T => Inst_0_Side_T,
        Inst_0_Valid_T => Inst_0_Valid_T,
        
        Instruction_1 => Instruction_1,
        Inst_1_Funct7 => Inst_1_Funct7,
        Inst_1_Funct3 => Inst_1_Funct3,
        Inst_1_RRF_Dest => Inst_1_RRF_Dest,
        Inst_1_Side_S => Inst_1_Side_S,
        Inst_1_Valid_S => Inst_1_Valid_S,
        Inst_1_Side_T => Inst_1_Side_T,
        Inst_1_Valid_T => Inst_1_Valid_T,

        Instruction_2 => Instruction_2,
        Inst_2_Funct7 => Inst_2_Funct7,
        Inst_2_Funct3 => Inst_2_Funct3,
        Inst_2_RRF_Dest => Inst_2_RRF_Dest,
        Inst_2_Side_S => Inst_2_Side_S,
        Inst_2_Valid_S => Inst_2_Valid_S,
        Inst_2_Side_T => Inst_2_Side_T,
        Inst_2_Valid_T => Inst_2_Valid_T,

        Instruction_3 => Instruction_3,
        Inst_3_Funct7 => Inst_3_Funct7,
        Inst_3_Funct3 => Inst_3_Funct3,
        Inst_3_RRF_Dest => Inst_3_RRF_Dest,
        Inst_3_Side_S => Inst_3_Side_S,
        Inst_3_Valid_S => Inst_3_Valid_S,
        Inst_3_Side_T => Inst_3_Side_T,
        Inst_3_Valid_T => Inst_3_Valid_T,

        RSU_Buffer_State => INT_BUFFER_STATE,
        FU_Funct7 => INT_FU_Funct7,
        FU_Funct3 => INT_FU_Funct3,
        FU_RRF_Dest => INT_FU_RRF_DEST,
        FU_Operand_S => INT_FU_OPERAND_S,
        FU_Operand_T => INT_FU_OPERAND_T
    );


    -- Integer Functional Unit instantiation
    Integer_FU : FunctionalUnit_Integer PORT MAP(
        Identifier => INT_IDENTIFIER,

        Funct7 => INT_FU_FUNCT7,
        Funct3 => INT_FU_FUNCT3,
        RRF_Dest => INT_FU_RRF_DEST,

        Operand_A => INT_FU_OPERAND_S,
        Operand_B => INT_FU_OPERAND_T,

        Result_Bus_Write_On_RRF => INT_RESULT_FU_BUS_WRITE_ON_RRF
    );


END ARCHITECTURE behavior;