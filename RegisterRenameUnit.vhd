LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterRenameUnit IS
    GENERIC (
        Size_RRF : integer := 5   -- RRF has (2**Size_RRF) entries
    );

    PORT (
        Clock                           :  IN STD_LOGIC;
        Reset                           :  IN STD_LOGIC;

        Integer_RS_Bus_Write_On_RRF     :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);                        -- VALID_SIGNAL(37) & RRF_TAG(36 DOWNTO 32) & RRF_DATA(31 DOWNTO 0)
        Multiplier_RS_Bus_Write_On_RRF  :  IN STD_LOGIC_VECTOR(37 DOWNTO 0);
        
        Commit_From_Reorder_Buffer_0    :  IN STD_LOGIC_VECTOR(10 DOWNTO 0);                        -- VALID_SIGNAL(10) & RRF_TAG(9 DOWNTO 5) & ARF_TAG(4 DOWNTO 0)
        Commit_From_Reorder_Buffer_1    :  IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        Commit_From_Reorder_Buffer_2    :  IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        Commit_From_Reorder_Buffer_3    :  IN STD_LOGIC_VECTOR(10 DOWNTO 0);

        IO_0                            :  IN UNSIGNED(31 DOWNTO 0);                                -- Instruction_Order of Inst_0
        Instruction_0                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_0_Control                  :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);                         -- IS_RD_USED(2) & IS_RS1_USED(1) & IS_RS2_USED(0)
        Inst_0_RD                       :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_RS1                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_RS2                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_Read_On_RRF_S            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS1 coming from Reservation Station
        Inst_0_Read_On_RRF_T            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS2 coming from Reservation Station

        Inst_0_Side_S                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                        -- ARF_DATA(31 DOWNTO 0) or [0(31 DOWNTO 5) & RRF_TAG(4 DOWNTO 0)]
        Inst_0_Valid_S                  : OUT STD_LOGIC;                                            -- '0' = Side_S is ARF_DATA // '1' = Side_S is RRF_TAG
        Inst_0_Data_From_RRF_S          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);                        -- RRF_VALID(32) & RRF_DATA(31 DOWNTO 0)
        Inst_0_Side_T                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_0_Valid_T                  : OUT STD_LOGIC;
        Inst_0_Data_From_RRF_T          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
        Inst_0_RRF_Dest                 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RD(4 DOWNTO 0)

        IO_1                            :  IN UNSIGNED(31 DOWNTO 0);                                -- Instruction_Order of Inst_1
        Instruction_1                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_1_Control                  :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);                         -- IS_RD_USED(2) & IS_RS1_USED(1) & IS_RS2_USED(0)
        Inst_1_RD                       :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_1_RS1                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_1_RS2                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_1_Read_On_RRF_S            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS1 coming from Reservation Station
        Inst_1_Read_On_RRF_T            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS2 coming from Reservation Station

        Inst_1_Side_S                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                        -- ARF_DATA(31 DOWNTO 0) or [0(31 DOWNTO 5) & RRF_TAG(4 DOWNTO 0)]
        Inst_1_Valid_S                  : OUT STD_LOGIC;                                            -- '0' = Side_S is ARF_DATA // '1' = Side_S is RRF_TAG
        Inst_1_Data_From_RRF_S          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);                        -- RRF_VALID(32) & RRF_DATA(31 DOWNTO 0)
        Inst_1_Side_T                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_1_Valid_T                  : OUT STD_LOGIC;
        Inst_1_Data_From_RRF_T          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
        Inst_1_RRF_Dest                 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RD(4 DOWNTO 0)

        IO_2                            :  IN UNSIGNED(31 DOWNTO 0);                                -- Instruction_Order of Inst_2
        Instruction_2                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_2_Control                  :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);                         -- IS_RD_USED(2) & IS_RS1_USED(1) & IS_RS2_USED(0)
        Inst_2_RD                       :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_2_RS1                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_2_RS2                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_2_Read_On_RRF_S            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS1 coming from Reservation Station
        Inst_2_Read_On_RRF_T            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS2 coming from Reservation Station

        Inst_2_Side_S                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                        -- ARF_DATA(31 DOWNTO 0) or [0(31 DOWNTO 5) & RRF_TAG(4 DOWNTO 0)]
        Inst_2_Valid_S                  : OUT STD_LOGIC;                                            -- '0' = Side_S is ARF_DATA // '1' = Side_S is RRF_TAG
        Inst_2_Data_From_RRF_S          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);                        -- RRF_VALID(32) & RRF_DATA(31 DOWNTO 0)
        Inst_2_Side_T                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_2_Valid_T                  : OUT STD_LOGIC;
        Inst_2_Data_From_RRF_T          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
        Inst_2_RRF_Dest                 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RD(4 DOWNTO 0)

        IO_3                            :  IN UNSIGNED(31 DOWNTO 0);                                -- Instruction_Order of Inst_3
        Instruction_3                   :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_3_Control                  :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);                         -- IS_RD_USED(2) & IS_RS1_USED(1) & IS_RS2_USED(0)
        Inst_3_RD                       :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_3_RS1                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_3_RS2                      :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_3_Read_On_RRF_S            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS1 coming from Reservation Station
        Inst_3_Read_On_RRF_T            :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- RRF_TAG of RS2 coming from Reservation Station

        Inst_3_Side_S                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);                        -- ARF_DATA(31 DOWNTO 0) or [0(31 DOWNTO 5) & RRF_TAG(4 DOWNTO 0)]
        Inst_3_Valid_S                  : OUT STD_LOGIC;                                            -- '0' = Side_S is ARF_DATA // '1' = Side_S is RRF_TAG
        Inst_3_Data_From_RRF_S          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);                        -- RRF_VALID(32) & RRF_DATA(31 DOWNTO 0)
        Inst_3_Side_T                   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_3_Valid_T                  : OUT STD_LOGIC;
        Inst_3_Data_From_RRF_T          : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
        Inst_3_RRF_Dest                 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)                          -- RRF_TAG of RD(4 DOWNTO 0)
    );
