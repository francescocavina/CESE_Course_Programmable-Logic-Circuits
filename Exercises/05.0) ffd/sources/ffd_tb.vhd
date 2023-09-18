-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a flip-flop D

library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_tb is
end entity ffd_tb;

architecture ffd_tb_arch of ffd_tb is
    -- Declaration
    component ffd is
        port(
            d_i:   in  std_logic;
            ena_i: in  std_logic;
            rst_i: in  std_logic;
            clk_i: in  std_logic;
            q_o:   out std_logic
        );
    end component ffd;

    signal d_tb:    std_logic := '0';
    signal ena_tb:  std_logic := '1';
    signal rst_tb:  std_logic := '0';
    signal clk_tb:  std_logic := '1';
    signal q_tb:    std_logic;

begin
    -- Description
    clk_tb <= not clk_tb after  10 ns;
    d_tb   <= not   d_tb after 100 ns;
    --ena_tb <= not ena_tb after 200 ns;
    --rst_tb <= not rst_tb after 500 ns;

    DUT: ffd
        port map(
            d_i   => d_tb,
            ena_i => ena_tb,
            rst_i => rst_tb,
            clk_i => clk_tb,
            q_o   => q_tb
        );
end architecture ffd_tb_arch;