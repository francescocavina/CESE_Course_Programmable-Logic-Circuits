-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a 4 bit binary counter

library IEEE;
use IEEE.std_logic_1164.all;

entity count_BCD_tb is
end entity count_BCD_tb;

architecture count_BCD_tb_arch of count_BCD_tb is
    -- Declaration
    component count_BCD is
         port(
            clk_i: in  std_logic;
            rst_i: in  std_logic;
            ena_i: in  std_logic;
            q_o:   out std_logic_vector(3 downto 0);
            max_o: out std_logic
        );
    end component count_BCD;

    signal   clk_tb:  std_logic := '0';
    signal   rst_tb:  std_logic := '1';
    signal   ena_tb:  std_logic := '1';
    signal   q_tb:    std_logic_vector(3 downto 0);
    signal   max_tb:  std_logic;

begin
    -- Description

    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after  10 ns, '1' after 800 ns, '0' after 900 ns;
    --ena_tb <= '0' after 500 ns, '1' after 700 ns;

    DUT: count_BCD
         port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            q_o   => q_tb,
            max_o => max_tb
        );
end architecture count_BCD_tb_arch;