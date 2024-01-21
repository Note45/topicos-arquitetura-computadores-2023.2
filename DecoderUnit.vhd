LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DecoderUnit IS
    PORT(
        Clock               :  IN STD_LOGIC;
        Instruction_0_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instruction_1_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instruction_2_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Instruction_3_In    :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);

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
END ENTITY DecoderUnit;


ARCHITECTURE decoding OF DecoderUnit IS

    SIGNAL I0_Control       : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I0_Funct7        : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL I0_Funct3        : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I0_RD            : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I0_RS1           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I0_RS2           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I0_Imm           : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

    SIGNAL I1_Control       : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I1_Funct7        : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL I1_Funct3        : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I1_RD            : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I1_RS1           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I1_RS2           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I1_Imm           : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

    SIGNAL I2_Control       : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I2_Funct7        : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL I2_Funct3        : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I2_RD            : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I2_RS1           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I2_RS2           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I2_Imm           : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

    SIGNAL I3_Control       : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I3_Funct7        : STD_LOGIC_VECTOR(6 DOWNTO 0)          := "0000000";
    SIGNAL I3_Funct3        : STD_LOGIC_VECTOR(2 DOWNTO 0)          := "000";
    SIGNAL I3_RD            : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I3_RS1           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I3_RS2           : STD_LOGIC_VECTOR(4 DOWNTO 0)          := "00000";
    SIGNAL I3_Imm           : STD_LOGIC_VECTOR(31 DOWNTO 0)         := "00000000000000000000000000000000";

