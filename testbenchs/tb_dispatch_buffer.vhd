library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dispatch_buffer_tb is
end dispatch_buffer_tb;

architecture tb_arch of dispatch_buffer_tb is
    constant BUFFER_DEPTH : integer := 16;
    constant BUFFER_WIDTH : integer := 32;
    
    signal tb_clk, tb_rst : std_logic := '0';
    
    signal tb_wr_en : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_wr_data_0, tb_wr_data_1, tb_wr_data_2, tb_wr_data_3 : std_logic_vector(BUFFER_WIDTH - 1 downto 0);

    signal tb_rd_en : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_rd_valid : std_logic_vector(3 downto 0);
    signal tb_rd_data_0, tb_rd_data_1, tb_rd_data_2, tb_rd_data_3 : std_logic_vector(BUFFER_WIDTH - 1 downto 0);
    signal tb_empty, tb_empty_next, tb_full, tb_full_next : std_logic;
    signal tb_fill_count : integer range BUFFER_DEPTH - 1 downto 0;
    
    component dispatch_buffer is
        generic (
            BUFFER_DEPTH : integer := 16;
            BUFFER_WIDTH : integer := 32
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            
            wr_en : in std_logic_vector(3 downto 0);
            wr_data_0 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            wr_data_1 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            wr_data_2 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            wr_data_3 : in std_logic_vector(BUFFER_WIDTH - 1 downto 0);

            rd_valid : out std_logic_vector(3 downto 0);
            
            rd_en : in std_logic_vector(3 downto 0);
            rd_data_0 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            rd_data_1 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            rd_data_2 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);
            rd_data_3 : out std_logic_vector(BUFFER_WIDTH - 1 downto 0);

            empty : out std_logic;
            empty_next : out std_logic;
            full : out std_logic;
            full_next : out std_logic;
            fill_count : out integer range BUFFER_DEPTH - 1 downto 0
        );
    end component;

begin

    DUT: dispatch_buffer
    generic map (
        BUFFER_DEPTH => BUFFER_DEPTH,
        BUFFER_WIDTH => BUFFER_WIDTH
    )
    port map (
        clk => tb_clk,
        rst => tb_rst,
        wr_en => tb_wr_en,
        wr_data_0 => tb_wr_data_0,
        wr_data_1 => tb_wr_data_1,
        wr_data_2 => tb_wr_data_2,
        wr_data_3 => tb_wr_data_3,
        rd_valid => tb_rd_valid,
        rd_en => tb_rd_en,
        rd_data_0 => tb_rd_data_0,
        rd_data_1 => tb_rd_data_1,
        rd_data_2 => tb_rd_data_2,
        rd_data_3 => tb_rd_data_3,
        empty => tb_empty,
        empty_next => tb_empty_next,
        full => tb_full,
        full_next => tb_full_next,
        fill_count => tb_fill_count
    );

    -- Clock process
    clk_process: process
    begin
        while now < 2000 ns loop
            tb_clk <= '0';
            wait for 5 ns;
            tb_clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Reset process
    rst_process: process
    begin
        tb_rst <= '1';
        wait for 10 ns;
        tb_rst <= '0';
        wait;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        wait for 20 ns; -- Wait for initial reset to settle
        
        -- Example test scenario
        tb_wr_en <= "0000"; 
        tb_wr_data_0 <= "00000000000000000000000000000000"; -- Write data to buffer 0
        tb_wr_data_1 <= "00000000000000000000000000000001"; -- Write data to buffer 0
        tb_wr_data_2 <= "00000000000000000000000000000010"; -- Write data to buffer 0
        tb_wr_data_3 <= "00000000000000000000000000000011"; -- Write data to buffer 0
        wait for 10 ns;
        tb_wr_en <= "0001"; 
        wait for 10 ns;
        tb_wr_en <= "0010"; 
        wait for 10 ns;
        tb_wr_en <= "0011"; 
        wait for 10 ns;
        tb_wr_en <= "0100"; 
        wait for 10 ns;
        tb_wr_en <= "0101"; 
        wait for 10 ns;
        tb_wr_en <= "0110"; 
        wait for 10 ns;
        tb_wr_en <= "0111"; 
        wait for 10 ns;
        tb_wr_en <= "1000"; 
        wait for 10 ns;
        tb_wr_en <= "1001"; 
        wait for 10 ns;
        tb_wr_en <= "1010"; 
        wait for 10 ns;
        tb_wr_en <= "1011"; 
        wait for 10 ns;
        tb_wr_en <= "1100"; 
        wait for 10 ns;
        tb_wr_en <= "1101"; 
        wait for 10 ns;
        tb_wr_en <= "1110"; 
        wait for 10 ns;
        tb_wr_en <= "1111";
        wait;
    end process;

end tb_arch;
