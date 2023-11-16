USE IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rename IS
    PORT (
        Clk             : IN STD_LOGIC;
        RegisterID      : IN STD_LOGIC_VECTOR(4 downto 0);
        Data            : OUT STD_LOGIC_VECTOR(31 downto 0);
        Valid           : OUT STD_LOGIC
    );
END rename;

ARCHITECTURE behavioral OF rename IS

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & TAG(4 DOWNTO 0)
    TYPE BANKREG_RRF IS array(0 to 31) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)

    SIGNAL ARF : BANKREG_ARF;   -- ARF = Architected Bank Register
    SIGNAL RRF : BANKREG_RRF;   -- RRF = Renamed Bank Register
    SIGNAL Register_ARF: STD_LOGIC_VECTOR(37 DOWNTO 0);
    SIGNAL Register_RRF: STD_LOGIC_VECTOR(33 DOWNTO 0);

BEGIN
    Register_ARF <= ARF(conv_integer(RegisterID(4 DOWNTO 0)))

    PROCESS
        BEGIN
            IF Register_ARF(5) = '0' THEN   -- Verifica o Busy da tabela ARF
                Data <= Register_ARF(37 DOWNTO 6);
                Valid <= 1;
            ELSE
                Register_RRF <= RRF(conv_integer(Register_ARF(4 DOWNTO 0)))

                IF Register_RRF(1) = '1' THEN
                    Data <= Register_ARF(33 DOWNTO 2);
                    Valid <= 1;
                ELSE
                    Data <= Register_ARF(4 DOWNTO 0)
                    Valid <= 0;
                END IF;
            END IF;
    END PROCESS;
    
END ARCHITECTURE;
