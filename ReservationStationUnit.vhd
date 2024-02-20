LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ReservationStationUnit IS
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
END ENTITY ReservationStationUnit;

ARCHITECTURE behavior OF ReservationStationUnit IS

    TYPE BANK_INST IS ARRAY(0 TO 3) OF STD_LOGIC_VECTOR(82 DOWNTO 0); -- RSU_BUSY(82) & RSU_FUNCT7(81 DOWNTO 75) & RSU_FUNCT3(74 DOWNTO 72) & RSU_OPERAND_DEST(71 DOWNTO 67) & RSU_OPERAND_1(66 DOWNTO 35) & RSU_OPERAND_1_VALID(34) & RSU_OPERAND_2(33 DOWNTO 2) & RSU_OPERAND_2_VALID(1) & RSU_READY(0)
    SIGNAL RSU : BANK_INST := (OTHERS => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000");

    SIGNAL FunctionalUnit_F7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL FunctionalUnit_F3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL FunctionalUnit_Dest : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
    SIGNAL FunctionalUnit_S : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL FunctionalUnit_T : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";



    COMPONENT ReservationStationUnit_EntryFinder IS
        PORT(
            Busy_Vector         :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            Inst_0_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit_EntryFinder;

    SIGNAL Busy_RSU     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Entry_0_RSU  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Entry_1_RSU  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Entry_2_RSU  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Entry_3_RSU  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";



    COMPONENT ReservationStationUnit_IssueSelector IS
        PORT(
            Ready_Vector            :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            RSU_Entry_0             :  IN STD_LOGIC_VECTOR(82 DOWNTO 0);
            RSU_Entry_1             :  IN STD_LOGIC_VECTOR(82 DOWNTO 0);
            RSU_Entry_2             :  IN STD_LOGIC_VECTOR(82 DOWNTO 0);
            RSU_Entry_3             :  IN STD_LOGIC_VECTOR(82 DOWNTO 0);

            RSU_Entry_Index         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RSU_Entry_Selected      : OUT STD_LOGIC_VECTOR(82 DOWNTO 0)
        );
    END COMPONENT ReservationStationUnit_IssueSelector;

    SIGNAL Ready_RSU            : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";
    SIGNAL Selected_RSU_Index   : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
    SIGNAL Selected_RSU_Entry   : STD_LOGIC_VECTOR(82 DOWNTO 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000";



BEGIN

    -- Maps free entries on the RSU for each possible instruction coming from the dispatcher
    Busy_RSU <= RSU(3)(82) & RSU(2)(82) & RSU(1)(82) & RSU(0)(82);

    RSU_Entry_Finder : ReservationStationUnit_EntryFinder
    PORT MAP(
        Busy_Vector => Busy_RSU,

        Inst_0_Entry => Entry_0_RSU,
        Inst_1_Entry => Entry_1_RSU,
        Inst_2_Entry => Entry_2_RSU,
        Inst_3_Entry => Entry_3_RSU
    );


    -- Determines the first entry on the RSU that is ready for execution
    Ready_RSU <= RSU(3)(0) & RSU(2)(0) & RSU(1)(0) & RSU(0)(0);

    RSU_Issue_Selector : ReservationStationUnit_IssueSelector
    PORT MAP(
        Ready_Vector => Ready_RSU,

        RSU_Entry_0 => RSU(0),
        RSU_Entry_1 => RSU(1),
        RSU_Entry_2 => RSU(2),
        RSU_Entry_3 => RSU(3),

        RSU_Entry_Index => Selected_RSU_Index,
        RSU_Entry_Selected => Selected_RSU_Entry
    );


    -- Returns to Dispatcher the state of the RSU buffer
    RSU_Buffer_State <= RSU(3)(82) & RSU(2)(82) & RSU(1)(82) & RSU(0)(82);

    -- Dispatching of upcoming instructions on the Reservation Station
    FU_Funct7 <= FunctionalUnit_F7;
    FU_Funct3 <= FunctionalUnit_F3;
    FU_RRF_Dest <= FunctionalUnit_Dest;
    FU_Operand_S <= FunctionalUnit_S;
    FU_Operand_T <= FunctionalUnit_T;

    Instruction_Dispatching : PROCESS (Clock, Reset)
    BEGIN

        IF (Reset = '1') THEN
            RSU <= (OTHERS => "00000000000000000000000000000000000000000000000000000000000000000000000000000000000");

        ELSIF (Rising_edge(Clock)) THEN


            --------------------------------------------------------------------------------------------------------
            --                                     ALLOCATING ENTRIES BLOCK                                       --
            --
            -- Responsible for allocating, if possible, each valid instruction received to a entry on the RSU,
            -- with it's operands values and the VALID bits of each side.
            --
            --------------------------------------------------------------------------------------------------------
            IF (Instruction_0 /= "00000000000000000000000000000000") THEN

                -- Only saves the instruction for execution if there's free entries on the instruction buffer
                IF (Entry_0_RSU(2) = '0') THEN

                    -- For each instruction:
                    --   Set RSU_BUSY to '1'
                    --   Set RSU_OPERAND_1 to Side_S
                    --   Set RSU_OPERAND_1_VALID bit if Side_S carries ARF_DATA
                    --     If Valid_S is 0, RSU_OPERAND_1_VALID is 1
                    --
                    --   Set RSU_OPERAND_2 to Side_T
                    --   Set RSU_OPERAND_2_VALID bit if Side_T carries ARF_DATA
                    --     If Valid_T is 0, RSU_OPERAND_2_VALID is 1
                    --
                    --   Set RSU_READY bit if both RSU_OPERAND_VALID are also set
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(82) <= '1';
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(81 DOWNTO 75) <= Inst_0_Funct7;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(74 DOWNTO 72) <= Inst_0_Funct3;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(71 DOWNTO 67) <= Inst_0_RRF_Dest;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(66 DOWNTO 35) <= Inst_0_Side_S;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(34) <= NOT Inst_0_Valid_S;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(33 DOWNTO 2) <= Inst_0_Side_T;
                    RSU(to_integer(unsigned(Entry_0_RSU(1 DOWNTO 0))))(1) <= NOT Inst_0_Valid_T;

                END IF;

            END IF;

            IF (Instruction_1 /= "00000000000000000000000000000000") THEN
                IF (Entry_1_RSU(2) = '0') THEN
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(82) <= '1';
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(81 DOWNTO 75) <= Inst_1_Funct7;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(74 DOWNTO 72) <= Inst_1_Funct3;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(71 DOWNTO 67) <= Inst_1_RRF_Dest;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(66 DOWNTO 35) <= Inst_1_Side_S;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(34) <= NOT Inst_1_Valid_S;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(33 DOWNTO 2) <= Inst_1_Side_T;
                    RSU(to_integer(unsigned(Entry_1_RSU(1 DOWNTO 0))))(1) <= NOT Inst_1_Valid_T;
                END IF;
            END IF;

            IF (Instruction_2 /= "00000000000000000000000000000000") THEN
                IF (Entry_2_RSU(2) = '0') THEN
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(82) <= '1';
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(81 DOWNTO 75) <= Inst_2_Funct7;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(74 DOWNTO 72) <= Inst_2_Funct3;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(71 DOWNTO 67) <= Inst_2_RRF_Dest;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(66 DOWNTO 35) <= Inst_2_Side_S;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(34) <= NOT Inst_2_Valid_S;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(33 DOWNTO 2) <= Inst_2_Side_T;
                    RSU(to_integer(unsigned(Entry_2_RSU(1 DOWNTO 0))))(1) <= NOT Inst_2_Valid_T;
                END IF;
            END IF;

            IF (Instruction_3 /= "00000000000000000000000000000000") THEN
                IF (Entry_3_RSU(2) = '0') THEN
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(82) <= '1';
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(81 DOWNTO 75) <= Inst_3_Funct7;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(74 DOWNTO 72) <= Inst_3_Funct3;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(71 DOWNTO 67) <= Inst_3_RRF_Dest;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(66 DOWNTO 35) <= Inst_3_Side_S;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(34) <= NOT Inst_3_Valid_S;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(33 DOWNTO 2) <= Inst_3_Side_T;
                    RSU(to_integer(unsigned(Entry_3_RSU(1 DOWNTO 0))))(1) <= NOT Inst_3_Valid_T;
                END IF;
            END IF;




            --------------------------------------------------------------------------------------------------------
            --                                     CORRECTING OPERANDS BLOCK                                      --
            --
            -- Responsible for updating the invalid operands/sides of the instruction, replacing the RRF_TAG with
            -- the actual value, which is travelling through the results of the functional units, plus updating the
            -- bits on RSU associated with the operands
            --
            --------------------------------------------------------------------------------------------------------

            -- If the entry 0 of the RSU is occupied
            IF (RSU(0)(82) = '1') THEN

                -- If the entry has it's RSU_READY_0 bit not set
                IF (RSU(0)(0) = '0') THEN

                    -- If Side_S is the RRF_TAG
                    IF (RSU(0)(34) = '0') THEN

                        -- If the bus carries a valid write operation
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN

                            -- Verifies if the RRF_TAG on Side_S equals the RRF_TAG on the bus
                            --   If yes, RSU_Operand_1 is now the RRF_DATA on the bus
                            --   RSU_Operand_1_Valid bit is set
                            IF (RSU(0)(39 DOWNTO 35) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(0)(66 DOWNTO 35) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(0)(34) <= '1';
                            END IF;

                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(0)(39 DOWNTO 35) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(0)(66 DOWNTO 35) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(0)(34) <= '1';
                            END IF;
                        END IF;

                    END IF;

                    -- If Side_T is the RRF_TAG
                    IF (RSU(0)(1) = '0') THEN

                        -- If the bus carries a valid write operation
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN

                            -- Verifies if the RRF_TAG on Side_T equals the RRF_TAG on the bus
                            --   If yes, RSU_Operand_2 is now the RRF_DATA on the bus
                            --   RSU_Operand_2_Valid bit is set
                            IF (RSU(0)(6 DOWNTO 2) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(0)(33 DOWNTO 2) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(0)(1) <= '1';
                            END IF;

                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(0)(6 DOWNTO 2) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(0)(33 DOWNTO 2) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(0)(1) <= '1';
                            END IF;
                        END IF;

                    END IF;

                END IF;

            END IF;


            -- If the entry 1 of the RSU is occupied
            IF (RSU(1)(82) = '1') THEN

                -- If the entry has it's RSU_READY_1 bit not set
                IF (RSU(1)(0) = '0') THEN
                    IF (RSU(1)(34) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(1)(39 DOWNTO 35) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(1)(66 DOWNTO 35) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(1)(34) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(1)(39 DOWNTO 35) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(1)(66 DOWNTO 35) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(1)(34) <= '1';
                            END IF;
                        END IF;
                    END IF;

                    IF (RSU(1)(1) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(1)(6 DOWNTO 2) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(1)(33 DOWNTO 2) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(1)(1) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(1)(6 DOWNTO 2) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(1)(33 DOWNTO 2) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(1)(1) <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;


            -- If the entry 2 of the RSU is occupied
            IF (RSU(2)(82) = '1') THEN

                -- If the entry has it's RSU_READY_2 bit not set
                IF (RSU(2)(0) = '0') THEN
                    IF (RSU(2)(34) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(2)(39 DOWNTO 35) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(2)(66 DOWNTO 35) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(2)(34) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(2)(39 DOWNTO 35) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(2)(66 DOWNTO 35) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(2)(34) <= '1';
                            END IF;
                        END IF;
                    END IF;

                    IF (RSU(2)(1) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(2)(6 DOWNTO 2) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(2)(33 DOWNTO 2) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(2)(1) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(2)(6 DOWNTO 2) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(2)(33 DOWNTO 2) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(2)(1) <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;


            -- If the entry 3 of the RSU is occupied
            IF (RSU(3)(82) = '1') THEN

                -- If the entry has it's RSU_READY_3 bit not set
                IF (RSU(3)(0) = '0') THEN
                    IF (RSU(3)(34) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(3)(39 DOWNTO 35) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(3)(66 DOWNTO 35) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(3)(34) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(3)(39 DOWNTO 35) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(3)(66 DOWNTO 35) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(3)(34) <= '1';
                            END IF;
                        END IF;
                    END IF;

                    IF (RSU(3)(1) = '0') THEN
                        IF (Integer_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(3)(6 DOWNTO 2) = Integer_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(3)(33 DOWNTO 2) <= Integer_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(3)(1) <= '1';
                            END IF;
                        END IF;

                        IF (Multiplier_FU_Bus_Write_On_RRF(37) = '1') THEN
                            IF (RSU(3)(6 DOWNTO 2) = Multiplier_FU_Bus_Write_On_RRF(36 DOWNTO 32)) THEN
                                RSU(3)(33 DOWNTO 2) <= Multiplier_FU_Bus_Write_On_RRF(31 DOWNTO 0);
                                RSU(3)(1) <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;




            -- Updating the RSU_READY bit of every entry on the RSU, according to the status of both RSU_OPERANDS
            -- If both are set, RSU_READY is also set
            RSU(0)(0) <= RSU(0)(34) AND RSU(0)(1);
            RSU(1)(0) <= RSU(1)(34) AND RSU(1)(1);
            RSU(2)(0) <= RSU(2)(34) AND RSU(2)(1);
            RSU(3)(0) <= RSU(3)(34) AND RSU(3)(1);




            -- If the RSU_READY of the first entry of RSU is set (instruction ready for execution)
            IF (Selected_RSU_Entry(0) = '1') THEN

                -- Sends the instruction to the respective functional unit linked with the RS, and resets their RSU entry
                IF (FU_Identifier = "00") THEN      -- FU_Integer
                    FunctionalUnit_F7 <= Selected_RSU_Entry(81 DOWNTO 75);
                    FunctionalUnit_F3 <= Selected_RSU_Entry(74 DOWNTO 72);
                    FunctionalUnit_Dest <= Selected_RSU_Entry(71 DOWNTO 67);
                    FunctionalUnit_S <= Selected_RSU_Entry(66 DOWNTO 35);
                    FunctionalUnit_T <= Selected_RSU_Entry(33 DOWNTO 2);

                ELSIF (FU_Identifier = "01") THEN   -- FU_Multiplier
                    FunctionalUnit_F3 <= Selected_RSU_Entry(74 DOWNTO 72);
                    FunctionalUnit_Dest <= Selected_RSU_Entry(71 DOWNTO 67);
                    FunctionalUnit_S <= Selected_RSU_Entry(66 DOWNTO 35);
                    FunctionalUnit_T <= Selected_RSU_Entry(33 DOWNTO 2);
                END IF;

                -- Resets their RSU entry
                RSU(to_integer(unsigned((Selected_RSU_Index)))) <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000";

            END IF;




        END IF;
    END PROCESS;

END ARCHITECTURE behavior;