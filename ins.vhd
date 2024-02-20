LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ins IS
    PORT (
        clk     : IN STD_LOGIC;
        reset   : IN STD_LOGIC;
        take    : IN STD_LOGIC;
        pc_in   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        pc0, pc1, pc2, pc3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ins_order0, ins_order1, ins_order2, ins_order3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END ins;

ARCHITECTURE arch OF ins IS
    --
    TYPE channels IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
    --
    SIGNAL pc_next : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL t_ins : channels := (OTHERS => (OTHERS => '0'));
    --
    SIGNAL n_ins : channels := (("00000000000000000000000000000001"), 
                               ("00000000000000000000000000000010"), 
                               ("00000000000000000000000000000011"), 
                               ("00000000000000000000000000000100"));
    --
    CONSTANT const_pc : channels := (("00000000000000000000000000000000"), 
                                    ("00000000000000000000000000000100"), 
                                    ("00000000000000000000000000001000"), 
                                    ("00000000000000000000000000001100"));

BEGIN
    -- 
    update_pc : PROCESS (clk, reset, take)
    BEGIN
        IF (reset = '1') THEN
            pc0 <= const_pc(0);
            pc1 <= const_pc(1);
            pc2 <= const_pc(2);
            pc3 <= const_pc(3);
        ELSIF (take = '1' AND (clk = '0' AND clk'EVENT)) THEN
            pc0 <= pc_in + const_pc(0);
            pc1 <= pc_in + const_pc(1);
            pc2 <= pc_in + const_pc(2);
            pc3 <= pc_in + const_pc(3);
            pc_next <= pc_in + STD_LOGIC_VECTOR(to_unsigned(16, pc_in'LENGTH));
        END IF;
    END PROCESS;

    update_ins : PROCESS (clk, reset, take)
    BEGIN
        IF (reset = '1') THEN
            ins_order0 <= "00000000000000000000000000000000";
            ins_order1 <= "00000000000000000000000000000000";
            ins_order2 <= "00000000000000000000000000000000";
            ins_order3 <= "00000000000000000000000000000000";
        ELSIF (take = '1' AND (clk = '0' AND clk'EVENT)) THEN
            ins_order0 <= t_ins(0);
            ins_order1 <= t_ins(1);
            ins_order2 <= t_ins(2);
            ins_order3 <= t_ins(3);

            FOR i IN 0 TO 3 LOOP
                n_ins(i) <= t_ins(i) + "00000000000000000000000000000100";
            END LOOP;

        ELSIF (take = '1' AND (clk = '1' AND clk'EVENT)) THEN
            FOR i IN 0 TO 3 LOOP
                t_ins(i) <= n_ins(i);
            END LOOP;
        END IF;

    END PROCESS;

END ARCHITECTURE; -- arch
