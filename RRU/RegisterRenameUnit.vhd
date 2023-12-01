LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

ENTITY RegisterRenameUnit IS
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
END ENTITY RegisterRenameUnit;

ARCHITECTURE behavioral of RegisterRenameUnit IS

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & ARF_TAG(4 DOWNTO 0)
    SIGNAL ARF : BANKREG_ARF := (OTHERS => (OTHERS => '0'));   -- ARF = Architected Bank Register

    TYPE BANKREG_RRF IS array(0 to ((2**Size_RRF) - 1)) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)
    SIGNAL RRF : BANKREG_RRF := (OTHERS => (OTHERS => '0'));   -- RRF = Renamed Bank Register

    SIGNAL Instruction_Counter : UNSIGNED(0 TO 32) := (OTHERS => '0');
BEGIN

    Register_Renaming: PROCESS(Clk, Reset, Instruction_0, Instruction_1)
        VARIABLE RRF_Temp : BANKREG_RRF := (OTHERS => (OTHERS => '0'));
        VARIABLE instrucao : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE rd, rs1, rs2 : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
        VARIABLE side_s, side_s_0, side_s_1, side_t, side_t_0, side_t_1 : STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0) := (OTHERS => '0');
        VARIABLE tag_rrf_dest, tag_rrf_dest_0, tag_rrf_dest_1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    BEGIN

        IF (Reset = '1') THEN
            ARF <= (OTHERS => (OTHERS => '0'));
            RRF <= (OTHERS => (OTHERS => '0'));

        ELSIF (Rising_edge(Clk)) THEN

            -- Cria uma copia temporaria da RRF para evitar concorrencia
            RRF_Temp := RRF;

            -- Identificacao da instrucao atual
            IF (Instruction_Counter = IC_0) THEN
                instrucao := Instruction_0;
            ELSIF (Instruction_Counter = IC_1) THEN
                instrucao := Instruction_1;
            ELSE
                instrucao := (OTHERS => '0');
            END IF;

            -- Decodificacao dos operandos com base na instrucao atual
            CASE instrucao(6 DOWNTO 0) IS
                WHEN "0110011" =>                          -- Instrucao Tipo R = 3 Operandos
                    rd  := '1' & instrucao(11 DOWNTO 7); -- MSB setado => registrador eh usado na instrucao
                    rs1 := '1' & instrucao(19 DOWNTO 15);
                    rs2 := '1' & instrucao(24 DOWNTO 20);

                WHEN "1100111" | "0000011" | "0010011" =>  -- Instrucao Tipo I = 2 Operandos
                    rd  := '1' & instrucao(11 DOWNTO 7);
                    rs1 := '1' & instrucao(19 DOWNTO 15);
                    side_s := (OTHERS => '0');

                WHEN "0100011" =>                          -- Instrucao Tipo S = 2 Operandos
                    tag_rrf_dest  := (OTHERS => '0');
                    rs1 := '1' & instrucao(19 DOWNTO 15);
                    rs2 := '1' & instrucao(24 DOWNTO 20);

                WHEN "1100011" =>                          -- Instrucao Tipo B = 2 Operandos
                    tag_rrf_dest  := (OTHERS => '0');
                    rs1 := '1' & instrucao(19 DOWNTO 15);
                    rs2 := '1' & instrucao(24 DOWNTO 20);

                WHEN "0110111" | "0010111" =>              -- Instrucao Tipo U = 1 Operando
                    rd  := '1' & instrucao(11 DOWNTO 7);
                    side_t := (OTHERS => '0');
                    side_s := (OTHERS => '0');
                    
                WHEN "1101111" =>                          -- Instrucao Tipo J = 1 Operando
                    rd  := '1' & instrucao(11 DOWNTO 7);
                    side_t := (OTHERS => '0');
                    side_s := (OTHERS => '0');

                WHEN OTHERS =>
                    tag_rrf_dest  := (OTHERS => '0');
                    side_t := (OTHERS => '0');
                    side_s := (OTHERS => '0');
            END CASE;

            -- Renomeacao dos registradores
            FOR i in RRF_Temp'range LOOP
                IF (RRF_Temp(i)(0) = '0') THEN

                    -- Busca um RRF_Tag para cada registrador da instrucao que esteja valido
                    IF (rs1(5) = '1') THEN
                        ARF(to_integer(unsigned(rs1(4 DOWNTO 0))))(5) <= '1'; -- ARF_BUSY <= 1
                        ARF(to_integer(unsigned(rs1(4 DOWNTO 0))))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));   -- ARF(rs1)(ARF_TAG) <= RRF_TAG com busy 0

                        RRF_Temp(i)(0) := '1'; -- RRF_BUSY  <= 1
                        RRF_Temp(i)(1) := '0'; -- RRF_VALID <= 0
                        RRF_Temp(i)(33 DOWNTO 2) := ARF(to_integer(unsigned(rs1(4 DOWNTO 0))))(37 DOWNTO 6); -- RRF_DATA inicialmente <= ARF_DATA

                        IF (RRF_Temp(i)(1) = '1') THEN   -- Se RRF_VALID for 1
                            side_s(37) := '1';   -- VALID_S <= 1 (use o RRF_TAG)
                        ELSE
                            side_s(37) := '0';   -- VALID_S <= 0 (use o ARF_DATA)
                        END IF;

                        side_s(36 DOWNTO 32) := std_logic_vector(to_unsigned(i, 5)); -- TAG_S <= RRF(i)/RRF_TAG
                        side_s(31 DOWNTO 0) := ARF(to_integer(unsigned(rs1(4 DOWNTO 0))))(37 DOWNTO 6); -- DATA_S <= ARF(rs1)(ARF_DATA)

                        rs1(5) := '0'; -- Deixa de ser analisado, ja possui seu RRF_Tag

                    ELSIF (rs2(5) = '1') THEN
                        ARF(to_integer(unsigned(rs2(4 DOWNTO 0))))(5) <= '1';
                        ARF(to_integer(unsigned(rs2(4 DOWNTO 0))))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));

                        RRF_Temp(i)(0) := '1';
                        RRF_Temp(i)(1) := '0';
                        RRF_Temp(i)(33 DOWNTO 2) := ARF(to_integer(unsigned(rs2(4 DOWNTO 0))))(37 DOWNTO 6);

                        IF (RRF_Temp(i)(1) = '1') THEN   -- Se RRF_VALID for 1
                            side_t(37) := '1';     -- VALID_T <= 1 (use o RRF_TAG)
                        ELSE
                            side_t(37) := '0';     -- VALID_T <= 0 (use o ARF_DATA)
                        END IF;

                        side_t(36 DOWNTO 32) := std_logic_vector(to_unsigned(i, 5)); -- TAG_T  <= RRF(i) == RRF_TAG
                        side_t(31 DOWNTO 0) := ARF(to_integer(unsigned(rs2(4 DOWNTO 0))))(37 DOWNTO 6); -- DATA_T <= ARF(rs2)(ARF_DATA)

                        rs2(5) := '0';

                    ELSIF (rd(5) = '1') THEN
                        ARF(to_integer(unsigned(rd(4 DOWNTO 0))))(5) <= '1';
                        ARF(to_integer(unsigned(rd(4 DOWNTO 0))))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));

                        RRF_Temp(i)(0) := '1';
                        RRF_Temp(i)(1) := '0';
                        RRF_Temp(i)(33 DOWNTO 2) := ARF(to_integer(unsigned(rd(4 DOWNTO 0))))(37 DOWNTO 6);

                        tag_rrf_dest := std_logic_vector(to_unsigned(i, 5)); -- Envia RRF(i) como destino da operacao

                        rd(5) := '0';
                    END IF;
                END IF;
            END LOOP;

            -- Associa as saidas calculadas com as saidas da respectiva instrucao
            IF (Instruction_Counter = IC_0) THEN
                side_s_0 := side_s;
                side_t_0 := side_t;
                tag_rrf_dest_0 := tag_rrf_dest;

                -- Aguarda a instrucao seguinte
                Instruction_Counter <= Instruction_Counter + 1;

            ELSIF (Instruction_Counter = IC_1) THEN
                side_s_1 := side_s;
                side_t_1 := side_t;
                tag_rrf_dest_1 := tag_rrf_dest;

                Instruction_Counter <= Instruction_Counter + 1;
            END IF;
        END IF;


        -- Atualiza as saidas de cada instrucao
        Inst_Side_S_0 <= side_s_0;
        Inst_Side_T_0 <= side_t_0;
        Inst_Tag_RRF_Dest_0 <= tag_rrf_dest_0;
        IF (Read_Write_RRF_0(37) = '0') THEN    -- Leitura da RRF solicitada pela entrada da RS
            IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(1) = '1') THEN  -- Se RRF(Tag)(RRF_VALID) esta setado
                RRF_Data_Out_0 <= Read_Write_RRF_0(36 DOWNTO 32) & RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(33 DOWNTO 2); -- Retorna o dado na RRF
            ELSE
                RRF_Data_Out_0 <= (OTHERS => '0');
            END IF;
        ELSE                                    -- Escrita da RRF solicitada pela saida da RS
            IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(0) = '1') THEN -- Se o RRF_BUSY esta setado
                IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(1) = '0') THEN  -- Se o RRF_VALID nao esta setado
                    RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(33 DOWNTO 2) := Read_Write_RRF_0(31 DOWNTO 0); -- Realiza a escrita pendente na RRF
                    RRF_Temp(to_integer(unsigned(Read_Write_RRF_0(36 DOWNTO 32))))(1) := '1'; -- Seta o RRF_VALID
                END IF;
            END IF;
        END IF;

        Inst_Side_S_1 <= side_s_1;
        Inst_Side_T_1 <= side_t_1;
        Inst_Tag_RRF_Dest_1 <= tag_rrf_dest_1;
        IF (Read_Write_RRF_1(37) = '0') THEN
            IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(1) = '1') THEN
                RRF_Data_Out_1 <= Read_Write_RRF_1(36 DOWNTO 32) & RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(33 DOWNTO 2);
            ELSE
                RRF_Data_Out_1 <= (OTHERS => '0');
            END IF;
        ELSE
            IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(0) = '1') THEN
                IF (RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(1) = '0') THEN
                    RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(33 DOWNTO 2) := Read_Write_RRF_1(31 DOWNTO 0);
                    RRF_Temp(to_integer(unsigned(Read_Write_RRF_1(36 DOWNTO 32))))(1) := '1';
                END IF;
            END IF;
        END IF;


        -- Atualiza a RRF
        RRF <= RRF_Temp;

    END PROCESS;


END ARCHITECTURE behavioral;