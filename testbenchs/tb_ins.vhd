library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity tb_ins is
end tb_ins;

architecture arch_ins of tb_ins is
    -- declaração do tipo memoria
    type channels is array (0 to 3) of std_logic_vector (31 downto 0);
    type memory is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal mem : memory;
    -- 
    constant clock_period : time    := 20 ns;
    signal clock_count    : integer := 0;
    --
    signal clock_tb : std_logic                     := '0';
    signal reset_tb : std_logic                     := '0';
    signal take_tb  : std_logic                     := '0';
    signal pc_in_tb : std_logic_vector(31 downto 0) := (others => '0');
    --
    signal pc0_tb, pc1_tb, pc2_tb, pc3_tb                             : std_logic_vector (31 downto 0) := (others => '0');
    signal ins_order0_tb, ins_order1_tb, ins_order2_tb, ins_order3_tb : std_logic_vector (31 downto 0) := (others => '0');
    signal date0_tb, date1_tb, date2_tb, date3_tb                     : std_logic_vector (31 downto 0) := (others => '0');
    --
    component ins is
        port
        (
            clk, reset, take                               : in std_logic;
            pc_in                                          : in std_logic_vector (31 downto 0);
            pc0, pc1, pc2, pc3                             : out std_logic_vector (31 downto 0);
            ins_order0, ins_order1, ins_order2, ins_order3 : out std_logic_vector (31 downto 0)
        );
    end component;
    -- função que realiza a leitura do arquivo
    impure function init_memory (name_file : in string)
        return memory is file file_m           : text open read_mode is name_file;
        variable line_m                        : line;
        variable temp_bv                       : bit_vector(7 downto 0);
        variable temp_mem                      : memory;
    begin
        for i in 0 to 1023 loop
            readline(file_m, line_m);
            read(line_m, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
        end loop;
        return temp_mem;
    end function;
    --
begin
    --
    DUT : ins
    port map
    (
        clk        => clock_tb,
        reset      => reset_tb,
        take       => take_tb,
        pc_in      => pc_in_tb,
        pc0        => pc0_tb,
        pc1        => pc1_tb,
        pc2        => pc2_tb,
        pc3        => pc3_tb,
        ins_order0 => ins_order0_tb,
        ins_order1 => ins_order1_tb,
        ins_order2 => ins_order2_tb,
        ins_order3 => ins_order3_tb
    );
    --
    process_clock : process
    begin
        clock_tb <= '0';
        wait for clock_period/2;
        clock_tb <= '1';
        wait for clock_period/2;
        clock_count <= clock_count + 1;

        if (clock_count = 32) then
            wait;
        end if;
    end process;
    --
    process_reset : process
    begin
        reset_tb <= '1';
        wait for clock_period/2;
        reset_tb <= '0';
        wait for clock_period/2;
        mem <= init_memory("memory/memory.dat");
        wait;
    end process;
    --
    process_buffer : process
    begin
        take_tb <= '1';
        wait for clock_period;
        take_tb <= '0';
        wait for clock_period;
        take_tb  <= '1';
        pc_in_tb <= "00000000000000000000000000001000";
        wait for clock_period;
        take_tb <= '0';
        wait for clock_period;
        take_tb  <= '1';
        pc_in_tb <= "00000000000000000000000000100000";
        wait for clock_period;
        take_tb <= '0';
        wait for clock_period;
        wait;
    end process;
    --
    process_read : process (clock_tb)
    begin
        if (clock_tb'EVENT and clock_tb = '1') then
            --
            date0_tb(7 downto 0)   <= mem(conv_integer(pc0_tb));
            date0_tb(15 downto 8)  <= mem(conv_integer(pc0_tb) + 1);
            date0_tb(23 downto 16) <= mem(conv_integer(pc0_tb) + 2);
            date0_tb(31 downto 24) <= mem(conv_integer(pc0_tb) + 3);
            --
            date1_tb(7 downto 0)   <= mem(conv_integer(pc1_tb));
            date1_tb(15 downto 8)  <= mem(conv_integer(pc1_tb) + 1);
            date1_tb(23 downto 16) <= mem(conv_integer(pc1_tb) + 2);
            date1_tb(31 downto 24) <= mem(conv_integer(pc1_tb) + 3);
            --
            date2_tb(7 downto 0)   <= mem(conv_integer(pc2_tb));
            date2_tb(15 downto 8)  <= mem(conv_integer(pc2_tb) + 1);
            date2_tb(23 downto 16) <= mem(conv_integer(pc2_tb) + 2);
            date2_tb(31 downto 24) <= mem(conv_integer(pc2_tb) + 3);
            --
            date3_tb(7 downto 0)   <= mem(conv_integer(pc3_tb));
            date3_tb(15 downto 8)  <= mem(conv_integer(pc3_tb) + 1);
            date3_tb(23 downto 16) <= mem(conv_integer(pc3_tb) + 2);
            date3_tb(31 downto 24) <= mem(conv_integer(pc3_tb) + 3);
        end if;
    end process;

end architecture;
