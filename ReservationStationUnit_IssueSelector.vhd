LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ReservationStationUnit_IssueSelector IS
    PORT(
        Ready_Vector            :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        RSU_Entry_0             :  IN STD_LOGIC_VECTOR(75 DOWNTO 0);
        RSU_Entry_1             :  IN STD_LOGIC_VECTOR(75 DOWNTO 0);
        RSU_Entry_2             :  IN STD_LOGIC_VECTOR(75 DOWNTO 0);
        RSU_Entry_3             :  IN STD_LOGIC_VECTOR(75 DOWNTO 0);

        RSU_Entry_Index         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RSU_Entry_Selected      : OUT STD_LOGIC_VECTOR(75 DOWNTO 0)
    );
END ENTITY ReservationStationUnit_IssueSelector;

ARCHITECTURE behavior OF ReservationStationUnit_IssueSelector IS
BEGIN

    -- Returns the first ready entry on RSU, which is represented by the first set bit on the Ready_Vector
    WITH Ready_Vector SELECT 
    RSU_Entry_Selected <= RSU_Entry_0 WHEN "0001" | "0011" | "0101" | "0111" | "1001" | "1011" | "1101" | "1111",
                          RSU_Entry_1 WHEN "0010" | "0110" | "1010" | "1110",
                          RSU_Entry_2 WHEN "0100" | "1100",
                          RSU_Entry_3 WHEN "1000",
                          (OTHERS => '0') WHEN OTHERS;

    -- Returns the index of the first ready entry, which is represented by the first set bit on the Ready_Vector
    WITH Ready_Vector SELECT 
    RSU_Entry_Index <= "00" WHEN "0001" | "0011" | "0101" | "0111" | "1001" | "1011" | "1101" | "1111",
                       "01" WHEN "0010" | "0110" | "1010" | "1110",
                       "10" WHEN "0100" | "1100",
                       "11" WHEN "1000",
                       (OTHERS => '0') WHEN OTHERS;

END ARCHITECTURE behavior;