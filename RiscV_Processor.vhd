LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RiscV_Processor IS
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
        Instruction_3       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        
        Placeholder         : OUT STD_LOGIC
    );
END ENTITY RiscV_Processor;

ARCHITECTURE processor OF RiscV_Processor IS
    COMPONENT DecoderUnit
        PORT(
            Clock               :  IN STD_LOGIC;
            Instruction_0_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_1_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_2_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_3_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_0_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
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

    SIGNAL INST_0_OUT, INST_1_OUT, INST_2_OUT, INST_3_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_CONTROL, INST_1_CONTROL, INST_2_CONTROL, INST_3_CONTROL : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_FUNCT7, INST_1_FUNCT7, INST_2_FUNCT7, INST_3_FUNCT7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_FUNCT3, INST_1_FUNCT3, INST_2_FUNCT3, INST_3_FUNCT3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RD, INST_1_RD, INST_2_RD, INST_3_RD : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RS1, INST_1_RS1, INST_2_RS1, INST_3_RS1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RS2, INST_1_RS2, INST_2_RS2, INST_3_RS2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_IMM, INST_1_IMM, INST_2_IMM, INST_3_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');


    COMPONENT RegisterRenameUnit
        GENERIC (
            Size_RRF : integer := 5                 -- RRF possui (2**Size_RRF) entradas
        );

        PORT (
            Clock                   :  IN STD_LOGIC;
            Reset                   :  IN STD_LOGIC;

            Bus_Write_On_RRF        :  IN STD_LOGIC_VECTOR(((Size_RRF + 32) - 1) DOWNTO 0);
            
            IO_0                    :  IN UNSIGNED(31 DOWNTO 0);
            Instruction_0           :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Control          :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_0_RD               :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS1              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS2              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_Read_On_RRF      :  IN STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0);

            IO_1                    :  IN UNSIGNED(31 DOWNTO 0);
            Instruction_1           :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Control          :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_RD               :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS1              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS2              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_Read_On_RRF      :  IN STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0);
    
            IO_2                    :  IN UNSIGNED(31 DOWNTO 0);
            Instruction_2           :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Control          :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_RD               :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS1              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS2              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_Read_On_RRF      :  IN STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0);
    
            IO_3                    :  IN UNSIGNED(31 DOWNTO 0);
            Instruction_3           :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Control          :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_RD               :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS1              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS2              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_Read_On_RRF      :  IN STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0);

            Inst_0_RRF_Dest         : OUT STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0);
            Inst_0_Side_S           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_0_Valid_S          : OUT STD_LOGIC;
            Inst_0_Data_From_RRF_S  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);
            Inst_0_Side_T           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_0_Valid_T          : OUT STD_LOGIC;
            Inst_0_Data_From_RRF_T  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);
    
            Inst_1_RRF_Dest         : OUT STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0);
            Inst_1_Side_S           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_1_Valid_S          : OUT STD_LOGIC;
            Inst_1_Data_From_RRF_S  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);
            Inst_1_Side_T           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_1_Valid_T          : OUT STD_LOGIC;
            Inst_1_Data_From_RRF_T  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);

            Inst_2_RRF_Dest         : OUT STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0);
            Inst_2_Side_S           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_2_Valid_S          : OUT STD_LOGIC;
            Inst_2_Data_From_RRF_S  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);
            Inst_2_Side_T           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_2_Valid_T          : OUT STD_LOGIC;
            Inst_2_Data_From_RRF_T  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);

            Inst_3_RRF_Dest         : OUT STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0);
            Inst_3_Side_S           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_3_Valid_S          : OUT STD_LOGIC;
            Inst_3_Data_From_RRF_S  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);
            Inst_3_Side_T           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);
            Inst_3_Valid_T          : OUT STD_LOGIC;
            Inst_3_Data_From_RRF_T  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit;

    CONSTANT SIZE_RRF : INTEGER := 5;
    SIGNAL BUS_WRITE_ON_RRF : STD_LOGIC_VECTOR(((Size_RRF + 32) - 1) DOWNTO 0) := (OTHERS => '0');

    SIGNAL INST_0_SIDE_S, INST_1_SIDE_S, INST_2_SIDE_S, INST_3_SIDE_S : STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_VALID_S, INST_1_VALID_S, INST_2_VALID_S, INST_3_VALID_S : STD_LOGIC := '0';
    SIGNAL INST_0_DATA_FROM_RRF_S, INST_1_DATA_FROM_RRF_S, INST_2_DATA_FROM_RRF_S, INST_3_DATA_FROM_RRF_S : STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0) := (OTHERS => '0');

    SIGNAL INST_0_SIDE_T, INST_1_SIDE_T, INST_2_SIDE_T, INST_3_SIDE_T : STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_VALID_T, INST_1_VALID_T, INST_2_VALID_T, INST_3_VALID_T : STD_LOGIC := '0';
    SIGNAL INST_0_DATA_FROM_RRF_T, INST_1_DATA_FROM_RRF_T, INST_2_DATA_FROM_RRF_T, INST_3_DATA_FROM_RRF_T : STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0) := (OTHERS => '0');

    SIGNAL INST_0_READ_ON_RRF, INST_1_READ_ON_RRF, INST_2_READ_ON_RRF, INST_3_READ_ON_RRF : STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RRF_DEST, INST_1_RRF_DEST, INST_2_RRF_DEST, INST_3_RRF_DEST : STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0) := (OTHERS => '0');

