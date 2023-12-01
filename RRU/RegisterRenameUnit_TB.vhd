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
    
            IC_0                : IN UNSIGNED(0 TO 32);                                     -- Instruction_Counter de Inst_0
            Instruction_0       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Write_RRF_0    : IN STD_LOGIC_VECTOR(37 DOWNTO 0);                         -- OPERATION(37), TAG(36 DOWNTO 32) e DATA(31 DOWNTO 0)
            Inst_Side_S_0       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_S(37), TAG_S(36 DOWNTO 32) e DATA_S(31 DOWNTO 0)
            Inst_Side_T_0       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_T(37), TAG_T(36 DOWNTO 32) e DATA_T(31 DOWNTO 0)
            Inst_Tag_RRF_Dest_0 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- TAG_RRF de RD de Inst_0
            RRF_Data_Out_0      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0);                        -- RRF_TAG_LIDA(36 DOWNTO 32) e RRF_DATA_LIDO(31 DOWNTO 0)
    
            IC_1                : IN UNSIGNED(0 TO 32);                                     -- Instruction_Counter de Inst_1
            Instruction_1       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Write_RRF_1    : IN STD_LOGIC_VECTOR(37 DOWNTO 0);                         -- OPERATION(37), TAG(36 DOWNTO 32) e DATA(31 DOWNTO 0)
            Inst_Side_S_1       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_S(37), TAG_S(36 DOWNTO 32) e DATA_S(31 DOWNTO 0)
            Inst_Side_T_1       : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_T(37), TAG_T(36 DOWNTO 32) e DATA_T(31 DOWNTO 0)
            Inst_Tag_RRF_Dest_1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);                         -- TAG_RRF de RD de Inst_1
            RRF_Data_Out_1      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0);                        -- RRF_TAG_LIDA(36 DOWNTO 32) e RRF_DATA_LIDO(31 DOWNTO 0)
    
            Commit_Reorder_Buffer : IN STD_LOGIC_VECTOR(32 DOWNTO 0)
        );
    END COMPONENT RegisterRenameUnit;

    CONSTANT number_inst                                  : INTEGER := 2;
    CONSTANT size_rrf                                     : INTEGER := 5;
    CONSTANT clock_period                                 : TIME := 2000 ps;

    SIGNAL clock_tb                                       : STD_LOGIC := '0';
    SIGNAL reset_tb                                       : STD_LOGIC := '0';

    SIGNAL ic_0_tb, ic_1_tb                               : UNSIGNED(0 TO 32) := (OTHERS => '0');
    SIGNAL inst_0_tb, inst_1_tb                           : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    SIGNAL inst_side_s_0_tb, inst_side_s_1_tb             : STD_LOGIC_VECTOR(((1 + size_rrf + 32) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL inst_side_t_0_tb, inst_side_t_1_tb             : STD_LOGIC_VECTOR(((1 + size_rrf + 32) - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL inst_tag_rrf_dest_0_tb, inst_tag_rrf_dest_1_tb : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');

    SIGNAL read_write_rrf_0_tb, read_write_rrf_1_tb       : STD_LOGIC_VECTOR(37 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rrf_data_out_0_tb, rrf_data_out_1_tb           : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');

    SIGNAL commit                                         : STD_LOGIC_VECTOR(32 DOWNTO 0) := (OTHERS => '0');

BEGIN

    clks : PROCESS
    BEGIN
        WAIT FOR clock_period/2;
        clock_tb <= NOT clock_tb;
        ASSERT NOW < 30 ns REPORT "Fim" SEVERITY FAILURE;
    END PROCESS;

    RRU : RegisterRenameUnit
    GENERIC MAP(
        Size_RRF => size_rrf
    ) 
    PORT MAP(
        Clk => clock_tb,
        Reset => reset_tb,

        IC_0 => ic_0_tb, 
        Instruction_0 => inst_0_tb,
        Read_Write_RRF_0 => read_write_rrf_0_tb,
        Inst_Side_S_0 => inst_side_s_0_tb,
        Inst_Side_T_0 => inst_side_t_0_tb,
        Inst_Tag_RRF_Dest_0 => inst_tag_rrf_dest_0_tb,
        RRF_Data_Out_0 => rrf_data_out_0_tb,

        IC_1 => ic_1_tb, 
        Instruction_1 => inst_1_tb,
        Read_Write_RRF_1 => read_write_rrf_1_tb,
        Inst_Side_S_1 => inst_side_s_1_tb,
        Inst_Side_T_1 => inst_side_t_1_tb,
        Inst_Tag_RRF_Dest_1 => inst_tag_rrf_dest_1_tb,
        RRF_Data_Out_1 => rrf_data_out_1_tb,

        Commit_Reorder_Buffer => commit
    );

    exec: PROCESS
    BEGIN

        --                                                 Instante 1                                                 --
        --                           Teste: execucao de duas instrucoes em ordem (fluxo principal)
        -- Instrucao 1) add x5 x14 x26
        -- x5 <= x26 + x14
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_0:   0
        --          Inst_0: 00000000111011010000001010110011
        --                      funct7: 0000000
        --                      rs2:    01110   (x14)
        --                      rs1:    11010   (x26)
        --                      funct3: 000
        --                      rd:     00101   (x5)
        --                      codop:  0110011 (tipo R)
        -- Outputs esperados:
        --          Inst_Side_S_0: 00000000000000000000000000000000000000
        --                      Inst_Side_S_0(37):           0 (use o ARF_DATA)
        --                      Inst_Side_S_0(36 DOWNTO 32): 00000 (0 = RRF(0) = renome do x26)
        --                      Inst_Side_S_0(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x26)
        --
        --          Inst_Side_T_0: 00000100000000000000000000000000000000
        --                      Inst_Side_T_0(37):           0 (use o ARF_DATA)
        --                      Inst_Side_T_0(36 DOWNTO 32): 00001 (1 = RRF(1) = renome do x14)
        --                      Inst_Side_T_0(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x14)
        --
        --          Inst_Tag_RRF_Dest_0: 00010
        --                      Inst_Tag_RRF_Dest_0: (2 = RRF(2) = renome do x5)
        --
        --
        -- Instrucao 2) mult x8 x18 x31
        -- x8 <= x18 * x31
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_1:   1
        --          Inst_1: 00000011111110010000010000110011
        --                      funct7: 0000001
        --                      rs2:    11111   (x31)
        --                      rs1:    10010   (x18)
        --                      funct3: 000
        --                      rd:     01000   (x8)
        --                      codop:  0110011 (tipo R)
        --
        -- Outputs esperados:
        --          Inst_Side_S_1: 00001100000000000000000000000000000000
        --                      Inst_Side_S_1(37):           0 (use o ARF_DATA)
        --                      Inst_Side_S_1(36 DOWNTO 32): 00011 (3 = RRF(3) = renome do x31)
        --                      Inst_Side_S_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x31)
        --
        --          Inst_Side_T_1: 00010000000000000000000000000000000000
        --                      Inst_Side_T_1(37):           0 (use o ARF_DATA)
        --                      Inst_Side_T_1(36 DOWNTO 32): 00100 (4 = RRF(4) = renome do x18)
        --                      Inst_Side_T_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x18)
        --
        --          Inst_Tag_RRF_Dest_1: 00101
        --                      Inst_Tag_RRF_Dest_1: (5 = RRF(5) = renome do x8)
        ic_0_tb <= to_unsigned(0, 33);
        inst_0_tb <= "00000000111011010000001010110011";
        ic_1_tb <= to_unsigned(1, 33);
        inst_1_tb <= "00000011111110010000010000110011";
        WAIT FOR 5 ns;

        ASSERT (inst_side_s_0_tb /= "00000000000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_S_0 correto!" SEVERITY NOTE;
        ASSERT (inst_side_t_0_tb /= "00000100000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_T_0 correto!" SEVERITY NOTE;
        ASSERT (inst_tag_rrf_dest_0_tb /= "00010") REPORT "Instante 1 - Inst_Tag_RRF_Dest_0 correto!" SEVERITY NOTE;

        ASSERT (inst_side_s_1_tb /= "00001100000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_S_1 correto!" SEVERITY NOTE;
        ASSERT (inst_side_t_1_tb /= "00010000000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_T_1 correto!" SEVERITY NOTE;
        ASSERT (inst_tag_rrf_dest_1_tb /= "00101") REPORT "Instante 1 - Inst_Tag_RRF_Dest_1 correto!" SEVERITY NOTE;



        --                                                 Instante 2                                                 --
        --                                   Teste: permutabilidade das instrucoes
        -- Instrucao 4) xor x20 x14 x7
        -- x20 <= x14 xor x7
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_0:   3
        --          Inst_0: 00000000011101110100101000110011
        --                      funct7: 0000000
        --                      rs2:    00111   (x7)
        --                      rs1:    01110   (x14)
        --                      funct3: 100
        --                      rd:     10100   (x20)
        --                      codop:  0110011 (tipo R)
        -- Outputs esperados:
        --          Inst_Side_S_0: 00100100000000000000000000000000000000
        --                      Inst_Side_S_0(37):           0 (use o ARF_DATA)
        --                      Inst_Side_S_0(36 DOWNTO 32): 01001 (9 = RRF(9) = renome do x7)
        --                      Inst_Side_S_0(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x7)
        --
        --          Inst_Side_T_0: 00101000000000000000000000000000000000
        --                      Inst_Side_T_0(37):           0 (use o ARF_DATA)
        --                      Inst_Side_T_0(36 DOWNTO 32): 01010 (10 = RRF(10) = renome do x14)
        --                      Inst_Side_T_0(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x14)
        --
        --          Inst_Tag_RRF_Dest_0: 01011
        --                      Inst_Tag_RRF_Dest_0: (11 = RRF(11) = renome do x20)
        --
        -- Instrucao 3) sub x16 x3 x1
        -- x16 <= x3 - x1
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_1:   2
        --          Inst_1: 01000000000100011000100000110011
        --                      funct7: 0100000
        --                      rs2:    00001   (x1)
        --                      rs1:    00011   (x3)
        --                      funct3: 000
        --                      rd:     10000   (x16)
        --                      codop:  0110011 (tipo R)
        -- Outputs esperados:
        --          Inst_Side_S_1: 00011000000000000000000000000000000000
        --                      Inst_Side_S_1(37):           0 (use o ARF_DATA)
        --                      Inst_Side_S_1(36 DOWNTO 32): 00110 (6 = RRF(6) = renome do x1)
        --                      Inst_Side_S_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x1)
        --
        --          Inst_Side_T_1: 00011100000000000000000000000000000000
        --                      Inst_Side_T_1(37):           0 (use o ARF_DATA)
        --                      Inst_Side_T_1(36 DOWNTO 32): 00111 (7 = RRF(7) = renome do x3)
        --                      Inst_Side_T_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do x3)
        --
        --          Inst_Tag_RRF_Dest_1: 01000
        --                      Inst_Tag_RRF_Dest_1: (8 = RRF(8) = renome do x16)
        ic_1_tb <= to_unsigned(2, 33);
        inst_1_tb <= "00000000011101110100101000110011";
        ic_0_tb <= to_unsigned(3, 33);
        inst_0_tb <= "01000000000100011000100000110011";
        WAIT FOR 5 ns;

        ASSERT (inst_side_s_0_tb /= "00100100000000000000000000000000000000") REPORT "Instante 2 - Inst_Side_S_0 correto!" SEVERITY NOTE;
        ASSERT (inst_side_t_0_tb /= "00101000000000000000000000000000000000") REPORT "Instante 2 - Inst_Side_T_0 correto!" SEVERITY NOTE;
        ASSERT (inst_tag_rrf_dest_0_tb /= "01011") REPORT "Instante 2 - Inst_Tag_RRF_Dest_0 correto!" SEVERITY NOTE;

        ASSERT (inst_side_s_1_tb /= "00011000000000000000000000000000000000") REPORT "Instante 2 - Inst_Side_S_1 correto!" SEVERITY NOTE;
        ASSERT (inst_side_t_1_tb /= "00011100000000000000000000000000000000") REPORT "Instante 2 - Inst_Side_T_1 correto!" SEVERITY NOTE;
        ASSERT (inst_tag_rrf_dest_1_tb /= "01000") REPORT "Instante 2 - Inst_Tag_RRF_Dest_1 correto!" SEVERITY NOTE;



        --                                                 Instante 3                                                 --
        --                               Teste: recebimento de instrucao fora da ordem
        -- Instrucao 9) add x5 x14 x26
        -- x5 <= x26 + x14
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_0:   8
        --          Inst_0: 00000000111011010000001010110011
        --                      funct7: 0000000
        --                      rs2:    01110   (x14)
        --                      rs1:    11010   (x26)
        --                      funct3: 000
        --                      rd:     00101   (x5)
        --                      codop:  0110011 (tipo R)
        -- Outputs esperados:
        --          Inst_Side_S_0: mesmo do Instante 2
        --          Inst_Side_T_0: mesmo do Instante 2
        --          Inst_Tag_RRF_Dest_0: mesmo do Instante 2
        ic_0_tb <= to_unsigned(8, 33);
        inst_0_tb <= "01000000000100011000100000110011";
        WAIT FOR 5 ns;

        ASSERT (inst_side_s_0_tb /= "00100100000000000000000000000000000000") REPORT "Instante 3 - Inst_Side_S_0 correto!" SEVERITY NOTE;
        ASSERT (inst_side_t_0_tb /= "00101000000000000000000000000000000000") REPORT "Instante 3 - Inst_Side_T_0 correto!" SEVERITY NOTE;
        ASSERT (inst_tag_rrf_dest_0_tb /= "01011") REPORT "Instante 3 - Inst_Tag_RRF_Dest_0 correto!" SEVERITY NOTE;



        --                                                 Instante 4                                                 --
        --                              Teste: escrita na RRF vindo da Reservation Station
        -- Inputs:
        --          Read_Write_RRF_0_TB:   10000100000111111111111111111111100000
        --              Read_Write_RRF_0_TB(37):             1 (Operacao de escrita na RRF)
        --              Read_Write_RRF_0_TB(36 DOWNTO 32):   00001 (1 = RRF(1) = renome do x14)
        --              Read_Write_RRF_0_TB(31 DOWNTO 0):    00000111111111111111111111100000 (134217696 = resultado de alguma operacao na RS = novo RRF_DATA)
        --
        --          Read_Write_RRF_0_TB:   00000100000000000000000000000000000000
        --              Read_Write_RRF_0_TB(37):             0 (Operacao de leitura da RRF)
        --              Read_Write_RRF_0_TB(36 DOWNTO 32):   00001 (1 = RRF(1) = renome do x14)
        --              Read_Write_RRF_0_TB(31 DOWNTO 0):    nao usado/nao levado em conta na operacao de leitura
        --
        -- Outputs esperados:
        --          RRF_Data_Out_0_TB: 0000100000111111111111111111111100000
        --              RRF_Data_Out_0_TB(36 DOWNTO 32): 00001 (1 = RRF(1) = RRF_TAG onde foi realizada a escrita)
        --              RRF_Data_Out_0_TB(31 DOWNTO 0):  00000111111111111111111111100000 (134217696 = RRF_DATA = dado lido da RRF_TAG na RRF)
        read_write_rrf_0_tb <= "10000100000111111111111111111111100000";
        WAIT FOR 5 ns;
        read_write_rrf_0_tb <= "00000100000000000000000000000000000000";
        WAIT FOR 5 ns;

        ASSERT (rrf_data_out_0_tb /= "0000100000111111111111111111111100000") REPORT "Instante 4 - RRF_Data_Out_0 correto!" SEVERITY NOTE;



        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;