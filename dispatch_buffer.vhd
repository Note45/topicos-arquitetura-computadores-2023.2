library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dispatch_buffer is
    generic
    (
        BUFFER_DEPTH : integer := 64;
        BUFFER_WIDTH : integer := 32
    );
    port
    (
        clk : in std_logic;
        rst : in std_logic;

        -- Write port
        wr_en     : in std_logic_vector(3 downto 0);
        wr_data_0 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        wr_data_1 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        wr_data_2 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        wr_data_3 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);

        rd_valid : out std_logic_vector(3 downto 0);

        -- Read port
        rd_en     : in std_logic_vector(3 downto 0);
        rd_data_0 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        rd_data_1 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        rd_data_2 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
        rd_data_3 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);

        -- Flags
        empty      : out std_logic;
        empty_next : out std_logic;
        full       : out std_logic;
        full_next  : out std_logic;

        -- The number of elements in the FIFO
        fill_count : out integer range BUFFER_DEPTH - 1 downto 0
    );
end dispatch_buffer;

architecture arch of dispatch_buffer is
    type buffer_type is array (0 to BUFFER_DEPTH - 1) of std_logic_vector(wr_data_0'range);
    signal memory : buffer_type;

    type index_type is array(0 to 3) of integer range buffer_type'range;
    signal head : index_type;
    signal tail : index_type;

    signal empty_i      : std_logic;
    signal full_i       : std_logic;
    signal empty_next_i : std_logic;
    signal full_next_i  : std_logic;
    signal fill_count_i : integer range BUFFER_DEPTH - 1 downto 0;

    type interface is array (0 to 3) of std_logic_vector(wr_data_0'range);

    signal data_in : interface;
    signal move_t  : integer range 4 downto 0;
    signal sum_t   : std_logic_vector(1 downto 0);

    signal data_out : interface;
    signal move_h   : integer range 4 downto 0;
    signal sum_h    : std_logic_vector(1 downto 0);

    -- Increment and wrap
    procedure incr(
        signal index : inout index_type;
        signal move  : in integer range 4 downto 0) is
    begin
        for i in 0 to index_type'high loop
            if (index(i) + move) <= buffer_type'high then
                index(i)             <= index(i) + move;
            else
                index(i) <= (index(i) + move) - (buffer_type'high + 1);
            end if;
        end loop;
    end procedure;

    -- Init index_type tail
    procedure init_t(signal index : inout index_type) is
    begin
        for i in 0 to index_type'high loop
            index(index_type'high - i) <= buffer_type'high - i;
        end loop;
    end procedure;

    -- Init index_type head
    procedure init_h(signal index : inout index_type) is
    begin
        for i in 0 to index_type'high loop
            index(i) <= i;
        end loop;
    end procedure;

begin
    -- The number of the valid input
    sum_t  <= ('0' & wr_en(0)) + ('0' & wr_en(1)) + ('0' & wr_en(2)) + ('0' & wr_en(3));
    move_t <= to_integer(unsigned(sum_t));

    data_in(0) <=
    wr_data_0 when wr_en(0) = '1' else
    wr_data_1 when wr_en(1) = '1' else
    wr_data_2 when wr_en(2) = '1' else
    wr_data_3;

    data_in(1) <=
    wr_data_1 when wr_en(1) = '1' else
    wr_data_2 when wr_en(2) = '1' else
    wr_data_3;

    data_in(2) <=
    wr_data_2 when wr_en(2) = '1' else
    wr_data_3;

    data_in(3) <=
    wr_data_3;

    move_tail : process (clk, rst)
    begin
        if (rst = '1') then
            init_t(tail);
        elsif rising_edge(clk) then
            incr(tail, move_t);
        end if;
    end process; -- tail

    -------------------------------------------------------
    sum_h  <= ('0' & rd_en(0)) + ('0' & rd_en(1)) + ('0' & rd_en(2)) + ('0' & rd_en(3));
    move_h <= to_integer(unsigned(sum_h));
    move_head : process (clk, rst)
    begin
        if (rst = '1') then
            init_h(head);
        elsif rising_edge(clk) then
            incr(head, move_h);
        end if;
    end process; -- head

    write : process (clk)
    begin
        -- write
        if falling_edge(clk) then
            if move_t = 4 then
                memory(tail(0)) <= data_in(0);
                memory(tail(1)) <= data_in(1);
                memory(tail(2)) <= data_in(2);
                memory(tail(3)) <= data_in(3);
            elsif move_t = 3 then
                memory(tail(1)) <= data_in(0);
                memory(tail(2)) <= data_in(1);
                memory(tail(3)) <= data_in(2);
            elsif move_t = 2 then
                memory(tail(2)) <= data_in(0);
                memory(tail(3)) <= data_in(1);
            elsif move_t = 1 then
                memory(tail(3)) <= data_in(0);
            else
            end if;
        end if;
        -- read
        if rising_edge(clk) then
            if move_h = 4 then
                rd_data_0 <= memory(head(0));
                rd_data_1 <= memory(head(1));
                rd_data_2 <= memory(head(2));
                rd_data_3 <= memory(head(3));
            elsif move_h = 3 then
                rd_data_0 <= memory(head(0));
                rd_data_1 <= memory(head(1));
                rd_data_2 <= memory(head(2));
            elsif move_h = 2 then
                rd_data_0 <= memory(head(0));
                rd_data_1 <= memory(head(1));
            elsif move_h = 1 then
                rd_data_0 <= memory(head(0));
            else
            end if;
        end if;

    end process; -- write

    -- Copy internal signals to output
    empty      <= empty_i;
    empty_next <= empty_next_i;
    full       <= full_i;
    full_next  <= full_next_i;
    fill_count <= fill_count_i;

    -- Set the flags
    empty_i      <= '1' when fill_count_i = 0 else '0';
    empty_next_i <= '1' when fill_count_i < 4 else '0';
    full_i       <= '1' when fill_count_i >= BUFFER_DEPTH - 1 else '0';
    full_next_i  <= '1' when fill_count_i >= BUFFER_DEPTH - 5 else '0';

    -- Update the fill count
    count : process (head, tail)
    begin
        if tail(0) >= head(0) then
            fill_count_i <= tail(0) - head(0);
        else
            fill_count_i <= tail(0) - head(0) + BUFFER_DEPTH;
        end if;
    end process;

end architecture;