BEGIN

    Decoder : DecoderUnit
    PORT MAP(
        Clock => Clock, 
        Instruction_0_In => Instruction_0, Instruction_1_In => Instruction_1,
        Instruction_2_In => Instruction_2, Instruction_3_In => Instruction_3,

        Instruction_0_Out => INST_0_OUT,
        Inst_0_Control => INST_0_CONTROL, Inst_0_Funct7 => INST_0_FUNCT7, Inst_0_Funct3 => INST_0_FUNCT3,
        Inst_0_RD => INST_0_RD, Inst_0_RS1 => INST_0_RS1, Inst_0_RS2 => INST_0_RS2, Inst_0_Imm => INST_0_IMM,

        Instruction_1_Out => INST_1_OUT,
        Inst_1_Control => INST_1_CONTROL, Inst_1_Funct7 => INST_1_FUNCT7, Inst_1_Funct3 => INST_1_FUNCT3,
        Inst_1_RD => INST_1_RD, Inst_1_RS1 => INST_1_RS1, Inst_1_RS2 => INST_1_RS2, Inst_1_Imm => INST_1_IMM,

        Instruction_2_Out => INST_2_OUT,
        Inst_2_Control => INST_2_CONTROL, Inst_2_Funct7 => INST_2_FUNCT7, Inst_2_Funct3 => INST_2_FUNCT3,
        Inst_2_RD => INST_2_RD, Inst_2_RS1 => INST_2_RS1, Inst_2_RS2 => INST_2_RS2, Inst_2_Imm => INST_2_IMM,
        
        Instruction_3_Out => INST_3_OUT,
        Inst_3_Control => INST_3_CONTROL, Inst_3_Funct7 => INST_3_FUNCT7, Inst_3_Funct3 => INST_3_FUNCT3,
        Inst_3_RD => INST_3_RD, Inst_3_RS1 => INST_3_RS1, Inst_3_RS2 => INST_3_RS2, Inst_3_Imm => INST_3_IMM
    );



