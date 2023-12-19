-- interge unit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity IU is
    port (
        rs1_data : in std_logic_vector (31 downto 0);
        rs2_data : in std_logic_vector (31 downto 0);
        funct3 : in std_logic_vector (2 downto 0);
        funct7 : in std_logic_vector (6 downto 0);
        result: out std_logic_vector (31 downto 0)
      );
end IU;

architecture archIU of IU is
    begin
        with funct7 & funct3 select result <= 
            rs1_data + rs1_data when "0000000000", -- ADD
            rs1_data + rs1_data when "0100000000", -- SUB
            rs1_data * rs1_data when "0000001000", -- MUL
            rs1_data * rs1_data when "0000001001", -- MULH
            rs1_data * rs1_data when "0000001010", -- MULHSU
            rs1_data * rs1_data when "0000001011", -- MULHU
            rs1_data / rs1_data when "0000001100", -- DIV
            rs1_data / rs1_data when "0000001101", -- DIVU
            rs1_data % rs1_data when "0000001110", -- REM
            '00000000000000000000000000000000'     when others;

end architecture ; -- archIU