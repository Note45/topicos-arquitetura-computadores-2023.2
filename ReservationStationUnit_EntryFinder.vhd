LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ReservationStationUnit_EntryFinder IS
    PORT(
        Busy_Vector         :  IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- RSU_BUSY(3) & RSU_BUSY(2) & RSU_BUSY(1) & RSU_BUSY(0)

        Inst_0_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
        Inst_1_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_2_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_3_Entry        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY ReservationStationUnit_EntryFinder;

ARCHITECTURE behavior OF ReservationStationUnit_EntryFinder IS
BEGIN

    -- Correlates every upcoming instruction on the RSU with a position on the buffer, and returns the tag
      -- If that position on the buffer is occupied, the tag is "100" (invalid)
      -- Else, the real tag is returned
    -- Based on the RSU_BUSY bit vector
    
    Inst_0_Entry <= "000" WHEN (Busy_Vector(0) = '0') ELSE
                    "100";

    Inst_1_Entry <= "001" WHEN (Busy_Vector(1) = '0') ELSE
                    "100";

    Inst_2_Entry <= "010" WHEN (Busy_Vector(2) = '0') ELSE
                    "100";

    Inst_3_Entry <= "011" WHEN (Busy_Vector(3) = '0') ELSE
                    "100";

END ARCHITECTURE behavior;