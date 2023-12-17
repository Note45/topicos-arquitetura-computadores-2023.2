LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterRenameUnit IS
    GENERIC (
        Size_RRF : integer := 5                                                          -- RRF has (2**Size_RRF) entries
    );

    PORT (
        Clock               :  IN STD_LOGIC;
        Reset               :  IN STD_LOGIC;

--      Commit_Reorder_Buffer   :  IN STD_LOGIC_VECTOR( DOWNTO 0);
        Bus_Write_On_RRF        :  IN STD_LOGIC_VECTOR(((Size_RRF + 32) - 1) DOWNTO 0); -- RRF_TAG(36 DOWNTO 32) & RRF_DATA(31 DOWNTO 0)

        IO_0                    :  IN UNSIGNED(31 DOWNTO 0);                                 -- Instruction_Order of Inst_0
        Instruction_0           :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Inst_0_Control          :  IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_0_RD               :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_RS1              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_RS2              :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Inst_0_Read_On_RRF      :  IN STD_LOGIC_VECTOR(((Size_RRF*2) - 1) DOWNTO 0);         -- SIDE_S_TAG(9 DOWNTO 5) & SIDE_T_TAG(4 DOWNTO 0)

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

        Inst_0_RRF_Dest         : OUT STD_LOGIC_VECTOR((Size_RRF - 1) DOWNTO 0);   -- RRF_TAG_of_RD(4 DOWNTO 0)
        Inst_0_Side_S           : OUT STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0);  -- IS_VALID(32) & (ARF_DATA(31 DOWNTO 0) |OR| '0'(31 DOWNTO 5) & RRF_TAG(4 DOWNTO 0))
        Inst_0_Valid_S          : OUT STD_LOGIC;                                   -- '0' = ABOVE IS ARF_DATA, '1' = ABOVE IS RRF_TAG
        Inst_0_Data_From_RRF_S  : OUT STD_LOGIC_VECTOR((Size_RRF + 32) DOWNTO 0);  -- IS_VALID(37) & RRF_TAG(36 DOWNTO 32) & RRF_DATA(31 DOWNTO 0)
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
END ENTITY RegisterRenameUnit;

