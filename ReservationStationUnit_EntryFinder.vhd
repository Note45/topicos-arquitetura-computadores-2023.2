LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ReservationStationUnit_EntryFinder IS
    PORT(
        Busy_Vector         :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        Inst_0_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_1_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_2_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_3_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY ReservationStationUnit_EntryFinder;

ARCHITECTURE behavior OF ReservationStationUnit_EntryFinder IS
BEGIN

    -- Identifies the index of first available entry on the Reservation Station
    -- based on it's Busy bit vector

    Inst_0_Allocation : PROCESS (Busy_Vector)
    BEGIN
        IF (Busy_Vector(0) = '0') THEN
            Inst_0_Entry <= "000";
        ELSIF (Busy_Vector(1) = '0') THEN
            Inst_0_Entry <= "001";
        ELSIF (Busy_Vector(2) = '0') THEN
            Inst_0_Entry <= "010";
        ELSIF (Busy_Vector(3) = '0') THEN
            Inst_0_Entry <= "011";
        ELSE
            Inst_0_Entry <= "100";
        END IF;
    END PROCESS;

    Inst_1_Allocation : PROCESS (Busy_Vector)
    BEGIN
        IF (Busy_Vector(1) = '0') THEN
            Inst_1_Entry <= "001";
        ELSIF (Busy_Vector(2) = '0') THEN
            Inst_1_Entry <= "010";
        ELSIF (Busy_Vector(3) = '0') THEN
            Inst_1_Entry <= "011";
        ELSIF (Busy_Vector(0) = '0') THEN
            Inst_1_Entry <= "000";
        ELSE
            Inst_1_Entry <= "100";
        END IF;
    END PROCESS;

    Inst_2_Allocation : PROCESS (Busy_Vector)
    BEGIN
        IF (Busy_Vector(2) = '0') THEN
            Inst_2_Entry <= "010";
        ELSIF (Busy_Vector(3) = '0') THEN
            Inst_2_Entry <= "011";
        ELSIF (Busy_Vector(0) = '0') THEN
            Inst_2_Entry <= "000";
        ELSIF (Busy_Vector(1) = '0') THEN
            Inst_2_Entry <= "001";
        ELSE
            Inst_2_Entry <= "100";
        END IF;
    END PROCESS;

    Inst_3_Allocation : PROCESS (Busy_Vector)
    BEGIN
        IF (Busy_Vector(3) = '0') THEN
            Inst_3_Entry <= "011";
        ELSIF (Busy_Vector(0) = '0') THEN
            Inst_3_Entry <= "000";
        ELSIF (Busy_Vector(1) = '0') THEN
            Inst_3_Entry <= "001";
        ELSIF (Busy_Vector(2) = '0') THEN
            Inst_3_Entry <= "010";
        ELSE
            Inst_3_Entry <= "100";
        END IF;
    END PROCESS;

END ARCHITECTURE behavior;