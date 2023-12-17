LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_RiscV_Processor IS
END ENTITY TB_RiscV_Processor;

ARCHITECTURE testbench OF TB_RiscV_Processor IS

    COMPONENT RiscV_Processor IS
        PORT(
            Clock               :  IN STD_LOGIC;
            Reset               :  IN STD_LOGIC;
    
            IO_0                :  IN UNSIGNED(31 DOWNTO 0);
            IO_1                :  IN UNSIGNED(31 DOWNTO 0);
            IO_2                :  IN UNSIGNED(31 DOWNTO 0);
            IO_3                :  IN UNSIGNED(31 DOWNTO 0);
    
            Instruction_0       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_1       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_2       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Instruction_3       :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            
            Placeholder         : OUT STD_LOGIC
        );
    END COMPONENT RiscV_Processor;

    CONSTANT clock_period                                 : TIME := 5 ns;

    SIGNAL clock_tb                                       : STD_LOGIC := '0';
    SIGNAL reset_tb                                       : STD_LOGIC := '0';

    SIGNAL io_0_tb, io_1_tb, io_2_tb, io_3_tb             : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL inst_0_tb, inst_1_tb, inst_2_tb, inst_3_tb     : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL placeholder_tb                                 : STD_LOGIC := '0';

BEGIN

    clks : PROCESS
    BEGIN
        WAIT FOR clock_period/2;
        clock_tb <= NOT clock_tb;
        ASSERT NOW < 50 ns REPORT "Fim" SEVERITY FAILURE;
    END PROCESS;

    Processor : RiscV_Processor
    PORT MAP(
        Clock => clock_tb,
        Reset => reset_tb,

        IO_0 => io_0_tb, 
        IO_1 => io_1_tb, 
        IO_2 => io_2_tb, 
        IO_3 => io_3_tb, 

        Instruction_0 => inst_0_tb,
        Instruction_1 => inst_1_tb,
        Instruction_2 => inst_2_tb,
        Instruction_3 => inst_3_tb,

        Placeholder => placeholder_tb
    );

    exec: PROCESS
    BEGIN

        reset_tb <= '1';
        WAIT FOR 5 ns;
        reset_tb <= '0';
        WAIT FOR 5 ns;

        --                                                 Instante 0                                                 --
        --                       Teste: execucao de duas instrucoes tipo R em ordem (fluxo principal)
        -- Instrucao 0) add x5 x14 x26
        -- x5 <= x26 + x14
        -- TipoR = funct7 rs2 rs1 funct3 rd codop
        -- Inputs: 
        --          IC_0:   0
        --          Inst_0: 00000000111011010000001010110011
        --                      funct7: 0000000
        --                      rs2:    01110   (r14)
        --                      rs1:    11010   (r26)
        --                      funct3: 000
        --                      rd:     00101   (r5)
        --                      codop:  0110011 (tipo R)
        -- Outputs esperados:
        --          Inst_0_Side_S: 10000000000000000000000000000000
        --                      Inst_0_Side_S(32):           1 (dado valido)
        --                      Inst_0_Side_S(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do r26|RRF0)
        --
        --          Inst_0_Side_T: 1000000000000000000000000000000
        --                      Inst_0_Side_T(32):           1 (dado valido)
        --                      Inst_0_Side_T(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do r14|RRF1)
        --
        --          Inst_0_RRF_Dest: 00010
        --                      Inst_0_RRF_Dest: (2 = RRF2 = alias do r5)
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
        --          Inst_1_Side_S: 10000000000000000000000000000000
        --                      Inst_Side_S_1(32):           1 (dado valido)
        --                      Inst_Side_S_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do r31|RRF8)
        --
        --          Inst_1_Side_T: 10000000000000000000000000000000
        --                      Inst_Side_T_1(32):           1 (dado valido)
        --                      Inst_Side_T_1(31 DOWNTO 0):  00000000000000000000000000000000 (ARF_DATA do r18|RRF9)
        --
        --          Inst_1_RRF_Dest: 01010
        --                      Inst_1_RRF_Dest: (10 = RRF10 = alias do r8)
        io_0_tb <= to_unsigned(0, 32);
        inst_0_tb <= "00000000111011010000001010110011";
        io_1_tb <= to_unsigned(1, 32);
        inst_1_tb <= "00000011111110010000010000110011";
        WAIT FOR 5 ns;

        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;