END ENTITY RegisterRenameUnit;

ARCHITECTURE behavioral of RegisterRenameUnit IS

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & ARF_TAG(4 DOWNTO 0)
    SIGNAL ARF : BANKREG_ARF := (OTHERS => (OTHERS => '0'));   -- ARF = Architected Bank Register

    TYPE BANKREG_RRF IS array(0 to ((2**Size_RRF) - 1)) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)
    SIGNAL RRF : BANKREG_RRF := (OTHERS => (OTHERS => '0'));   -- RRF = Renamed Bank Register

    SIGNAL I0_Side_S    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I0_Side_T    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I0_Valid_S   : STD_LOGIC                     := '0';
    SIGNAL I0_Valid_T   : STD_LOGIC                     := '0';
    SIGNAL I0_Dest      : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');

    SIGNAL I1_Side_S    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I1_Side_T    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I1_Valid_S   : STD_LOGIC                     := '0';
    SIGNAL I1_Valid_T   : STD_LOGIC                     := '0';
    SIGNAL I1_Dest      : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');

    SIGNAL I2_Side_S    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I2_Side_T    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I2_Valid_S   : STD_LOGIC                     := '0';
    SIGNAL I2_Valid_T   : STD_LOGIC                     := '0';
    SIGNAL I2_Dest      : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');

    SIGNAL I3_Side_S    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I3_Side_T    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I3_Valid_S   : STD_LOGIC                     := '0';
    SIGNAL I3_Valid_T   : STD_LOGIC                     := '0';
    SIGNAL I3_Dest      : STD_LOGIC_VECTOR(4 DOWNTO 0)  := (OTHERS => '0');

    COMPONENT RegisterRenameUnit_TagFinder IS
        PORT(
            RRF_Busy_Vector_Slice_0   :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_1   :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_2   :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            RRF_Busy_Vector_Slice_3   :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);

            Inst_0_RRF_Tag_RD         : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            Inst_1_RRF_Tag_RD         : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            Inst_2_RRF_Tag_RD         : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            Inst_3_RRF_Tag_RD         : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit_TagFinder;

    SIGNAL Busy_Vector_Slice_0 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Busy_Vector_Slice_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Busy_Vector_Slice_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Busy_Vector_Slice_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I0_Tag_From_TagFinder : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I1_Tag_From_TagFinder : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I2_Tag_From_TagFinder : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I3_Tag_From_TagFinder : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');

