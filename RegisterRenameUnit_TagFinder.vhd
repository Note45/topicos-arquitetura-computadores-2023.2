LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterRenameUnit_TagFinder IS
    PORT(
        RRF_Busy_Vector_Slice_0     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        RRF_Busy_Vector_Slice_1     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        RRF_Busy_Vector_Slice_2     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        RRF_Busy_Vector_Slice_3     :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);

        Inst_0_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);                     -- IS_VALID(5) & RRF_TAG(4 DOWNTO 0)
        Inst_1_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        Inst_2_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        Inst_3_RRF_Tag_RD           : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY RegisterRenameUnit_TagFinder;

ARCHITECTURE busca of RegisterRenameUnit_TagFinder IS

    SIGNAL RRF_Tag_RD_0 : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RRF_Tag_RD_1 : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RRF_Tag_RD_2 : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RRF_Tag_RD_3 : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');

BEGIN

    Inst_0_RRF_Tag_RD <= RRF_Tag_RD_0;
    Inst_1_RRF_Tag_RD <= RRF_Tag_RD_1;
    Inst_2_RRF_Tag_RD <= RRF_Tag_RD_2;
    Inst_3_RRF_Tag_RD <= RRF_Tag_RD_3;

    TagFinder_Inst_0 : PROCESS (RRF_Busy_Vector_Slice_0)
    BEGIN
        IF (RRF_Busy_Vector_Slice_0(0) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00000";

        ELSIF (RRF_Busy_Vector_Slice_0(1) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00001";

        ELSIF (RRF_Busy_Vector_Slice_0(2) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00010";

        ELSIF (RRF_Busy_Vector_Slice_0(3) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00011";

        ELSIF (RRF_Busy_Vector_Slice_0(4) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00100";

        ELSIF (RRF_Busy_Vector_Slice_0(5) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00101";

        ELSIF (RRF_Busy_Vector_Slice_0(6) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00110";

        ELSIF (RRF_Busy_Vector_Slice_0(7) = '0') THEN
            RRF_Tag_RD_0(5) <= '0';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00111";

        ELSE
            RRF_Tag_RD_0(5) <= '1';
            RRF_Tag_RD_0(4 DOWNTO 0) <= "00000";
        END IF;
    END PROCESS;


    TagFinder_Inst_1 : PROCESS (RRF_Busy_Vector_Slice_1)
    BEGIN
        IF (RRF_Busy_Vector_Slice_1(0) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01000";

        ELSIF (RRF_Busy_Vector_Slice_1(1) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01001";

        ELSIF (RRF_Busy_Vector_Slice_1(2) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01010";

        ELSIF (RRF_Busy_Vector_Slice_1(3) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01011";

        ELSIF (RRF_Busy_Vector_Slice_1(4) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01100";

        ELSIF (RRF_Busy_Vector_Slice_1(5) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01101";

        ELSIF (RRF_Busy_Vector_Slice_1(6) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01110";

        ELSIF (RRF_Busy_Vector_Slice_1(7) = '0') THEN
            RRF_Tag_RD_1(5) <= '0';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "01111";

        ELSE
            RRF_Tag_RD_1(5) <= '1';
            RRF_Tag_RD_1(4 DOWNTO 0) <= "00000";
        END IF;
    END PROCESS;


    TagFinder_Inst_2 : PROCESS (RRF_Busy_Vector_Slice_2)
    BEGIN
        IF (RRF_Busy_Vector_Slice_2(0) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10000";

        ELSIF (RRF_Busy_Vector_Slice_2(1) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10001";

        ELSIF (RRF_Busy_Vector_Slice_2(2) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10010";

        ELSIF (RRF_Busy_Vector_Slice_2(3) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10011";

        ELSIF (RRF_Busy_Vector_Slice_2(4) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10100";

        ELSIF (RRF_Busy_Vector_Slice_2(5) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10101";

        ELSIF (RRF_Busy_Vector_Slice_2(6) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10110";

        ELSIF (RRF_Busy_Vector_Slice_2(7) = '0') THEN
            RRF_Tag_RD_2(5) <= '0';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "10111";

        ELSE
            RRF_Tag_RD_2(5) <= '1';
            RRF_Tag_RD_2(4 DOWNTO 0) <= "00000";
        END IF;
    END PROCESS;


    TagFinder_Inst_3 : PROCESS (RRF_Busy_Vector_Slice_3)
    BEGIN
        IF (RRF_Busy_Vector_Slice_3(0) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11000";

        ELSIF (RRF_Busy_Vector_Slice_3(1) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11001";

        ELSIF (RRF_Busy_Vector_Slice_3(2) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11010";

        ELSIF (RRF_Busy_Vector_Slice_3(3) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11011";

        ELSIF (RRF_Busy_Vector_Slice_3(4) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11100";

        ELSIF (RRF_Busy_Vector_Slice_3(5) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11101";

        ELSIF (RRF_Busy_Vector_Slice_3(6) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11110";

        ELSIF (RRF_Busy_Vector_Slice_3(7) = '0') THEN
            RRF_Tag_RD_3(5) <= '0';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "11111";

        ELSE
            RRF_Tag_RD_3(5) <= '1';
            RRF_Tag_RD_3(4 DOWNTO 0) <= "00000";
        END IF;
    END PROCESS;


END ARCHITECTURE busca;