BEGIN

    Instruction_0_Out <= Instruction_0_In;
    Inst_0_Control <= I0_Control;
    Inst_0_Funct7 <= I0_Funct7;
    Inst_0_Funct3 <= I0_Funct3;
    Inst_0_RD <= I0_RD;
    Inst_0_RS1 <= I0_RS1;
    Inst_0_RS2 <= I0_RS2;
    Inst_0_Imm <= I0_Imm;

    Instruction_1_Out <= Instruction_1_In;
    Inst_1_Control <= I1_Control;
    Inst_1_Funct7 <= I1_Funct7;
    Inst_1_Funct3 <= I1_Funct3;
    Inst_1_RD <= I1_RD;
    Inst_1_RS1 <= I1_RS1;
    Inst_1_RS2 <= I1_RS2;
    Inst_1_Imm <= I1_Imm;

    Instruction_2_Out <= Instruction_2_In;
    Inst_2_Control <= I2_Control;
    Inst_2_Funct7 <= I2_Funct7;
    Inst_2_Funct3 <= I2_Funct3;
    Inst_2_RD <= I2_RD;
    Inst_2_RS1 <= I2_RS1;
    Inst_2_RS2 <= I2_RS2;
    Inst_2_Imm <= I2_Imm;

    Instruction_3_Out <= Instruction_3_In;
    Inst_3_Control <= I3_Control;
    Inst_3_Funct7 <= I3_Funct7;
    Inst_3_Funct3 <= I3_Funct3;
    Inst_3_RD <= I3_RD;
    Inst_3_RS1 <= I3_RS1;
    Inst_3_RS2 <= I3_RS2;
    Inst_3_Imm <= I3_Imm;


    -- Decoding of Instruction 0
    Instructions_Decoding_Inst_0: PROCESS (Instruction_0_In)
    BEGIN
        IF (Instruction_0_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_0_In(6 DOWNTO 0) IS
                WHEN "0110011" =>                          -- Instruction R-type = 3 Operands
                    I0_Control <= "111";
                    I0_Funct7  <= Instruction_0_In(31 DOWNTO 25);
                    I0_Funct3  <= Instruction_0_In(14 DOWNTO 12);
                    I0_RD      <= Instruction_0_In(11 DOWNTO 7);
                    I0_RS1     <= Instruction_0_In(19 DOWNTO 15);
                    I0_RS2     <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of R_imm
                    I0_Imm     <= "00000000000000000000000000000000";

                WHEN "1100111" | "0000011" | "0010011" =>  -- Instruction I-type = 2 Operands
                    I0_Control <= "110";
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= Instruction_0_In(14 DOWNTO 12);
                    I0_RD      <= Instruction_0_In(11 DOWNTO 7);
                    I0_RS1     <= Instruction_0_In(19 DOWNTO 15);
                    I0_RS2     <= "00000";

                    -- Calculation of I_imm
                    I0_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_0_In(31));
                    I0_Imm(10 DOWNTO 0)  <= Instruction_0_In(30 DOWNTO 20);

                WHEN "0100011" =>                          -- Instruction S-type = 2 Operands
                    I0_Control <= "011";
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= Instruction_0_In(14 DOWNTO 12);
                    I0_RD      <= "00000";
                    I0_RS1     <= Instruction_0_In(19 DOWNTO 15);
                    I0_RS2     <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of S_imm
                    I0_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_0_In(31));
                    I0_Imm(10 DOWNTO 5)  <= Instruction_0_In(30 DOWNTO 25);
                    I0_Imm(4 DOWNTO 0)   <= Instruction_0_In(11 DOWNTO 7);

                WHEN "1100011" =>                          -- Instruction B-type = 2 Operands
                    I0_Control <= "011";
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= Instruction_0_In(14 DOWNTO 12);
                    I0_RD      <= "00000";
                    I0_RS1     <= Instruction_0_In(19 DOWNTO 15);
                    I0_RS2     <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of B_imm
                    I0_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_0_In(31));
                    I0_Imm(11)           <= Instruction_0_In(7);
                    I0_Imm(10 DOWNTO 5)  <= Instruction_0_In(30 DOWNTO 25);
                    I0_Imm(4 DOWNTO 1)   <= Instruction_0_In(11 DOWNTO 8);
                    I0_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>              -- Instruction U-type = 1 Operand
                    I0_Control <= "100";
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= "000";
                    I0_RD      <= Instruction_0_In(11 DOWNTO 7);
                    I0_RS1     <= "00000";
                    I0_RS2     <= "00000";

                    -- Calculation of U_imm
                    I0_Imm(31 DOWNTO 12) <= Instruction_0_In(31 DOWNTO 12);
                    I0_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>                          -- Instruction J-type = 1 Operand
                    I0_Control <= "100";
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= "000";
                    I0_RD      <= Instruction_0_In(11 DOWNTO 7);
                    I0_RS1     <= "00000";
                    I0_RS2     <= "00000";

                    -- Calculation of J_imm
                    I0_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_0_In(31));
                    I0_Imm(19 DOWNTO 12) <= Instruction_0_In(19 DOWNTO 12);
                    I0_Imm(11)           <= Instruction_0_In(20);
                    I0_Imm(10 DOWNTO 1)  <= Instruction_0_In(30 DOWNTO 21);
                    I0_Imm(0)            <= '0';

                WHEN OTHERS =>
                    I0_Control <= (OTHERS => '0');
                    I0_Funct7  <= "0000000";
                    I0_Funct3  <= "000";
                    I0_RD      <= "00000";
                    I0_RS1     <= "00000";
                    I0_RS2     <= "00000";

                    I0_Imm     <= "00000000000000000000000000000000";
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 1
    Instructions_Decoding_Inst_1: PROCESS (Instruction_1_In)
    BEGIN
        IF (Instruction_1_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_1_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    I1_Control <= "111";
                    I1_Funct7  <= Instruction_1_In(31 DOWNTO 25);
                    I1_Funct3  <= Instruction_1_In(14 DOWNTO 12);
                    I1_RD      <= Instruction_1_In(11 DOWNTO 7);
                    I1_RS1     <= Instruction_1_In(19 DOWNTO 15);
                    I1_RS2     <= Instruction_1_In(24 DOWNTO 20);

                    I1_Imm     <= "00000000000000000000000000000000";

                WHEN "1100111" | "0000011" | "0010011" =>
                    I1_Control <= "110";
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= Instruction_1_In(14 DOWNTO 12);
                    I1_RD      <= Instruction_1_In(11 DOWNTO 7);
                    I1_RS1     <= Instruction_1_In(19 DOWNTO 15);
                    I1_RS2     <= "00000";

                    I1_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_1_In(31));
                    I1_Imm(10 DOWNTO 0)  <= Instruction_1_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    I1_Control <= "011";
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= Instruction_1_In(14 DOWNTO 12);
                    I1_RD      <= "00000";
                    I1_RS1     <= Instruction_1_In(19 DOWNTO 15);
                    I1_RS2     <= Instruction_1_In(24 DOWNTO 20);

                    I1_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_1_In(31));
                    I1_Imm(10 DOWNTO 5)  <= Instruction_1_In(30 DOWNTO 25);
                    I1_Imm(4 DOWNTO 0)   <= Instruction_1_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    I1_Control <= "011";
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= Instruction_1_In(14 DOWNTO 12);
                    I1_RD      <= "00000";
                    I1_RS1     <= Instruction_1_In(19 DOWNTO 15);
                    I1_RS2     <= Instruction_1_In(24 DOWNTO 20);

                    I1_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_1_In(31));
                    I1_Imm(11)           <= Instruction_1_In(7);
                    I1_Imm(10 DOWNTO 5)  <= Instruction_1_In(30 DOWNTO 25);
                    I1_Imm(4 DOWNTO 1)   <= Instruction_1_In(11 DOWNTO 8);
                    I1_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    I1_Control <= "100";
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= "000";
                    I1_RD      <= Instruction_1_In(11 DOWNTO 7);
                    I1_RS1     <= "00000";
                    I1_RS2     <= "00000";

                    I1_Imm(31 DOWNTO 12) <= Instruction_1_In(31 DOWNTO 12);
                    I1_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    I1_Control <= "100";
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= "000";
                    I1_RD      <= Instruction_1_In(11 DOWNTO 7);
                    I1_RS1     <= "00000";
                    I1_RS2     <= "00000";

                    I1_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_1_In(31));
                    I1_Imm(19 DOWNTO 12) <= Instruction_1_In(19 DOWNTO 12);
                    I1_Imm(11)           <= Instruction_1_In(20);
                    I1_Imm(10 DOWNTO 1)  <= Instruction_1_In(30 DOWNTO 21);
                    I1_Imm(0)            <= '0';

                WHEN OTHERS =>
                    I1_Control <= (OTHERS => '0');
                    I1_Funct7  <= "0000000";
                    I1_Funct3  <= "000";
                    I1_RD      <= "00000";
                    I1_RS1     <= "00000";
                    I1_RS2     <= "00000";

                    I1_Imm     <= "00000000000000000000000000000000";
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 2
    Instructions_Decoding_Inst_2: PROCESS (Instruction_2_In)
    BEGIN
        IF (Instruction_2_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_2_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    I2_Control <= "111";
                    I2_Funct7 <= Instruction_2_In(31 DOWNTO 25);
                    I2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    I2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    I2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    I2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    I2_Imm    <= "00000000000000000000000000000000";

                WHEN "1100111" | "0000011" | "0010011" =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    I2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    I2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    I2_RS2    <= "00000";

                    I2_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_2_In(31));
                    I2_Imm(10 DOWNTO 0)  <= Instruction_2_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    I2_RD     <= "00000";
                    I2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    I2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    I2_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_2_In(31));
                    I2_Imm(10 DOWNTO 5)  <= Instruction_2_In(30 DOWNTO 25);
                    I2_Imm(4 DOWNTO 0)   <= Instruction_2_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    I2_RD     <= "00000";
                    I2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    I2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    I2_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_2_In(31));
                    I2_Imm(11)           <= Instruction_2_In(7);
                    I2_Imm(10 DOWNTO 5)  <= Instruction_2_In(30 DOWNTO 25);
                    I2_Imm(4 DOWNTO 1)   <= Instruction_2_In(11 DOWNTO 8);
                    I2_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= "000";
                    I2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    I2_RS1    <= "00000";
                    I2_RS2    <= "00000";

                    I2_Imm(31 DOWNTO 12) <= Instruction_2_In(31 DOWNTO 12);
                    I2_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= "000";
                    I2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    I2_RS1    <= "00000";
                    I2_RS2    <= "00000";

                    I2_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_2_In(31));
                    I2_Imm(19 DOWNTO 12) <= Instruction_2_In(19 DOWNTO 12);
                    I2_Imm(11)           <= Instruction_2_In(20);
                    I2_Imm(10 DOWNTO 1)  <= Instruction_2_In(30 DOWNTO 21);
                    I2_Imm(0)            <= '0';

                WHEN OTHERS =>
                    I2_Funct7 <= "0000000";
                    I2_Funct3 <= "000";
                    I2_RD     <= "00000";
                    I2_RS1    <= "00000";
                    I2_RS2    <= "00000";

                    I2_Imm    <= "00000000000000000000000000000000";
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 3
    Instructions_Decoding_Inst_3: PROCESS (Instruction_3_In)
    BEGIN
        IF (Instruction_3_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_3_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    I3_Control <= "111";
                    I3_Funct7 <= Instruction_3_In(31 DOWNTO 25);
                    I3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    I3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    I3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    I3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    I3_Imm    <= "00000000000000000000000000000000";

                WHEN "1100111" | "0000011" | "0010011" =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    I3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    I3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    I3_RS2    <= "00000";
                    
                    I3_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_3_In(31));
                    I3_Imm(10 DOWNTO 0)  <= Instruction_3_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    I3_RD     <= "00000";
                    I3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    I3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    I3_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_3_In(31));
                    I3_Imm(10 DOWNTO 5)  <= Instruction_3_In(30 DOWNTO 25);
                    I3_Imm(4 DOWNTO 0)   <= Instruction_3_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    I3_RD     <= "00000";
                    I3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    I3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    I3_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_3_In(31));
                    I3_Imm(11)           <= Instruction_3_In(7);
                    I3_Imm(10 DOWNTO 5)  <= Instruction_3_In(30 DOWNTO 25);
                    I3_Imm(4 DOWNTO 1)   <= Instruction_3_In(11 DOWNTO 8);
                    I3_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= "000";
                    I3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    I3_RS1    <= "00000";
                    I3_RS2    <= "00000";
                    
                    I3_Imm(31 DOWNTO 12) <= Instruction_3_In(31 DOWNTO 12);
                    I3_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= "000";
                    I3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    I3_RS1    <= "00000";
                    I3_RS2    <= "00000";
                    
                    I3_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_3_In(31));
                    I3_Imm(19 DOWNTO 12) <= Instruction_3_In(19 DOWNTO 12);
                    I3_Imm(11)           <= Instruction_3_In(20);
                    I3_Imm(10 DOWNTO 1)  <= Instruction_3_In(30 DOWNTO 21);
                    I3_Imm(0)            <= '0';

                WHEN OTHERS =>
                    I3_Funct7 <= "0000000";
                    I3_Funct3 <= "000";
                    I3_RD     <= "00000";
                    I3_RS1    <= "00000";
                    I3_RS2    <= "00000";
                    
                    I3_Imm    <= "00000000000000000000000000000000";
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE decoding;