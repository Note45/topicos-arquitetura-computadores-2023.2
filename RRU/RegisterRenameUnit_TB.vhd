LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

ENTITY RegisterRenameUnit_TB IS
END ENTITY RegisterRenameUnit_TB;

ARCHITECTURE testbench OF RegisterRenameUnit_TB IS

    COMPONENT RegisterRenameUnit IS
        GENERIC (
            Size_RRF : integer := 5                 -- RRF possui (2**Size_RRF) entradas
        );

        PORT (
            Clk                 : IN STD_LOGIC;
            Reset               : IN STD_LOGIC;
    
            IC_0                : IN UNSIGNED(0 TO 32);
            Instruction_0       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_Side_S_0       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_S(37), TAG_S(36 DOWNTO 32) e DATA_S(31 DOWNTO 0)
            Inst_Side_T_0       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_T(37), TAG_T(36 DOWNTO 32) e DATA_T(31 DOWNTO 0)
            Inst_Tag_RRF_Dest_0 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    
            IC_1                : IN UNSIGNED(0 TO 32);
            Instruction_1       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_Side_S_1       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_S(37), TAG_S(36 DOWNTO 32) e DATA_S(31 DOWNTO 0)
            Inst_Side_T_1       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_T(37), TAG_T(36 DOWNTO 32) e DATA_T(31 DOWNTO 0)
            Inst_Tag_RRF_Dest_1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    
            Read_Write_RRF      : IN STD_LOGIC_VECTOR(37 DOWNTO 0); -- OPERATION(37), TAG(36 DOWNTO 32) e DATA(31 DOWNTO 0)
            RRF_Data_Out        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Tag lida (36 DOWNTO 32) e Dado lido (31 DOWNTO 0)
    
            Commit_Reorder_Buffer : IN STD_LOGIC_VECTOR(32 DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit;

    CONSTANT number_inst : integer := 2;
    CONSTANT size_rrf : integer := 5;
    CONSTANT clock_period : time := 2000 ps;

    SIGNAL clock_tb : std_logic := '0';
    SIGNAL reset_tb : std_logic := '0';

    SIGNAL ic_0_tb, ic_1_tb                : UNSIGNED(0 TO 32);
    SIGNAL inst_0_tb, inst_1_tb : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');

    SIGNAL inst_side_s_0_tb, inst_side_s_1_tb : std_logic_vector(((1 + size_rrf + 32) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL inst_side_t_0_tb, inst_side_t_1_tb : std_logic_vector(((1 + size_rrf + 32) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL inst_tag_rrf_dest_0_tb, inst_tag_rrf_dest_1_tb : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');

    SIGNAL read_write_rrf_tb : std_logic_vector(37 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rrf_data_out_tb : std_logic_vector(36 DOWNTO 0) := (OTHERS => '0');

    SIGNAL commit : STD_LOGIC_VECTOR(32 DOWNTO 0) := (others => '0');

BEGIN

--    clock <= NOT clock AFTER clock_period/2;
    clks : process
    begin
        wait for clock_period/2;
        clock_tb <= not clock_tb;
        assert now < 20 ns report "Fim" severity failure;
    end process;

    RRU : RegisterRenameUnit
    GENERIC MAP(
        Size_RRF => size_rrf
    ) 
    PORT MAP(
        Clk => clock_tb,
        Reset => reset_tb,

        IC_0 => ic_0_tb, 
        Instruction_0 => inst_0_tb, 
        Inst_Side_S_0 => inst_side_s_0_tb,
        Inst_Side_T_0 => inst_side_t_0_tb,
        Inst_Tag_RRF_Dest_0 => inst_tag_rrf_dest_0_tb,

        IC_1 => ic_1_tb, 
        Instruction_1 => inst_1_tb,
        Inst_Side_S_1 => inst_side_s_1_tb,
        Inst_Side_T_1 => inst_side_t_1_tb,
        Inst_Tag_RRF_Dest_1 => inst_tag_rrf_dest_1_tb,

        Read_Write_RRF => read_write_rrf_tb,
        RRF_Data_Out => rrf_data_out_tb,

        Commit_Reorder_Buffer => commit
    );

    exec: process
    begin
        read_write_rrf_tb <= "00000000000000000000000000000000000000";

        -- add
        -- funct7 rs2 rs1 funct3 rd codop
        -- 0000000 01110 11010 000 00101 0110011
        -- 5 <= 26 + 14
        -- 00000000111011010000001010110011
        ic_0_tb <= to_unsigned(0, 33);
        inst_0_tb <= "00000000111011010000001010110011";

        -- mult
        -- funct7 rs2 rs1 funct3 rd codop
        -- 0000001 11111 10010 000 01000 0110011
        -- 8 <= 18 * 31
        -- 00000011111110010000010000110011
        ic_1_tb <= to_unsigned(1, 33);
        inst_1_tb <= "00000011111110010000010000110011";
        wait for 5 ns;


        -- xor
        -- funct7 rs2 rs1 funct3 rd codop
        -- 0000000 00111 01110 100 10100 0110011
        -- 20 <= 14 XOR 7
        -- 00000000011101110100101000110011
        ic_1_tb <= to_unsigned(2, 33);
        inst_1_tb <= "00000000011101110100101000110011";

        -- sub
        -- funct7 rs2 rs1 funct3 rd codop
        -- 0100000 00001 00011 000 10000 0110011
        -- 16 <= 3 + 1
        -- 01000000000100011000100000110011
        ic_0_tb <= to_unsigned(3, 33);
        inst_0_tb <= "01000000000100011000100000110011";
        wait for 5 ns;


        -- IC nao esperada pela RRU, nao computa
        --ic_0_tb <= to_unsigned(5, 33);
        --inst_0_tb <= "01000000000100011000100000110011";
        --wait for 5 ns;

        wait;
    end process;

END ARCHITECTURE testbench;