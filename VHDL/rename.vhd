USE IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

ENTITY rename IS
    PORT (
        Clk                 : IN STD_LOGIC;
        Escrita             : IN STD_LOGIC;
        ValidIn             : IN STD_LOGIC;
        IdRegistrador       : IN STD_LOGIC_VECTOR(4 downto 0);
        DataIn              : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        DataOut             : OUT STD_LOGIC_VECTOR(31 downto 0);
        Tag                 : OUT STD_LOGIC;
        ValidOut            : OUT STD_LOGIC;
    );
END rename;

ARCHITECTURE behavioral OF rename IS

    TYPE BANKREG_ARF IS array(0 to 31) OF STD_LOGIC_VECTOR(37 DOWNTO 0); -- Ordem dos bits: ARF_DATA(37 DOWNTO 6) & ARF_BUSY(5) & ARF_TAG(4 DOWNTO 0)
    TYPE BANKREG_RRF IS array(0 to 31) OF STD_LOGIC_VECTOR(33 DOWNTO 0); -- Ordem dos bits: RRF_DATA(33 DOWNTO 2) & RRF_VALID(1) & RRF_BUSY(0)

    SIGNAL ARF : BANKREG_ARF;   -- ARF = Architected Bank Register
    SIGNAL RRF : BANKREG_RRF;   -- RRF = Renamed Bank Register
    SIGNAL Register_ARF: STD_LOGIC_VECTOR(37 DOWNTO 0);
    SIGNAL Register_RRF: STD_LOGIC_VECTOR(33 DOWNTO 0);
    
    -- SIGNAL RegistradorLivre: STD_LOGIC_VECTOR(4 DOWNTO 0);
    
BEGIN
    Leitura: PROCESS (Clk, ARF, IdRegistrador, ValidIn)
        BEGIN
            IF ValidIN = '1' THEN   -- Indica que o endereço IdRegistrador está no ARF
                Register_ARF <= ARF(conv_integer(IdRegistrador(4 DOWNTO 0)))

                IF Register_ARF(5) = '0' THEN   -- Verifica o Busy do ARF
                    DataOut <= Register_ARF(37 DOWNTO 6);
                    ValidOut <= 1;
                ELSE
                    Register_RRF <= RRF(conv_integer(Register_ARF(4 DOWNTO 0)))

                    IF Register_RRF(1) = '1' THEN   -- Se Valid == 1
                        DataOut <= Register_ARF(33 DOWNTO 2);
                        Tag <= Register_ARF(33 DOWNTO 2);
                        ValidOut <= 1;
                    ELSE
                        Tag <= Register_ARF(4 DOWNTO 0)
                        ValidOut <= 0;
                    END IF;
                END IF;

            ELSE    -- Indica que o endereço IdRegistrador está no RRF
                Register_RRF <= RRF(conv_integer(IdRegistrador(4 DOWNTO 0)))

                IF Register_RRF(1) = '1' THEN   -- Se Valid == 1
                    DataOut <= Register_ARF(33 DOWNTO 2);
                    Tag <= Register_ARF(33 DOWNTO 2);
                    ValidOut <= 1;
                ELSE
                    Tag <= Register_ARF(4 DOWNTO 0)
                    ValidOut <= 0;
                END IF;
            END IF;
    END PROCESS Leitura;

    Escrita: PROCESS (Escrita)
        BEGIN
            Register_RRF <= RRF(conv_integer(IdRegistrador(4 DOWNTO 0)));
            Register_RRF(33 DOWNTO 2) <= DataIn;
            Register_RRF(1) <= '1';
    END PROCESS Escrita;

    Mapeamento: PROCESS
        BEGIN
            FOR i IN 0 TO RRF'range LOOP
                IF RRF(i)(0) = '0' THEN
                    IF ARF(conv_integer(IdRegistrador(4 DOWNTO 0)))(5) = '0' THEN
                        ARF(conv_integer(IdRegistrador(4 DOWNTO 0)))(4 DOWNTO 0) <= std_logic_vector(to_unsigned(i, 5));
                        EXIT;
                    END IF;
                END IF;
            END LOOP;
    END PROCESS Mapeamento;
END ARCHITECTURE;
