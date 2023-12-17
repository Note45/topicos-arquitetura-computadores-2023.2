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
BEGIN
    Instruction_0_Out <= Instruction_0_In;
    Instruction_1_Out <= Instruction_1_In;
    Instruction_2_Out <= Instruction_2_In;
    Instruction_3_Out <= Instruction_3_In;


    -- Decoding of Instruction 0
    Instructions_Decoding_Inst_0: PROCESS (Instruction_0_In)
    BEGIN
        IF (Instruction_0_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_0_In(6 DOWNTO 0) IS
                WHEN "0110011" =>                          -- Instruction R-type = 3 Operands
                    Inst_0_Control <= "111";
                    Inst_0_Funct7 <= Instruction_0_In(31 DOWNTO 25);
                    Inst_0_Funct3 <= Instruction_0_In(14 DOWNTO 12);
                    Inst_0_RD     <= Instruction_0_In(11 DOWNTO 7);
                    Inst_0_RS1    <= Instruction_0_In(19 DOWNTO 15);
                    Inst_0_RS2    <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of R_imm
                    Inst_0_Imm    <= (OTHERS => '0');

                WHEN "1100111" | "0000011" | "0010011" =>  -- Instruction I-type = 2 Operands
                    Inst_0_Control <= "110";
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= Instruction_0_In(14 DOWNTO 12);
                    Inst_0_RD     <= Instruction_0_In(11 DOWNTO 7);
                    Inst_0_RS1    <= Instruction_0_In(19 DOWNTO 15);
                    Inst_0_RS2    <= (OTHERS => '0');

                    -- Calculation of I_imm
                    Inst_0_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_0_In(31));
                    Inst_0_Imm(10 DOWNTO 0)  <= Instruction_0_In(30 DOWNTO 20);

                WHEN "0100011" =>                          -- Instruction S-type = 2 Operands
                    Inst_0_Control <= "011";
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= Instruction_0_In(14 DOWNTO 12);
                    Inst_0_RD     <= (OTHERS => '0');
                    Inst_0_RS1    <= Instruction_0_In(19 DOWNTO 15);
                    Inst_0_RS2    <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of S_imm
                    Inst_0_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_0_In(31));
                    Inst_0_Imm(10 DOWNTO 5)  <= Instruction_0_In(30 DOWNTO 25);
                    Inst_0_Imm(4 DOWNTO 0)   <= Instruction_0_In(11 DOWNTO 7);

                WHEN "1100011" =>                          -- Instruction B-type = 2 Operands
                    Inst_0_Control <= "011";
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= Instruction_0_In(14 DOWNTO 12);
                    Inst_0_RD     <= (OTHERS => '0');
                    Inst_0_RS1    <= Instruction_0_In(19 DOWNTO 15);
                    Inst_0_RS2    <= Instruction_0_In(24 DOWNTO 20);

                    -- Calculation of B_imm
                    Inst_0_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_0_In(31));
                    Inst_0_Imm(11)           <= Instruction_0_In(7);
                    Inst_0_Imm(10 DOWNTO 5)  <= Instruction_0_In(30 DOWNTO 25);
                    Inst_0_Imm(4 DOWNTO 1)   <= Instruction_0_In(11 DOWNTO 8);
                    Inst_0_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>              -- Instruction U-type = 1 Operand
                    Inst_0_Control <= "100";
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= (OTHERS => '0');
                    Inst_0_RD     <= Instruction_0_In(11 DOWNTO 7);
                    Inst_0_RS1    <= (OTHERS => '0');
                    Inst_0_RS2    <= (OTHERS => '0');

                    -- Calculation of U_imm
                    Inst_0_Imm(31 DOWNTO 12) <= Instruction_0_In(31 DOWNTO 12);
                    Inst_0_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>                          -- Instruction J-type = 1 Operand
                    Inst_0_Control <= "100";
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= (OTHERS => '0');
                    Inst_0_RD     <= Instruction_0_In(11 DOWNTO 7);
                    Inst_0_RS1    <= (OTHERS => '0');
                    Inst_0_RS2    <= (OTHERS => '0');

                    -- Calculation of J_imm
                    Inst_0_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_0_In(31));
                    Inst_0_Imm(19 DOWNTO 12) <= Instruction_0_In(19 DOWNTO 12);
                    Inst_0_Imm(11)           <= Instruction_0_In(20);
                    Inst_0_Imm(10 DOWNTO 1)  <= Instruction_0_In(30 DOWNTO 21);
                    Inst_0_Imm(0)            <= '0';

                WHEN OTHERS =>
                    Inst_0_Control <= (OTHERS => '0');
                    Inst_0_Funct7 <= (OTHERS => '0');
                    Inst_0_Funct3 <= (OTHERS => '0');
                    Inst_0_RD     <= (OTHERS => '0');
                    Inst_0_RS1    <= (OTHERS => '0');
                    Inst_0_RS2    <= (OTHERS => '0');

                    Inst_0_Imm    <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 1
    Instructions_Decoding_Inst_1: PROCESS (Instruction_1_In)
    BEGIN
        IF (Instruction_1_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_1_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    Inst_1_Control <= "111";
                    Inst_1_Funct7 <= Instruction_1_In(31 DOWNTO 25);
                    Inst_1_Funct3 <= Instruction_1_In(14 DOWNTO 12);
                    Inst_1_RD     <= Instruction_1_In(11 DOWNTO 7);
                    Inst_1_RS1    <= Instruction_1_In(19 DOWNTO 15);
                    Inst_1_RS2    <= Instruction_1_In(24 DOWNTO 20);

                    Inst_1_Imm    <= (OTHERS => '0');

                WHEN "1100111" | "0000011" | "0010011" =>
                    Inst_1_Control <= "110";
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= Instruction_1_In(14 DOWNTO 12);
                    Inst_1_RD     <= Instruction_1_In(11 DOWNTO 7);
                    Inst_1_RS1    <= Instruction_1_In(19 DOWNTO 15);
                    Inst_1_RS2    <= (OTHERS => '0');

                    Inst_1_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_1_In(31));
                    Inst_1_Imm(10 DOWNTO 0)  <= Instruction_1_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    Inst_1_Control <= "011";
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= Instruction_1_In(14 DOWNTO 12);
                    Inst_1_RD     <= (OTHERS => '0');
                    Inst_1_RS1    <= Instruction_1_In(19 DOWNTO 15);
                    Inst_1_RS2    <= Instruction_1_In(24 DOWNTO 20);

                    Inst_1_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_1_In(31));
                    Inst_1_Imm(10 DOWNTO 5)  <= Instruction_1_In(30 DOWNTO 25);
                    Inst_1_Imm(4 DOWNTO 0)   <= Instruction_1_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    Inst_1_Control <= "011";
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= Instruction_1_In(14 DOWNTO 12);
                    Inst_1_RD     <= (OTHERS => '0');
                    Inst_1_RS1    <= Instruction_1_In(19 DOWNTO 15);
                    Inst_1_RS2    <= Instruction_1_In(24 DOWNTO 20);

                    Inst_1_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_1_In(31));
                    Inst_1_Imm(11)           <= Instruction_1_In(7);
                    Inst_1_Imm(10 DOWNTO 5)  <= Instruction_1_In(30 DOWNTO 25);
                    Inst_1_Imm(4 DOWNTO 1)   <= Instruction_1_In(11 DOWNTO 8);
                    Inst_1_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    Inst_1_Control <= "100";
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= (OTHERS => '0');
                    Inst_1_RD     <= Instruction_1_In(11 DOWNTO 7);
                    Inst_1_RS1    <= (OTHERS => '0');
                    Inst_1_RS2    <= (OTHERS => '0');

                    Inst_1_Imm(31 DOWNTO 12) <= Instruction_1_In(31 DOWNTO 12);
                    Inst_1_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    Inst_1_Control <= "100";
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= (OTHERS => '0');
                    Inst_1_RD     <= Instruction_1_In(11 DOWNTO 7);
                    Inst_1_RS1    <= (OTHERS => '0');
                    Inst_1_RS2    <= (OTHERS => '0');

                    Inst_1_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_1_In(31));
                    Inst_1_Imm(19 DOWNTO 12) <= Instruction_1_In(19 DOWNTO 12);
                    Inst_1_Imm(11)           <= Instruction_1_In(20);
                    Inst_1_Imm(10 DOWNTO 1)  <= Instruction_1_In(30 DOWNTO 21);
                    Inst_1_Imm(0)            <= '0';

                WHEN OTHERS =>
                    Inst_1_Control <= (OTHERS => '0');
                    Inst_1_Funct7 <= (OTHERS => '0');
                    Inst_1_Funct3 <= (OTHERS => '0');
                    Inst_1_RD     <= (OTHERS => '0');
                    Inst_1_RS1    <= (OTHERS => '0');
                    Inst_1_RS2    <= (OTHERS => '0');

                    Inst_1_Imm    <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 2
    Instructions_Decoding_Inst_2: PROCESS (Instruction_2_In)
    BEGIN
        IF (Instruction_2_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_2_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    Inst_2_Control <= "111";
                    Inst_2_Funct7 <= Instruction_2_In(31 DOWNTO 25);
                    Inst_2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    Inst_2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    Inst_2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    Inst_2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    Inst_2_Imm    <= (OTHERS => '0');

                WHEN "1100111" | "0000011" | "0010011" =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    Inst_2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    Inst_2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    Inst_2_RS2    <= (OTHERS => '0');

                    Inst_2_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_2_In(31));
                    Inst_2_Imm(10 DOWNTO 0)  <= Instruction_2_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    Inst_2_RD     <= (OTHERS => '0');
                    Inst_2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    Inst_2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    Inst_2_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_2_In(31));
                    Inst_2_Imm(10 DOWNTO 5)  <= Instruction_2_In(30 DOWNTO 25);
                    Inst_2_Imm(4 DOWNTO 0)   <= Instruction_2_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= Instruction_2_In(14 DOWNTO 12);
                    Inst_2_RD     <= (OTHERS => '0');
                    Inst_2_RS1    <= Instruction_2_In(19 DOWNTO 15);
                    Inst_2_RS2    <= Instruction_2_In(24 DOWNTO 20);

                    Inst_2_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_2_In(31));
                    Inst_2_Imm(11)           <= Instruction_2_In(7);
                    Inst_2_Imm(10 DOWNTO 5)  <= Instruction_2_In(30 DOWNTO 25);
                    Inst_2_Imm(4 DOWNTO 1)   <= Instruction_2_In(11 DOWNTO 8);
                    Inst_2_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= (OTHERS => '0');
                    Inst_2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    Inst_2_RS1    <= (OTHERS => '0');
                    Inst_2_RS2    <= (OTHERS => '0');

                    Inst_2_Imm(31 DOWNTO 12) <= Instruction_2_In(31 DOWNTO 12);
                    Inst_2_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= (OTHERS => '0');
                    Inst_2_RD     <= Instruction_2_In(11 DOWNTO 7);
                    Inst_2_RS1    <= (OTHERS => '0');
                    Inst_2_RS2    <= (OTHERS => '0');

                    Inst_2_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_2_In(31));
                    Inst_2_Imm(19 DOWNTO 12) <= Instruction_2_In(19 DOWNTO 12);
                    Inst_2_Imm(11)           <= Instruction_2_In(20);
                    Inst_2_Imm(10 DOWNTO 1)  <= Instruction_2_In(30 DOWNTO 21);
                    Inst_2_Imm(0)            <= '0';

                WHEN OTHERS =>
                    Inst_2_Funct7 <= (OTHERS => '0');
                    Inst_2_Funct3 <= (OTHERS => '0');
                    Inst_2_RD     <= (OTHERS => '0');
                    Inst_2_RS1    <= (OTHERS => '0');
                    Inst_2_RS2    <= (OTHERS => '0');
                    Inst_2_Imm    <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;


    -- Decoding of Instruction 3
    Instructions_Decoding_Inst_3: PROCESS (Instruction_3_In)
    BEGIN
        IF (Instruction_3_In /= "00000000000000000000000000000000") THEN
            CASE Instruction_3_In(6 DOWNTO 0) IS
                WHEN "0110011" =>
                    Inst_3_Control <= "111";
                    Inst_3_Funct7 <= Instruction_3_In(31 DOWNTO 25);
                    Inst_3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    Inst_3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    Inst_3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    Inst_3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    Inst_3_Imm    <= (OTHERS => '0');

                WHEN "1100111" | "0000011" | "0010011" =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    Inst_3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    Inst_3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    Inst_3_RS2    <= (OTHERS => '0');
                    
                    Inst_3_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_3_In(31));
                    Inst_3_Imm(10 DOWNTO 0)  <= Instruction_3_In(30 DOWNTO 20);

                WHEN "0100011" =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    Inst_3_RD     <= (OTHERS => '0');
                    Inst_3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    Inst_3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    Inst_3_Imm(31 DOWNTO 11) <= (OTHERS => Instruction_3_In(31));
                    Inst_3_Imm(10 DOWNTO 5)  <= Instruction_3_In(30 DOWNTO 25);
                    Inst_3_Imm(4 DOWNTO 0)   <= Instruction_3_In(11 DOWNTO 7);

                WHEN "1100011" =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= Instruction_3_In(14 DOWNTO 12);
                    Inst_3_RD     <= (OTHERS => '0');
                    Inst_3_RS1    <= Instruction_3_In(19 DOWNTO 15);
                    Inst_3_RS2    <= Instruction_3_In(24 DOWNTO 20);
                    
                    Inst_3_Imm(31 DOWNTO 12) <= (OTHERS => Instruction_3_In(31));
                    Inst_3_Imm(11)           <= Instruction_3_In(7);
                    Inst_3_Imm(10 DOWNTO 5)  <= Instruction_3_In(30 DOWNTO 25);
                    Inst_3_Imm(4 DOWNTO 1)   <= Instruction_3_In(11 DOWNTO 8);
                    Inst_3_Imm(0)            <= '0';

                WHEN "0110111" | "0010111" =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= (OTHERS => '0');
                    Inst_3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    Inst_3_RS1    <= (OTHERS => '0');
                    Inst_3_RS2    <= (OTHERS => '0');
                    
                    Inst_3_Imm(31 DOWNTO 12) <= Instruction_3_In(31 DOWNTO 12);
                    Inst_3_Imm(11 DOWNTO 0)  <= (OTHERS => '0');

                WHEN "1101111" =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= (OTHERS => '0');
                    Inst_3_RD     <= Instruction_3_In(11 DOWNTO 7);
                    Inst_3_RS1    <= (OTHERS => '0');
                    Inst_3_RS2    <= (OTHERS => '0');
                    
                    Inst_3_Imm(31 DOWNTO 20) <= (OTHERS => Instruction_3_In(31));
                    Inst_3_Imm(19 DOWNTO 12) <= Instruction_3_In(19 DOWNTO 12);
                    Inst_3_Imm(11)           <= Instruction_3_In(20);
                    Inst_3_Imm(10 DOWNTO 1)  <= Instruction_3_In(30 DOWNTO 21);
                    Inst_3_Imm(0)            <= '0';

                WHEN OTHERS =>
                    Inst_3_Funct7 <= (OTHERS => '0');
                    Inst_3_Funct3 <= (OTHERS => '0');
                    Inst_3_RD     <= (OTHERS => '0');
                    Inst_3_RS1    <= (OTHERS => '0');
                    Inst_3_RS2    <= (OTHERS => '0');
                    
                    Inst_3_Imm    <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;

END ARCHITECTURE decoding;