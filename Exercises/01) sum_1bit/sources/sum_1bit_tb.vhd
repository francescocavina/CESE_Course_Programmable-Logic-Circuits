-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This the testbench of a 1 bit full adder

library IEEE;
use IEEE.std_logic_1164.all;

entity sum_1bit_tb is
end entity sum_1bit_tb;

architecture sum_1bit_tb_arch of sum_1bit_tb is
    -- Declaration
    component sum_1bit is
        port(
            x_i:  in  std_logic; 
            y_i:  in  std_logic;
            ci_i: in  std_logic;
            z_o:  out std_logic;
            co_o: out std_logic
        );
    end component sum_1bit;

    signal x_tb:  std_logic := '0';
    signal y_tb:  std_logic := '0';
    signal ci_tb: std_logic := '0';
    signal z_tb:  std_logic;
    signal co_tb: std_logic;

begin
    -- Description

    x_tb  <= '1' after 200 ns, '0' after 400 ns;
    y_tb  <= '1' after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns;
    ci_tb <= '1' after  50 ns, '0' after 100 ns, '1' after 150 ns, '0' after 200 ns, '1' after 250 ns, '0' after 300 ns, '1' after 350 ns, '0' after 400 ns;

    DUT: sum_1bit
        port map(
            x_i  => x_tb,
            y_i  => y_tb,
            ci_i => ci_tb,
            z_o  => z_tb,
            co_o => co_tb
        );
end architecture sum_1bit_tb_arch;