BEGIN

    Busy_Vector_Slice_0 <= RRF(7)(0) & RRF(6)(0) & RRF(5)(0) & RRF(4)(0) & RRF(3)(0) & RRF(2)(0) & RRF(1)(0) & RRF(0)(0);
    Busy_Vector_Slice_1 <= RRF(15)(0) & RRF(14)(0) & RRF(13)(0) & RRF(12)(0) & RRF(11)(0) & RRF(10)(0) & RRF(9)(0) & RRF(8)(0);
    Busy_Vector_Slice_2 <= RRF(23)(0) & RRF(22)(0) & RRF(21)(0) & RRF(20)(0) & RRF(19)(0) & RRF(18)(0) & RRF(17)(0) & RRF(16)(0);
    Busy_Vector_Slice_3 <= RRF(31)(0) & RRF(30)(0) & RRF(29)(0) & RRF(28)(0) & RRF(27)(0) & RRF(26)(0) & RRF(25)(0) & RRF(24)(0);

    RRU_TagFinder : RegisterRenameUnit_TagFinder
    PORT MAP(
        RRF_Busy_Vector_Slice_0 => Busy_Vector_Slice_0,
        RRF_Busy_Vector_Slice_1 => Busy_Vector_Slice_1,
        RRF_Busy_Vector_Slice_2 => Busy_Vector_Slice_2,
        RRF_Busy_Vector_Slice_3 => Busy_Vector_Slice_3,

        Inst_0_RRF_Tag_RD => I0_Tag_From_TagFinder,
        Inst_1_RRF_Tag_RD => I1_Tag_From_TagFinder,
        Inst_2_RRF_Tag_RD => I2_Tag_From_TagFinder,
        Inst_3_RRF_Tag_RD => I3_Tag_From_TagFinder
    );


    Inst_0_RRF_Dest <= I0_Dest;
    Inst_0_Side_S <= I0_Side_S;
    Inst_0_Valid_S <= I0_Valid_S;
    Inst_0_Side_T <= I0_Side_T;
    Inst_0_Valid_T <= I0_Valid_T;

    Inst_1_RRF_Dest <= I1_Dest;
    Inst_1_Side_S <= I1_Side_S;
    Inst_1_Valid_S <= I1_Valid_S;
    Inst_1_Side_T <= I1_Side_T;
    Inst_1_Valid_T <= I1_Valid_T;

    Inst_2_RRF_Dest <= I2_Dest;
    Inst_2_Side_S <= I2_Side_S;
    Inst_2_Valid_S <= I2_Valid_S;
    Inst_2_Side_T <= I2_Side_T;
    Inst_2_Valid_T <= I2_Valid_T;

    Inst_3_RRF_Dest <= I3_Dest;
    Inst_3_Side_S <= I3_Side_S;
    Inst_3_Valid_S <= I3_Valid_S;
    Inst_3_Side_T <= I3_Side_T;
    Inst_3_Valid_T <= I3_Valid_T;

    Register_Renaming: PROCESS(Clock, Reset)
    BEGIN

        IF (Reset = '1') THEN
            ARF <= (OTHERS => (OTHERS => '0'));
            RRF <= (OTHERS => (OTHERS => '0'));

        ELSIF (Rising_edge(Clock)) THEN


            --------------------------------------------------------------------------------------------------------
            --                                         RENAMING BLOCK                                             --
            --
            -- Responsible for associating a RRF entry to every register used on the instructions, 
            -- while updating the control bits on both ARF and RRF entries
            --
            --------------------------------------------------------------------------------------------------------
            IF (Instruction_0 /= "00000000000000000000000000000000") THEN

                -- If the instruction has RD
                IF (Inst_0_Control(2) = '1') THEN

                    -- Only process this type of instruction if there's a RRF tag available for RD on the instruction's RRF slice
                    IF (I0_Tag_From_TagFinder(5) = '0') THEN

                        -- Renaming process of RD
                        -- On ARF, set:
                        --   BIT_BUSY to 1 (renamed)                            / ARF(5)
                        --   RRF_TAG  to the register's new index alias on RRF  / ARF(4 DOWNTO 0)  
                        ARF(to_integer(unsigned(Inst_0_RD)))(5 DOWNTO 0) <= '1' & I0_Tag_From_TagFinder(4 DOWNTO 0);

                        -- On RRF, set:
                        --   RRF_VALUE to that register's current value on ARF   / RRF(33 DOWNTO 2)
                        --   RRF_VALID to 0 (data is not ready)                  / RRF(1)
                        --   RRF_BUSY  to 1 (current alias is being used)        / RRF(0) 
                        RRF(to_integer(unsigned(I0_Tag_From_TagFinder(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_0_RD)))(37 DOWNTO 6) & '0' & '1';

                        -- Set the alias of RD as the destination of the result of the instruction on the Reservation Station
                        I0_Dest <= I0_Tag_From_TagFinder(4 DOWNTO 0);


                        -- If the instruction has RS1, executes the Side S logic
                        -- Else, zero out the S signals
                        IF (Inst_0_Control(1) = '1') THEN

                            -- The value of Side S is first determined by ARF_BUSY on ARF_RS1:
                            --   If 0, Side S is the ARF_DATA stored on the ARF register
                            --   If 1, the value of Side S is now determined by RRF_VALID on RRF_TAG
                            --     If 0, Side S is the index of the RRF register on which the data will be written
                            --     If 1, Side S is the RRF_DATA stored on the RRF register
                            --     (currently testing) If 1, Side S is Inst_0_Data_From_RRF_S
                            IF (ARF(to_integer(unsigned(Inst_0_RS1)))(5) = '0') THEN
                                I0_Side_S <= ARF(to_integer(unsigned(Inst_0_RS1)))(37 DOWNTO 6); -- ARF_DATA
                                I0_Valid_S <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_0_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I0_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_0_RS1)))(4 DOWNTO 0); -- ARF_TAG
                                    I0_Valid_S <= '1';
                                ELSE
                                    I0_Side_S <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I0_Side_S <= (OTHERS => '0');
                            I0_Valid_S <= '0';
                        END IF;


                        -- If the instruction has RS2, executes the Side T logic
                        -- Else, zero out the T signals
                        IF (Inst_0_Control(0) = '1') THEN

                            -- The value of Side T is first determined by ARF_BUSY on ARF_RS2:
                            --   If 0, Side T is the ARF_DATA stored on the ARF register
                            --   If 1, the value of Side T is now determined by RRF_VALID on RRF_TAG
                            --     If 0, Side T is the index of the RRF register on which the data will be written
                            --     If 1, Side T is the RRF_DATA stored on the RRF register
                            --     (currently testing) If 1, Side T is Inst_0_Data_From_RRF_T
                            IF (ARF(to_integer(unsigned(Inst_0_RS2)))(5) = '0') THEN
                                I0_Side_T <= ARF(to_integer(unsigned(Inst_0_RS2)))(37 DOWNTO 6); -- ARF_DATA
                                I0_Valid_T <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_0_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I0_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_0_RS2)))(4 DOWNTO 0); -- ARF_TAG
                                    I0_Valid_T <= '1';
                                ELSE
                                    I0_Side_T <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I0_Side_T <= (OTHERS => '0');
                            I0_Valid_T <= '0';
                        END IF;

                    END IF;

                ELSE

                    -- By our ISA, if the valid instruction doesn't have a RD, it has RS1 and RS2
                    -- Executing the S logic (RS1)
                    IF (ARF(to_integer(unsigned(Inst_0_RS1)))(5) = '0') THEN
                        I0_Side_S <= ARF(to_integer(unsigned(Inst_0_RS1)))(37 DOWNTO 6);
                        I0_Valid_S <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_0_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I0_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_0_RS1)))(4 DOWNTO 0);
                            I0_Valid_S <= '1';
                        ELSE
                            I0_Side_S <= (OTHERS => '0');
                        END IF;
                    END IF;

                    -- Executing the T logic (RS2)
                    IF (ARF(to_integer(unsigned(Inst_0_RS2)))(5) = '0') THEN
                        I0_Side_T <= ARF(to_integer(unsigned(Inst_0_RS2)))(37 DOWNTO 6); -- ARF_DATA
                        I0_Valid_T <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_0_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I0_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_0_RS2)))(4 DOWNTO 0); -- ARF_TAG
                            I0_Valid_T <= '1';
                        ELSE
                            I0_Side_T <= (OTHERS => '0');
                        END IF;
                    END IF;

                END IF;
            END IF;


            IF (Instruction_1 /= "00000000000000000000000000000000") THEN
                IF (Inst_1_Control(2) = '1') THEN

                    IF (I1_Tag_From_TagFinder(5) = '0') THEN

                        ARF(to_integer(unsigned(Inst_1_RD)))(5 DOWNTO 0) <= '1' & I1_Tag_From_TagFinder(4 DOWNTO 0);
                        RRF(to_integer(unsigned(I1_Tag_From_TagFinder(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_1_RD)))(37 DOWNTO 6) & '0' & '1';
                        I1_Dest <= I1_Tag_From_TagFinder(4 DOWNTO 0);

                        IF (Inst_1_Control(1) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_1_RS1)))(5) = '0') THEN
                                I1_Side_S <= ARF(to_integer(unsigned(Inst_1_RS1)))(37 DOWNTO 6); -- ARF_DATA
                                I1_Valid_S <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_1_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I1_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_1_RS1)))(4 DOWNTO 0); -- ARF_TAG
                                    I1_Valid_S <= '1';
                                ELSE
                                    I1_Side_S <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I1_Side_S <= (OTHERS => '0');
                            I1_Valid_S <= '0';
                        END IF;

                        IF (Inst_1_Control(0) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_1_RS2)))(5) = '0') THEN
                                I1_Side_T <= ARF(to_integer(unsigned(Inst_1_RS2)))(37 DOWNTO 6); -- ARF_DATA
                                I1_Valid_T <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_1_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I1_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_1_RS2)))(4 DOWNTO 0); -- ARF_TAG
                                    I1_Valid_T <= '1';
                                ELSE
                                    I1_Side_T <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I1_Side_T <= (OTHERS => '0');
                            I1_Valid_T <= '0';
                        END IF;
                    END IF;

                ELSE

                    IF (ARF(to_integer(unsigned(Inst_1_RS1)))(5) = '0') THEN
                        I1_Side_S <= ARF(to_integer(unsigned(Inst_1_RS1)))(37 DOWNTO 6);
                        I1_Valid_S <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_1_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I1_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_1_RS1)))(4 DOWNTO 0);
                            I1_Valid_S <= '1';
                        ELSE
                            I1_Side_S <= (OTHERS => '0');
                        END IF;
                    END IF;

                    IF (ARF(to_integer(unsigned(Inst_1_RS2)))(5) = '0') THEN
                        I1_Side_T <= ARF(to_integer(unsigned(Inst_1_RS2)))(37 DOWNTO 6); -- ARF_DATA
                        I1_Valid_T <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_1_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I1_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_1_RS2)))(4 DOWNTO 0); -- ARF_TAG
                            I1_Valid_T <= '1';
                        ELSE
                            I1_Side_T <= (OTHERS => '0');
                        END IF;
                    END IF;

                END IF;
            END IF;

            
            IF (Instruction_2 /= "00000000000000000000000000000000") THEN
                IF (Inst_2_Control(2) = '1') THEN

                    IF (I2_Tag_From_TagFinder(5) = '0') THEN

                        ARF(to_integer(unsigned(Inst_2_RD)))(5 DOWNTO 0) <= '1' & I2_Tag_From_TagFinder(4 DOWNTO 0);
                        RRF(to_integer(unsigned(I2_Tag_From_TagFinder(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_2_RD)))(37 DOWNTO 6) & '0' & '1';
                        I2_Dest <= I2_Tag_From_TagFinder(4 DOWNTO 0);

                        IF (Inst_2_Control(1) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_2_RS1)))(5) = '0') THEN
                                I2_Side_S <= ARF(to_integer(unsigned(Inst_2_RS1)))(37 DOWNTO 6); -- ARF_DATA
                                I2_Valid_S <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_2_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I2_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_2_RS1)))(4 DOWNTO 0); -- ARF_TAG
                                    I2_Valid_S <= '1';
                                ELSE
                                    I2_Side_S <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I2_Side_S <= (OTHERS => '0');
                            I2_Valid_S <= '0';
                        END IF;

                        IF (Inst_2_Control(0) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_2_RS2)))(5) = '0') THEN
                                I2_Side_T <= ARF(to_integer(unsigned(Inst_2_RS2)))(37 DOWNTO 6); -- ARF_DATA
                                I2_Valid_T <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_2_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I2_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_2_RS2)))(4 DOWNTO 0); -- ARF_TAG
                                    I2_Valid_T <= '1';
                                ELSE
                                    I2_Side_T <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I2_Side_T <= (OTHERS => '0');
                            I2_Valid_T <= '0';
                        END IF;
                    END IF;

                ELSE

                    IF (ARF(to_integer(unsigned(Inst_2_RS1)))(5) = '0') THEN
                        I2_Side_S <= ARF(to_integer(unsigned(Inst_2_RS1)))(37 DOWNTO 6);
                        I2_Valid_S <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_2_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I2_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_2_RS1)))(4 DOWNTO 0);
                            I2_Valid_S <= '1';
                        ELSE
                            I2_Side_S <= (OTHERS => '0');
                        END IF;
                    END IF;

                    IF (ARF(to_integer(unsigned(Inst_2_RS2)))(5) = '0') THEN
                        I2_Side_T <= ARF(to_integer(unsigned(Inst_2_RS2)))(37 DOWNTO 6); -- ARF_DATA
                        I2_Valid_T <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_2_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I2_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_2_RS2)))(4 DOWNTO 0); -- ARF_TAG
                            I2_Valid_T <= '1';
                        ELSE
                            I2_Side_T <= (OTHERS => '0');
                        END IF;
                    END IF;

                END IF;
            END IF;


            IF (Instruction_3 /= "00000000000000000000000000000000") THEN
                IF (Inst_3_Control(2) = '1') THEN

                    IF (I3_Tag_From_TagFinder(5) = '0') THEN

                        ARF(to_integer(unsigned(Inst_3_RD)))(5 DOWNTO 0) <= '1' & I3_Tag_From_TagFinder(4 DOWNTO 0);
                        RRF(to_integer(unsigned(I3_Tag_From_TagFinder(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_3_RD)))(37 DOWNTO 6) & '0' & '1';
                        I3_Dest <= I3_Tag_From_TagFinder(4 DOWNTO 0);

                        IF (Inst_3_Control(1) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_3_RS1)))(5) = '0') THEN
                                I3_Side_S <= ARF(to_integer(unsigned(Inst_3_RS1)))(37 DOWNTO 6); -- ARF_DATA
                                I3_Valid_S <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_3_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I3_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_3_RS1)))(4 DOWNTO 0); -- ARF_TAG
                                    I3_Valid_S <= '1';
                                ELSE
                                    I3_Side_S <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I3_Side_S <= (OTHERS => '0');
                            I3_Valid_S <= '0';
                        END IF;

                        IF (Inst_3_Control(0) = '1') THEN
                            IF (ARF(to_integer(unsigned(Inst_3_RS2)))(5) = '0') THEN
                                I3_Side_T <= ARF(to_integer(unsigned(Inst_3_RS2)))(37 DOWNTO 6); -- ARF_DATA
                                I3_Valid_T <= '0';
                            ELSE
                                IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_3_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                                    I3_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_3_RS2)))(4 DOWNTO 0); -- ARF_TAG
                                    I3_Valid_T <= '1';
                                ELSE
                                    I3_Side_T <= (OTHERS => '0');
                                END IF;
                            END IF;
                        ELSE
                            I3_Side_T <= (OTHERS => '0');
                            I3_Valid_T <= '0';
                        END IF;
                    END IF;

                ELSE

                    IF (ARF(to_integer(unsigned(Inst_3_RS1)))(5) = '0') THEN
                        I3_Side_S <= ARF(to_integer(unsigned(Inst_3_RS1)))(37 DOWNTO 6);
                        I3_Valid_S <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_3_RS1)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I3_Side_S <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_3_RS1)))(4 DOWNTO 0);
                            I3_Valid_S <= '1';
                        ELSE
                            I3_Side_S <= (OTHERS => '0');
                        END IF;
                    END IF;

                    IF (ARF(to_integer(unsigned(Inst_3_RS2)))(5) = '0') THEN
                        I3_Side_T <= ARF(to_integer(unsigned(Inst_3_RS2)))(37 DOWNTO 6); -- ARF_DATA
                        I3_Valid_T <= '0';
                    ELSE
                        IF (RRF(to_integer(unsigned( ARF(to_integer(unsigned(Inst_3_RS2)))(4 DOWNTO 0) )))(1) = '0') THEN
                            I3_Side_T <= std_logic_vector(to_unsigned(0, 27)) & ARF(to_integer(unsigned(Inst_3_RS2)))(4 DOWNTO 0); -- ARF_TAG
                            I3_Valid_T <= '1';
                        ELSE
                            I3_Side_T <= (OTHERS => '0');
                        END IF;
                    END IF;

                END IF;
            END IF;
            --------------------------------------------------------------------------------------------------------


            --------------------------------------------------------------------------------------------------------
            --                                          WRITING BLOCK                                             --
            --
            -- Responsible for writing the results of the Reservation Stations's calculations into the RRF registers
            -- before the COMMIT BLOCK. The purpose is for instructions where the operators data is not yet ready
            -- Allows 1 writing for every Reservation Station type that can write on RRF
            --
            --------------------------------------------------------------------------------------------------------
            IF (Integer_RS_Bus_Write_On_RRF(37) = '1') THEN
                IF (RRF(to_integer(unsigned(Integer_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(0) = '1') THEN -- RRF_BUSY should be 1
                    IF (RRF(to_integer(unsigned(Integer_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(1) = '0') THEN  -- RRF_VALID should be 0
                        RRF(to_integer(unsigned(Integer_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(33 DOWNTO 2) <= Integer_RS_Bus_Write_On_RRF(31 DOWNTO 0); -- RS_DATA is written into RRF_DATA
                        RRF(to_integer(unsigned(Integer_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(1) <= '1'; -- RRF_VALID set to 1
                    END IF;
                END IF;
            END IF;

            IF (Multiplier_RS_Bus_Write_On_RRF(37) = '1') THEN
                IF (RRF(to_integer(unsigned(Multiplier_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(0) = '1') THEN -- RRF_BUSY should be 1
                    IF (RRF(to_integer(unsigned(Multiplier_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(1) = '0') THEN  -- RRF_VALID should be 0
                        RRF(to_integer(unsigned(Multiplier_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(33 DOWNTO 2) <= Multiplier_RS_Bus_Write_On_RRF(31 DOWNTO 0); -- RS_DATA is written into RRF_DATA
                        RRF(to_integer(unsigned(Multiplier_RS_Bus_Write_On_RRF(36 DOWNTO 32))))(1) <= '1'; -- RRF_VALID set to 1
                    END IF;
                END IF;
            END IF;
            --------------------------------------------------------------------------------------------------------


            --------------------------------------------------------------------------------------------------------
            --                                          COMMIT BLOCK                                             --
            --
            -- Responsible for writing the data on RRF register into the respective ARF register,
            -- while updating the control bits on both registers
            -- Maximum capacity is 4 parallel writings
            --
            --------------------------------------------------------------------------------------------------------
            IF (Commit_From_Reorder_Buffer_0(10) = '1') THEN
                IF (ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(4 DOWNTO 0))))(5) = '1') THEN        -- ARF_BUSY should be 1
                    IF (RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(9 DOWNTO 5))))(0) = '1') THEN              -- RRF_BUSY should also be 1
                        -- RRF actions
                        RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(9 DOWNTO 5)))) <= (OTHERS => '0');  -- Zero out the entire RRF entry

                        -- ARF actions
                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(4 DOWNTO 0))))(37 DOWNTO 6) <= RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(9 DOWNTO 5))))(33 DOWNTO 2); -- RRF_DATA is written into ARF_DATA
                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_0(4 DOWNTO 0))))(5 DOWNTO 0) <= "000000"; -- Zero out the ARF_BUSY and ARF_TAG
                    END IF;
                END IF;
            END IF;

            IF (Commit_From_Reorder_Buffer_1(10) = '1') THEN
                IF (ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(4 DOWNTO 0))))(5) = '1') THEN
                    IF (RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(9 DOWNTO 5))))(0) = '1') THEN
                        RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(9 DOWNTO 5)))) <= (OTHERS => '0');

                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(4 DOWNTO 0))))(37 DOWNTO 6) <= RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(9 DOWNTO 5))))(33 DOWNTO 2);
                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_1(4 DOWNTO 0))))(5 DOWNTO 0) <= "000000";
                    END IF;
                END IF;
            END IF;

            IF (Commit_From_Reorder_Buffer_2(10) = '1') THEN
                IF (ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(4 DOWNTO 0))))(5) = '1') THEN
                    IF (RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(9 DOWNTO 5))))(0) = '1') THEN
                        RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(9 DOWNTO 5)))) <= (OTHERS => '0');

                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(4 DOWNTO 0))))(37 DOWNTO 6) <= RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(9 DOWNTO 5))))(33 DOWNTO 2);
                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_2(4 DOWNTO 0))))(5 DOWNTO 0) <= "000000";
                    END IF;
                END IF;
            END IF;

            IF (Commit_From_Reorder_Buffer_3(10) = '1') THEN
                IF (ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(4 DOWNTO 0))))(5) = '1') THEN
                    IF (RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(9 DOWNTO 5))))(0) = '1') THEN
                        RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(9 DOWNTO 5)))) <= (OTHERS => '0');

                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(4 DOWNTO 0))))(37 DOWNTO 6) <= RRF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(9 DOWNTO 5))))(33 DOWNTO 2);
                        ARF(to_integer(unsigned(Commit_From_Reorder_Buffer_3(4 DOWNTO 0))))(5 DOWNTO 0) <= "000000";
                    END IF;
                END IF;
            END IF;
            --------------------------------------------------------------------------------------------------------


        END IF;
    END PROCESS;



    Inst_0_Read_RRF_From_Reservation_Station_S : PROCESS (Inst_0_Read_On_RRF_S)
    BEGIN
        -- RRF_VALID & RRF_DATA
        Inst_0_Data_From_RRF_S <= RRF(to_integer(unsigned(Inst_0_Read_On_RRF_S)))(1) & RRF(to_integer(unsigned(Inst_0_Read_On_RRF_S)))(33 DOWNTO 2);
    END PROCESS;

    Inst_0_Read_RRF_From_Reservation_Station_T : PROCESS (Inst_0_Read_On_RRF_T)
    BEGIN
        Inst_0_Data_From_RRF_T <= RRF(to_integer(unsigned(Inst_0_Read_On_RRF_T)))(1) & RRF(to_integer(unsigned(Inst_0_Read_On_RRF_T)))(33 DOWNTO 2);
    END PROCESS;

    Inst_1_Read_RRF_From_Reservation_Station_S : PROCESS (Inst_1_Read_On_RRF_S)
    BEGIN
        Inst_1_Data_From_RRF_S <= RRF(to_integer(unsigned(Inst_1_Read_On_RRF_S)))(1) & RRF(to_integer(unsigned(Inst_1_Read_On_RRF_S)))(33 DOWNTO 2);
    END PROCESS;

    Inst_1_Read_RRF_From_Reservation_Station_T : PROCESS (Inst_1_Read_On_RRF_T)
    BEGIN
        Inst_1_Data_From_RRF_T <= RRF(to_integer(unsigned(Inst_1_Read_On_RRF_T)))(1) & RRF(to_integer(unsigned(Inst_1_Read_On_RRF_T)))(33 DOWNTO 2);
    END PROCESS;

    Inst_2_Read_RRF_From_Reservation_Station_S : PROCESS (Inst_2_Read_On_RRF_S)
    BEGIN
        Inst_2_Data_From_RRF_S <= RRF(to_integer(unsigned(Inst_2_Read_On_RRF_S)))(1) & RRF(to_integer(unsigned(Inst_2_Read_On_RRF_S)))(33 DOWNTO 2);
    END PROCESS;

    Inst_2_Read_RRF_From_Reservation_Station_T : PROCESS (Inst_2_Read_On_RRF_T)
    BEGIN
        Inst_2_Data_From_RRF_T <= RRF(to_integer(unsigned(Inst_2_Read_On_RRF_T)))(1) & RRF(to_integer(unsigned(Inst_2_Read_On_RRF_T)))(33 DOWNTO 2);
    END PROCESS;

    Inst_3_Read_RRF_From_Reservation_Station_S : PROCESS (Inst_3_Read_On_RRF_S)
    BEGIN
        Inst_3_Data_From_RRF_S <= RRF(to_integer(unsigned(Inst_3_Read_On_RRF_S)))(1) & RRF(to_integer(unsigned(Inst_3_Read_On_RRF_S)))(33 DOWNTO 2);
    END PROCESS;

    Inst_3_Read_RRF_From_Reservation_Station_T : PROCESS (Inst_3_Read_On_RRF_T)
    BEGIN
        Inst_3_Data_From_RRF_T <= RRF(to_integer(unsigned(Inst_3_Read_On_RRF_T)))(1) & RRF(to_integer(unsigned(Inst_3_Read_On_RRF_T)))(33 DOWNTO 2);
    END PROCESS;


END ARCHITECTURE behavioral;