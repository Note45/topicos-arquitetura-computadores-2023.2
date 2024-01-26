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

    -- Identifies the index of first available entry on the Reservation Station,
    -- based on it's Busy bit vector
    Inst_0_Entry <= "000" WHEN (Busy_Vector(0) = '0') ELSE
                    "001" WHEN (Busy_Vector(1) = '0') ELSE
                    "010" WHEN (Busy_Vector(2) = '0') ELSE
                    "011" WHEN (Busy_Vector(3) = '0') ELSE
                    "100";

    Inst_1_Entry <= "001" WHEN (Busy_Vector(1) = '0') ELSE
                    "010" WHEN (Busy_Vector(2) = '0') ELSE
                    "011" WHEN (Busy_Vector(3) = '0') ELSE
                    "000" WHEN (Busy_Vector(0) = '0') ELSE
                    "100";

    Inst_2_Entry <= "010" WHEN (Busy_Vector(2) = '0') ELSE
                    "011" WHEN (Busy_Vector(3) = '0') ELSE
                    "000" WHEN (Busy_Vector(0) = '0') ELSE
                    "001" WHEN (Busy_Vector(1) = '0') ELSE
                    "100";

    Inst_3_Entry <= "011" WHEN (Busy_Vector(3) = '0') ELSE
                    "000" WHEN (Busy_Vector(0) = '0') ELSE
                    "001" WHEN (Busy_Vector(1) = '0') ELSE
                    "010" WHEN (Busy_Vector(2) = '0') ELSE
                    "100";

END ARCHITECTURE behavior;