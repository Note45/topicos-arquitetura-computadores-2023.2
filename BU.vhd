-- branch unit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity BU is
    port (
        rs1_data : in std_logic_vector (31 downto 0);
        rs2_data : in std_logic_vector (31 downto 0);
        pc : in std_logic_vector (31 downto 0);
        imm : in std_logic_vector (31 downto 0);
        funct : in std_logic_vector (2 downto 0);
        address: out std_logic_vector (31 downto 0);
        branch: out std_logic);
end BU;

architecture arch of BU is
    signal result: std_logic_vector (31 downto 0);
    signal z, n: std_logic;

    begin
        result <= rs1_data - rs2_data;
        address <= pc + imm;
        --
        z <= '1' when result="00000000000000000000000000000000" else '0';
        n <= result(31);

        with funct select branch <= 
            z       when "000", -- BEQ
            (not z) when "001", -- BNE
            n       when "100", -- BLT
            (not n) when "101", -- BGE
            n       when "110", -- BLTU
            (not n) when "111", -- BGEU
            '0'     when others;

end architecture ; -- arch