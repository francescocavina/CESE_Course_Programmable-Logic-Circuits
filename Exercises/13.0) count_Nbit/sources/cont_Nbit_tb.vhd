-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of an N bit binary counter

library IEEE;
use IEEE.std_logic_1164.all;

entity cont_Nbit_tb is
end entity cont_Nbit_tb;

architecture cont_Nbit_tb_arch of cont_Nbit_tb is
    -- Declaration
    component cont_Nbit is
        generic(
            N: natural := 4
        );
        port(
            clk_i: in  std_logic;
            rst_i: in  std_logic;
            ena_i: in  std_logic;
            q_o:   out std_logic_vector(N-1 downto 0);
            max_o: out std_logic
        );
    end component cont_Nbit;

    constant N_tb:    natural   := 8;
    signal   clk_tb:  std_logic := '0';
    signal   rst_tb:  std_logic := '1';
    signal   ena_tb:  std_logic := '1';
    signal   q_tb:    std_logic_vector(N_tb-1 downto 0);
    signal   max_tb:  std_logic;

begin
    -- Description
    clk_tb <= not clk_tb after 10 ns;
    rst_tb <= '0' after    10 ns;
    ena_tb <= '0' after 10300 ns;

    DUT: cont_Nbit
        generic map(
            N => N_tb
        )
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            ena_i => ena_tb,
            q_o   => q_tb,
            max_o => max_tb
        );
end architecture cont_Nbit_tb_arch;