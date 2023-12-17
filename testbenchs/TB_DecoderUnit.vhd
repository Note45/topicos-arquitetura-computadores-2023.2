ENTITY TB_DecoderUnit IS
END ENTITY TB_DecoderUnit;

ARCHITECTURE testbench OF TB_DecoderUnit IS
    COMPONENT DecoderUnit IS
        PORT(
            Clock               :  IN STD_LOGIC;
            Instruction_0_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_1_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_0_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_0_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);   -- REGISTERS_USED(2 DOWNTO 0)
            Inst_0_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_0_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_0_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_0_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_1_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_1_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_1_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_1_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_1_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_2_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_2_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_2_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_2_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_2_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            Instruction_3_Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Inst_3_Control      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_Funct7       : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            Inst_3_Funct3       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_3_RD           : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS1          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_RS2          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            Inst_3_Imm          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT DecoderUnit;

    CONSTANT clock_period                                 : TIME := 2000 ps;

    SIGNAL CLOCK_TB : STD_LOGIC := '0';
    SIGNAL INST_0_OUT, INST_1_OUT, INST_2_OUT, INST_3_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_CONTROL, INST_1_CONTROL, INST_2_CONTROL, INST_3_CONTROL : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_FUNCT7, INST_1_FUNCT7, INST_2_FUNCT7, INST_3_FUNCT7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_FUNCT3, INST_1_FUNCT3, INST_2_FUNCT3, INST_3_FUNCT3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RD, INST_1_RD, INST_2_RD, INST_3_RD : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RS1, INST_1_RS1, INST_2_RS1, INST_3_RS1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_RS2, INST_1_RS2, INST_2_RS2, INST_3_RS2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INST_0_IMM, INST_1_IMM, INST_2_IMM, INST_3_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

BEGIN

    clks : PROCESS
    BEGIN
        WAIT FOR clock_period/2;
        clock_tb <= NOT clock_tb;
        ASSERT NOW < 50 ns REPORT "Fim" SEVERITY FAILURE;
    END PROCESS;

    Decoder : DecoderUnit PORT MAP(
        Clock => Clock, 
        Instruction_0_In => Instruction_0, 
        Instruction_1_In => Instruction_1,
        Instruction_0_Out => INST_0_OUT,
        Inst_0_Funct7 => INST_0_FUNCT7,
        Inst_0_Funct3 => INST_0_FUNCT3,
        Inst_0_RD => INST_0_RD,
        Inst_0_RS1 => INST_0_RS1,
        Inst_0_RS2 => INST_0_RS2,
        Inst_0_Imm => INST_0_IMM,
        Instruction_1_Out => INST_1_OUT,
        Inst_1_Funct7 => INST_1_FUNCT7,
        Inst_1_Funct3 => INST_1_FUNCT3,
        Inst_1_RD => INST_1_RD,
        Inst_1_RS1 => INST_1_RS1,
        Inst_1_RS2 => INST_1_RS2,
        Inst_1_Imm => INST_1_IMM,
        Instruction_2_Out => INST_2_OUT,
        Inst_2_Funct7 => INST_2_FUNCT7,
        Inst_2_Funct3 => INST_2_FUNCT3,
        Inst_2_RD => INST_2_RD,
        Inst_2_RS1 => INST_2_RS1,
        Inst_2_RS2 => INST_2_RS2,
        Inst_2_Imm => INST_2_IMM,
        Instruction_3_Out => INST_3_OUT,
        Inst_3_Funct7 => INST_3_FUNCT7,
        Inst_3_Funct3 => INST_3_FUNCT3,
        Inst_3_RD => INST_3_RD,
        Inst_3_RS1 => INST_3_RS1,
        Inst_3_RS2 => INST_3_RS2,
        Inst_3_Imm => INST_3_IMM
    );

    exec: PROCESS
    BEGIN

        --                                                 Instante 1                                                 --
        --                       Teste: execucao de duas instrucoes tipo R em ordem (fluxo principal)
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
        inst_0_tb <= "00000000111011010000001010110011";
        inst_1_tb <= "00000011111110010000010000110011";
        WAIT FOR 10 ns;

        --ASSERT (inst_side_s_0_tb = "00000000000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_S_0 incorreto!" SEVERITY FAILURE;
        --ASSERT (inst_side_t_0_tb = "00000100000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_T_0 incorreto!" SEVERITY FAILURE;
        --ASSERT (inst_tag_rrf_dest_0_tb = "00010") REPORT "Instante 1 - Inst_Tag_RRF_Dest_0 incorreto!" SEVERITY FAILURE;

        --ASSERT (inst_side_s_1_tb = "00001100000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_S_1 incorreto!" SEVERITY FAILURE;
        --ASSERT (inst_side_t_1_tb = "00010000000000000000000000000000000000") REPORT "Instante 1 - Inst_Side_T_1 incorreto!" SEVERITY FAILURE;
        --ASSERT (inst_tag_rrf_dest_1_tb = "00101") REPORT "Instante 1 - Inst_Tag_RRF_Dest_1 incorreto!" SEVERITY FAILURE;



        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;