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
        Instruction         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        Read_Write_RRF      : IN STD_LOGIC_VECTOR(37 DOWNTO 0); -- OPERATION(37), TAG(36 DOWNTO 32) e DATA(31 DOWNTO 0)
        RRF_Data_Out        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Tag lida (36 DOWNTO 32) e Dado lido (31 DOWNTO 0)

        Inst_Side_S         : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_S(37), TAG_S(36 DOWNTO 32) e DATA_S(31 DOWNTO 0)
        Inst_Side_T         : OUT STD_LOGIC_VECTOR(((1 + Size_RRF + 32) - 1) DOWNTO 0); -- VALID_T(37), TAG_T(36 DOWNTO 32) e DATA_T(31 DOWNTO 0)
        Inst_Tag_RRF_Dest   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END ENTITY RegisterRenameUnit;

ARCHITECTURE behavioral of RegisterRenameUnit IS

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & ARF_TAG(4 DOWNTO 0)
    SIGNAL ARF : BANKREG_ARF := (OTHERS => (OTHERS => '0'));   -- ARF = Architected Bank Register

    TYPE BANKREG_RRF IS array(0 to ((2**Size_RRF) - 1)) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)
    SIGNAL RRF : BANKREG_RRF := (OTHERS => (OTHERS => '0'));   -- RRF = Renamed Bank Register

    SIGNAL placeholder : bit := '0';
BEGIN

    Register_Renaming: PROCESS(Clk, Reset, Instruction)
        VARIABLE rd, rs1, rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        VARIABLE numero_operandos : INTEGER := 3;
    BEGIN

        IF (Reset = '1') THEN
            ARF <= (OTHERS => (OTHERS => '0'));
            RRF <= (OTHERS => (OTHERS => '0'));

        ELSIF (Rising_edge(Clk)) THEN

            -- Identificacao dos operandos
            IF (Instruction(6 DOWNTO 0) = "0110011") THEN   -- Instrucao Tipo R = 3 Operandos
                numero_operandos := 3;
                rd  := Instruction(11 DOWNTO 7);
                rs1 := Instruction(19 DOWNTO 15);
                rs2 := Instruction(24 DOWNTO 20);
            ELSE
                rd  := (OTHERS => '0');
                rs1 := (OTHERS => '0');
                rs2 := (OTHERS => '0');
            END IF;

            -- Renomeacao dos operandos
            WHILE (numero_operandos) > 1 LOOP
                FOR i in RRF'range LOOP
                    IF (RRF(i)(0) = '0') THEN

                        CASE (Instruction(6 DOWNTO 0)) IS
                            WHEN "0110011" =>
                                IF (numero_operandos = 3) THEN
                                    ARF(to_integer(unsigned(rs1)))(5) <= '1'; -- ARF_BUSY <= 1
                                    ARF(to_integer(unsigned(rs1)))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));   -- ARF(rs1)(ARF_TAG) <= RRF_TAG com busy 0

                                    RRF(i)(0) <= '1'; -- RRF_BUSY  <= 1
                                    RRF(i)(1) <= '0'; -- RRF_VALID <= 0
                                    RRF(i)(33 DOWNTO 2) <= ARF(to_integer(unsigned(rs1)))(37 DOWNTO 6); -- (RRF_DATA inicialmente eh o ARF_DATA mesmo?)
                
                                    IF (RRF(i)(1) = '1') THEN   -- Se RRF_VALID for 1
                                        Inst_Side_S(37) <= '1';   -- VALID_S <= 1 (use o RRF_TAG)
                                    ELSE
                                        Inst_Side_S(37) <= '0';   -- VALID_S <= 0 (use o ARF_DATA)
                                    END IF;
                                    Inst_Side_S(36 DOWNTO 32) <= std_logic_vector(to_unsigned(i, 5));   -- TAG_S <= RRF(i) == RRF_TAG
                                    Inst_Side_S(31 DOWNTO 0) <= ARF(to_integer(unsigned(rs1)))(37 DOWNTO 6); -- DATA_S <= ARF(rs1)(ARF_DATA)

                                    numero_operandos := numero_operandos - 1;

                                ELSIF (numero_operandos = 2) THEN
                                    ARF(to_integer(unsigned(rs2)))(5) <= '1';   -- ARF_BUSY <= 1
                                    ARF(to_integer(unsigned(rs2)))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));   -- ARF(rs2)(ARF_TAG) <= RRF_TAG com busy 0
                
                                    RRF(i)(0) <= '1'; -- RRF_BUSY  <= 1
                                    RRF(i)(1) <= '0'; -- RRF_VALID <= 0
                                    RRF(i)(33 DOWNTO 2) <= ARF(to_integer(unsigned(rs2)))(37 DOWNTO 6); -- (RRF_DATA inicialmente eh o ARF_DATA mesmo?)

                                    IF (RRF(i)(1) = '1') THEN   -- Se RRF_VALID for 1
                                        Inst_Side_T(37) <= '1';     -- VALID_T <= 1 (use o RRF_TAG)
                                    ELSE
                                        Inst_Side_T(37) <= '0';     -- VALID_T <= 0 (use o ARF_DATA)
                                    END IF;
                                    Inst_Side_T(36 DOWNTO 32) <= std_logic_vector(to_unsigned(i, 5));   -- TAG_T  <= RRF(i) == RRF_TAG
                                    Inst_Side_T(31 DOWNTO 0) <= ARF(to_integer(unsigned(rs2)))(37 DOWNTO 6);        -- DATA_T <= ARF(rs2)(ARF_DATA)

                                    numero_operandos := numero_operandos - 1;

                                ELSIF (numero_operandos = 1) THEN
                                    ARF(to_integer(unsigned(rd)))(5) <= '1';    -- ARF_BUSY <= 1
                                    ARF(to_integer(unsigned(rd)))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));   -- ARF(rd)(ARF_TAG) <= RRF_TAG com busy 0

                                    RRF(i)(0) <= '1'; -- RRF_BUSY  <= 1
                                    RRF(i)(1) <= '0'; -- RRF_VALID <= 0
                                    RRF(i)(33 DOWNTO 2) <= ARF(to_integer(unsigned(rd)))(37 DOWNTO 6); -- (RRF_DATA inicialmente eh o ARF_DATA mesmo?)

                                    Inst_Tag_RRF_Dest <= std_logic_vector(to_unsigned(i, 5));   -- Envia RRF(i) como destino da operacao
                                    EXIT;
                                END IF;

                            WHEN OTHERS =>
                                placeholder <= not placeholder;
                        END CASE;

                    END IF;
                END LOOP;
            END LOOP;
        END IF;
    END PROCESS;


END ARCHITECTURE behavioral;