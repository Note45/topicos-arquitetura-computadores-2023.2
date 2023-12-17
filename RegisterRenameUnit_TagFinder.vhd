LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterRenameUnit_TagFinder IS
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
END ENTITY RegisterRenameUnit_TagFinder;

ARCHITECTURE busca of RegisterRenameUnit_TagFinder IS

    SIGNAL Tags_I0 : STD_LOGIC_VECTOR(14 DOWNTO 0) := (OTHERS => '1');   -- Three tags concatenated, one for each possible register of the instruction 
    SIGNAL Tags_I1 : STD_LOGIC_VECTOR(14 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Tags_I2 : STD_LOGIC_VECTOR(14 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Tags_I3 : STD_LOGIC_VECTOR(14 DOWNTO 0) := (OTHERS => '0');

BEGIN

    Three_Tags_Inst_0 <= Tags_I0;
    Three_Tags_Inst_1 <= Tags_I1;
    Three_Tags_Inst_2 <= Tags_I2;
    Three_Tags_Inst_3 <= Tags_I3;

    TagFinder_Inst_0 : PROCESS (RRF_Busy_Vector_Slice_0)
    BEGIN
        FOR i IN 0 TO RRF_Busy_Vector_Slice_0'HIGH LOOP
            IF (RRF_Busy_Vector_Slice_0(i) = '0') THEN
                Tags_I0(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));

                FOR j IN (i+1) TO RRF_Busy_Vector_Slice_0'HIGH LOOP
                    IF (RRF_Busy_Vector_Slice_0(j) = '0') THEN
                        Tags_I0(9 DOWNTO 5) <= std_logic_vector(to_unsigned(j, 5));

                        FOR k IN (j+1) TO RRF_Busy_Vector_Slice_0'HIGH LOOP
                            IF (RRF_Busy_Vector_Slice_0(k) = '0') THEN
                                Tags_I0(14 DOWNTO 10) <= std_logic_vector(to_unsigned(k, 5));

                                EXIT;
                            END IF;
                        END LOOP;

                        EXIT;
                    END IF;
                END LOOP;

                EXIT;
            END IF;
        END LOOP;
    END PROCESS;


    TagFinder_Inst_1 : PROCESS (RRF_Busy_Vector_Slice_1)
    BEGIN
        FOR i IN 0 TO RRF_Busy_Vector_Slice_1'HIGH LOOP
            IF (RRF_Busy_Vector_Slice_1(i) = '0') THEN
                Tags_I1(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i+8, 5));

                FOR j IN (i+1) TO RRF_Busy_Vector_Slice_1'HIGH LOOP
                    IF (RRF_Busy_Vector_Slice_1(j) = '0') THEN
                        Tags_I1(9 DOWNTO 5) <= std_logic_vector(to_unsigned(j+8, 5));

                        FOR k IN (j+1) TO RRF_Busy_Vector_Slice_1'HIGH LOOP
                            IF (RRF_Busy_Vector_Slice_1(k) = '0') THEN
                                Tags_I1(14 DOWNTO 10) <= std_logic_vector(to_unsigned(k+8, 5));

                                EXIT;
                            END IF;
                        END LOOP;

                        EXIT;
                    END IF;
                END LOOP;

                EXIT;
            END IF;
        END LOOP;
    END PROCESS;


END ARCHITECTURE busca;