-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a BCD counter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity count_BCD_4digit_tb is
end entity count_BCD_4digit_tb;

architecture count_BCD_4digit_tb_arch of count_BCD_4digit_tb is
    -- Declaration
    component count_BCD_4digit is
        port(
            clk_i:  in  std_logic;
            rst_i:  in  std_logic;
            ena_i:  in  std_logic;
            bcd0_o: out std_logic_vector(3 downto 0);
            bcd1_o: out std_logic_vector(3 downto 0);
            bcd2_o: out std_logic_vector(3 downto 0);
            bcd3_o: out std_logic_vector(3 downto 0);
            co_o:   out std_logic
        );
    end component count_BCD_4digit;

    signal clk_tb:  std_logic := '0';
    signal rst_tb:  std_logic := '0';
    signal ena_tb:  std_logic := '0';
    signal bcd0_tb: std_logic_vector(3 downto 0);
    signal bcd1_tb: std_logic_vector(3 downto 0);
    signal bcd2_tb: std_logic_vector(3 downto 0);
    signal bcd3_tb: std_logic_vector(3 downto 0);
    signal co_tb:   std_logic;

begin
    -- Description
    clk_tb <= not clk_tb after 50 ns;
    rst_tb <= '1' after 30 ns, '0' after 40 ns;
    ena_tb <= '1' after 20 ns;
    
    DUT: count_BCD_4digit
        port map(
            clk_i  => clk_tb,
            rst_i  => rst_tb,
            ena_i  => ena_tb,
            bcd0_o => bcd0_tb,
            bcd1_o => bcd1_tb,
            bcd2_o => bcd2_tb,
            bcd3_o => bcd3_tb,
            co_o   => co_tb
        );
end count_BCD_4digit_tb_arch;