--                                _/ Inst_0_Read_On_RRF
--                               |
--                               v                          ...
--                        ------------------------------------------------------------------
--                        |                   Register Rename Unit (RRU)                   |
--                        |                                                              /=|----> Inst_0_RRF_Dest
--                        |                                                             /  |
--                        |            v======================================v        /===|----> Inst_0_Side_S
--         Inst_0_RD ---->|========> -----                                  -----     /====|----> Inst_0_Valid_S
--        Inst_0_RS1 ---->|========> |ARF|                                  |RRF| ===>|====|----> Inst_0_Data_From_RRF_S
--        Inst_0_RS2 ---->|========> -----                ================> -----     \    |
--                        |                              /                    ^        \===|----> Inst_0_Side_T
--                        |                              |    ~~~~~~~~~~~~~~  |         \==|----> Inst_0_Valid_T
--                        |                              |    ||Tag_Finder||<=/         \=|----> Inst_0_Data_From_RRF_T
--            ...         |                              |    ~~~~~~~~~~~~~~               |           ...
--                        |                              |                                 |
--                        ------------------------------------------------------------------
--                                                       ^
--                                                       |
--                                              Commit_Reorder_Buffer
    RRU : RegisterRenameUnit
    GENERIC MAP(
        Size_RRF => SIZE_RRF
    )
    PORT MAP(
        Clock => Clock,
        Reset => Reset,

        Bus_Write_On_RRF => BUS_WRITE_ON_RRF,

        IO_0 => IO_0, Instruction_0 => Instruction_0, Inst_0_Control => INST_0_CONTROL,
        Inst_0_RD => INST_0_RD, Inst_0_RS1 => INST_0_RS1, Inst_0_RS2 => INST_0_RS2,
        Inst_0_Read_On_RRF => INST_0_READ_ON_RRF,

        IO_1 => IO_1, Instruction_1 => Instruction_1, Inst_1_Control => INST_1_CONTROL,
        Inst_1_RD => INST_1_RD, Inst_1_RS1 => INST_1_RS1, Inst_1_RS2 => INST_1_RS2,
        Inst_1_Read_On_RRF => INST_1_READ_ON_RRF,

        IO_2 => IO_2, Instruction_2 => Instruction_2, Inst_2_Control => INST_2_CONTROL,
        Inst_2_RD => INST_2_RD, Inst_2_RS1 => INST_2_RS1, Inst_2_RS2 => INST_2_RS2,
        Inst_2_Read_On_RRF => INST_2_READ_ON_RRF,

        IO_3 => IO_3, Instruction_3 => Instruction_3, Inst_3_Control => INST_3_CONTROL,
        Inst_3_RD => INST_3_RD, Inst_3_RS1 => INST_3_RS1, Inst_3_RS2 => INST_3_RS2,
        Inst_3_Read_On_RRF => INST_3_READ_ON_RRF,

        Inst_0_RRF_Dest => INST_0_RRF_DEST,
        Inst_0_Side_S => INST_0_SIDE_S, Inst_0_Valid_S => INST_0_VALID_S, Inst_0_Data_From_RRF_S => INST_0_DATA_FROM_RRF_S,
        Inst_0_Side_T => INST_0_SIDE_T, Inst_0_Valid_T => INST_0_VALID_T, Inst_0_Data_From_RRF_T => INST_0_DATA_FROM_RRF_T,

        Inst_1_RRF_Dest => INST_1_RRF_DEST,
        Inst_1_Side_S => INST_1_SIDE_S, Inst_1_Valid_S => INST_1_VALID_S, Inst_1_Data_From_RRF_S => INST_1_DATA_FROM_RRF_S,
        Inst_1_Side_T => INST_1_SIDE_T, Inst_1_Valid_T => INST_1_VALID_T, Inst_1_Data_From_RRF_T => INST_1_DATA_FROM_RRF_T,

        Inst_2_RRF_Dest => INST_2_RRF_DEST,
        Inst_2_Side_S => INST_2_SIDE_S, Inst_2_Valid_S => INST_2_VALID_S, Inst_2_Data_From_RRF_S => INST_2_DATA_FROM_RRF_S,
        Inst_2_Side_T => INST_2_SIDE_T, Inst_2_Valid_T => INST_2_VALID_T, Inst_2_Data_From_RRF_T => INST_2_DATA_FROM_RRF_T,

        Inst_3_RRF_Dest => INST_3_RRF_DEST,
        Inst_3_Side_S => INST_3_SIDE_S, Inst_3_Valid_S => INST_3_VALID_S, Inst_3_Data_From_RRF_S => INST_3_DATA_FROM_RRF_S,
        Inst_3_Side_T => INST_3_SIDE_T, Inst_3_Valid_T => INST_3_VALID_T, Inst_3_Data_From_RRF_T => INST_3_DATA_FROM_RRF_T
    );




    Placeholder <= '1';

END ARCHITECTURE processor;