ARCHITECTURE behavioral of RegisterRenameUnit IS

    COMPONENT RegisterRenameUnit_TagFinder IS
        PORT(
            RRF_Busy_Vector_Slice_0   :  IN STD_LOGIC_VECTOR((((2**5)/4) - 1) DOWNTO 0);
            RRF_Busy_Vector_Slice_1   :  IN STD_LOGIC_VECTOR((((2**5)/4) - 1) DOWNTO 0);
            RRF_Busy_Vector_Slice_2   :  IN STD_LOGIC_VECTOR((((2**5)/4) - 1) DOWNTO 0);
            RRF_Busy_Vector_Slice_3   :  IN STD_LOGIC_VECTOR((((2**5)/4) - 1) DOWNTO 0);

            Three_Tags_Inst_0         : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
            Three_Tags_Inst_1         : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
            Three_Tags_Inst_2         : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
            Three_Tags_Inst_3         : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit_TagFinder;

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & ARF_TAG(4 DOWNTO 0)
    SIGNAL ARF : BANKREG_ARF := (OTHERS => (OTHERS => '0'));   -- ARF = Architected Bank Register

    TYPE BANKREG_RRF IS array(0 to ((2**Size_RRF) - 1)) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)
    SIGNAL RRF : BANKREG_RRF := (OTHERS => (OTHERS => '0'));   -- RRF = Renamed Bank Register

    SIGNAL Busy_Vector_Slice_0, Busy_Vector_Slice_1, Busy_Vector_Slice_2, Busy_Vector_Slice_3 : STD_LOGIC_VECTOR((((2**Size_RRF) / 4) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL Register_Tags_I0, Register_Tags_I1, Register_Tags_I2, Register_Tags_I3 : STD_LOGIC_VECTOR(14 DOWNTO 0) := (OTHERS => '0');

    SIGNAL I0_Side_S, I1_Side_S, I2_Side_S, I3_Side_S : STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0) := (OTHERS => '0');
    SIGNAL I0_Valid_S, I1_Valid_S, I2_Valid_S, I3_Valid_S : STD_LOGIC := '0';
    SIGNAL I0_Side_T, I1_Side_T, I2_Side_T, I3_Side_T : STD_LOGIC_VECTOR(((2**Size_RRF)) DOWNTO 0) := (OTHERS => '0');
    SIGNAL I0_Valid_T, I1_Valid_T, I2_Valid_T, I3_Valid_T : STD_LOGIC := '0';
    SIGNAL I0_Dest, I1_Dest, I2_Dest, I3_Dest : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');

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

        Three_Tags_Inst_0 => Register_Tags_I0,
        Three_Tags_Inst_1 => Register_Tags_I1,
        Three_Tags_Inst_2 => Register_Tags_I2,
        Three_Tags_Inst_3 => Register_Tags_I3
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

            -- Does the writing of the pending RRF_DATA on RRF register if:
            --   RRF_BUSY is 1
            --   RRF_VALID is 0
            -- When the writing is done, also updates RRF_VALID to 1
            IF (RRF(to_integer(unsigned(Bus_Write_On_RRF(36 DOWNTO 32))))(0) = '1') THEN
                IF (RRF(to_integer(unsigned(Bus_Write_On_RRF(36 DOWNTO 32))))(1) = '0') THEN
                    RRF(to_integer(unsigned(Bus_Write_On_RRF(36 DOWNTO 32))))(33 DOWNTO 2) <= Bus_Write_On_RRF(31 DOWNTO 0);
                    RRF(to_integer(unsigned(Bus_Write_On_RRF(36 DOWNTO 32))))(1) <= '1';
                END IF;
            END IF;


            IF (Instruction_0 /= "00000000000000000000000000000000") THEN
                IF (Inst_0_Control(2) = '1') THEN -- Instruction_0 uses RD
                    -- On ARF, set:
                    --   BIT_BUSY to 1 (renamed)                            / ARF(5)
                    --   RRF_TAG  to the register's new index alias on RRF  / ARF(4 DOWNTO 0)  
                    ARF(to_integer(unsigned(Inst_0_RD)))(5 DOWNTO 0) <= '1' & Register_Tags_I0(14 DOWNTO 10);

                    -- On RRF, set:
                    --   RRF_VALUE to that register's current value on ARF   / RRF(33 DOWNTO 2)
                    --   RRF_VALID to 0 (data is not ready)                  / RRF(1)
                    --   RRF_BUSY  to 1 (current alias is being used)        / RRF(0) 
                    RRF(to_integer(unsigned(Register_Tags_I0(14 DOWNTO 10))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_0_RD)))(37 DOWNTO 6) & '0' & '1';

                    -- Set the alias of RD as the destination of the result of the instruction on the Reservation Station
                    I0_Dest <= Register_Tags_I0(14 DOWNTO 10);
                END IF;

                IF (Inst_0_Control(1) = '1') THEN -- Instruction_0 uses RS1
                    ARF(to_integer(unsigned(Inst_0_RS1)))(5 DOWNTO 0) <= '1' & Register_Tags_I0(9 DOWNTO 5);
                    RRF(to_integer(unsigned(Register_Tags_I0(9 DOWNTO 5))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_0_RS1)))(37 DOWNTO 6) & '0' & '1';

                    -- The value of RRF_VALID on RRF_RS1 determines the Side S:
                    --   If 0, Side S is the value on the original register (RS1 on ARF)
                    --   If 1, Side S is the value on the alias register (RRF)
                    --   MSB = 1, used side (instruction has a RS1)
                    IF (RRF(to_integer(unsigned(Register_Tags_I0(9 DOWNTO 5))))(1) = '0') THEN
                        I0_Side_S <= '1' & ARF(to_integer(unsigned(Inst_0_RS1)))(37 DOWNTO 6);
                        I0_Valid_S <= '0';
                    ELSE
                        I0_Side_S <= '1' & std_logic_vector(to_unsigned(0, ((2**Size_RRF)-5))) & Register_Tags_I0(9 DOWNTO 5);
                        I0_Valid_S <= '1';
                    END IF;
                ELSE
                    --   MSB = 0, unused side (no register RS1 associated with the instruction)
                    I0_Side_S <= (OTHERS => '0');
                    I0_Valid_S <= '0';
                END IF;

                IF (Inst_0_Control(0) = '1') THEN -- Instruction_0 uses RS2
                    ARF(to_integer(unsigned(Inst_0_RS2)))(5 DOWNTO 0) <= '1' & Register_Tags_I0(4 DOWNTO 0);
                    RRF(to_integer(unsigned(Register_Tags_I0(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_0_RS2)))(37 DOWNTO 6) & '0' & '1';

                    -- The value of RRF_VALID on RRF_RS2 determines the Side T:
                    --   If 0, Side T is the value on the original register (RS2 on ARF)
                    --   If 1, Side T is the value on the alias register (RRF)
                    --   MSB = 1, used side (instruction has a RS2)
                    IF (RRF(to_integer(unsigned(Register_Tags_I0(4 DOWNTO 0))))(1) = '0') THEN
                        I0_Side_T <= '1' & ARF(to_integer(unsigned(Inst_0_RS2)))(37 DOWNTO 6);
                        I0_Valid_T <= '0';
                    ELSE
                        I0_Side_T <= '1' & std_logic_vector(to_unsigned(0, ((2**Size_RRF)-5))) & Register_Tags_I0(4 DOWNTO 0);
                        I0_Valid_T <= '1';
                    END IF;
                ELSE
                    --   MSB = 0, unused side (no register RS2 associated with the instruction)
                    I0_Side_T <= (OTHERS => '0');
                    I0_Valid_T <= '0';
                END IF;
            END IF;


            IF (Instruction_1 /= "00000000000000000000000000000000") THEN
                IF (Inst_1_Control(2) = '1') THEN -- Instruction_1 uses RD
                    ARF(to_integer(unsigned(Inst_1_RD)))(5 DOWNTO 0) <= '1' & Register_Tags_I1(14 DOWNTO 10);
                    RRF(to_integer(unsigned(Register_Tags_I1(14 DOWNTO 10))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_1_RD)))(37 DOWNTO 6) & '0' & '1';
                    
                    I1_Dest <= Register_Tags_I1(14 DOWNTO 10);
                END IF;

                IF (Inst_1_Control(1) = '1') THEN -- Instruction_1 uses RS1
                    ARF(to_integer(unsigned(Inst_1_RS1)))(5 DOWNTO 0) <= '1' & Register_Tags_I1(9 DOWNTO 5);
                    RRF(to_integer(unsigned(Register_Tags_I1(9 DOWNTO 5))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_1_RS1)))(37 DOWNTO 6) & '0' & '1';

                    IF (RRF(to_integer(unsigned(Register_Tags_I1(9 DOWNTO 5))))(1) = '0') THEN
                        I1_Side_S <= '1' & ARF(to_integer(unsigned(Inst_1_RS1)))(37 DOWNTO 6);
                        I1_Valid_S <= '0';
                    ELSE
                        I1_Side_S <= '1' & std_logic_vector(to_unsigned(0, ((2**Size_RRF)-5))) & Register_Tags_I1(9 DOWNTO 5);
                        I1_Valid_S <= '1';
                    END IF;
                ELSE
                    I1_Side_S <= (OTHERS => '0');
                    I1_Valid_S <= '0';
                END IF;

                IF (Inst_1_Control(0) = '1') THEN -- Instruction_1 uses RS2
                    ARF(to_integer(unsigned(Inst_1_RS2)))(5 DOWNTO 0) <= '1' & Register_Tags_I1(4 DOWNTO 0);
                    RRF(to_integer(unsigned(Register_Tags_I1(4 DOWNTO 0))))(33 DOWNTO 0) <= ARF(to_integer(unsigned(Inst_1_RS2)))(37 DOWNTO 6) & '0' & '1';

                    IF (RRF(to_integer(unsigned(Register_Tags_I1(4 DOWNTO 0))))(1) = '0') THEN
                        I1_Side_T <= '1' & ARF(to_integer(unsigned(Inst_1_RS2)))(37 DOWNTO 6);
                        I1_Valid_T <= '0';
                    ELSE
                        I1_Side_T <= '1' & std_logic_vector(to_unsigned(0, ((2**Size_RRF)-5))) & Register_Tags_I1(4 DOWNTO 0);
                        I1_Valid_T <= '0';
                    END IF;
                ELSE
                    I1_Side_T <= (OTHERS => '0');
                    I1_Valid_T <= '0';
                END IF;
            END IF;

            
            IF (Instruction_2 /= "00000000000000000000000000000000") THEN
            END IF;


            IF (Instruction_3 /= "00000000000000000000000000000000") THEN
            END IF;

        END IF;

    END PROCESS;



    Inst_0_Read_RRF_From_Reservation_Station : PROCESS (Inst_0_Read_On_RRF)
    BEGIN
        -- Send the RRF_DATA of Side S only if RRF_VALID = 1
        -- MSB '1' (acts as validation bit of the signal) & RRF_TAG & RRF_DATA
        IF (RRF(to_integer(unsigned(Inst_0_Read_On_RRF(9 DOWNTO 5))))(1) = '1') THEN
            Inst_0_Data_From_RRF_S <= '1' & Inst_0_Read_On_RRF(9 DOWNTO 5) & RRF(to_integer(unsigned(Inst_0_Read_On_RRF(9 DOWNTO 5))))(33 DOWNTO 2);
        ELSE
            Inst_0_Data_From_RRF_S <= (OTHERS => '0');
        END IF;

        -- Send the RRF_DATA of Side T only if RRF_VALID = 1
        --  MSB '1' (acts as validation bit of the signal) & RRF_TAG & RRF_DATA
        IF (RRF(to_integer(unsigned(Inst_0_Read_On_RRF(4 DOWNTO 0))))(1) = '1') THEN
            Inst_0_Data_From_RRF_T <= '1' & Inst_0_Read_On_RRF(4 DOWNTO 0) & RRF(to_integer(unsigned(Inst_0_Read_On_RRF(4 DOWNTO 0))))(33 DOWNTO 2);
        ELSE
            Inst_0_Data_From_RRF_T <= (OTHERS => '0');
        END IF;
    END PROCESS;


    Inst_1_Read_RRF_From_Reservation_Station : PROCESS (Inst_1_Read_On_RRF)
    BEGIN
        IF (RRF(to_integer(unsigned(Inst_1_Read_On_RRF(9 DOWNTO 5))))(1) = '1') THEN
            Inst_1_Data_From_RRF_S <= '1' & Inst_1_Read_On_RRF(9 DOWNTO 5) & RRF(to_integer(unsigned(Inst_1_Read_On_RRF(9 DOWNTO 5))))(33 DOWNTO 2);
        ELSE
            Inst_1_Data_From_RRF_S <= (OTHERS => '0');
        END IF;

        IF (RRF(to_integer(unsigned(Inst_1_Read_On_RRF(4 DOWNTO 0))))(1) = '1') THEN
            Inst_1_Data_From_RRF_T <= '1' & Inst_1_Read_On_RRF(4 DOWNTO 0) & RRF(to_integer(unsigned(Inst_1_Read_On_RRF(4 DOWNTO 0))))(33 DOWNTO 2);
        ELSE
            Inst_1_Data_From_RRF_T <= (OTHERS => '0');
        END IF;
    END PROCESS;


    Inst_2_Read_RRF_From_Reservation_Station : PROCESS (Inst_2_Read_On_RRF)
    BEGIN
        IF (RRF(to_integer(unsigned(Inst_2_Read_On_RRF(9 DOWNTO 5))))(1) = '1') THEN
            Inst_2_Data_From_RRF_S <= '1' & Inst_2_Read_On_RRF(9 DOWNTO 5) & RRF(to_integer(unsigned(Inst_2_Read_On_RRF(9 DOWNTO 5))))(33 DOWNTO 2);
        ELSE
            Inst_2_Data_From_RRF_S <= (OTHERS => '0');
        END IF;

        IF (RRF(to_integer(unsigned(Inst_2_Read_On_RRF(4 DOWNTO 0))))(1) = '1') THEN
            Inst_2_Data_From_RRF_T <= '1' & Inst_2_Read_On_RRF(4 DOWNTO 0) & RRF(to_integer(unsigned(Inst_2_Read_On_RRF(4 DOWNTO 0))))(33 DOWNTO 2);
        ELSE
            Inst_2_Data_From_RRF_T <= (OTHERS => '0');
        END IF;
    END PROCESS;


    Inst_3_Read_RRF_From_Reservation_Station : PROCESS (Inst_3_Read_On_RRF)
    BEGIN
        IF (RRF(to_integer(unsigned(Inst_3_Read_On_RRF(9 DOWNTO 5))))(1) = '1') THEN
            Inst_3_Data_From_RRF_S <= '1' & Inst_3_Read_On_RRF(9 DOWNTO 5) & RRF(to_integer(unsigned(Inst_3_Read_On_RRF(9 DOWNTO 5))))(33 DOWNTO 2);
        ELSE
            Inst_3_Data_From_RRF_S <= (OTHERS => '0');
        END IF;

        IF (RRF(to_integer(unsigned(Inst_3_Read_On_RRF(4 DOWNTO 0))))(1) = '1') THEN
            Inst_3_Data_From_RRF_T <= '1' & Inst_3_Read_On_RRF(4 DOWNTO 0) & RRF(to_integer(unsigned(Inst_3_Read_On_RRF(4 DOWNTO 0))))(33 DOWNTO 2);
        ELSE
            Inst_3_Data_From_RRF_T <= (OTHERS => '0');
        END IF;
    END PROCESS;


END ARCHITECTURE behavioral;