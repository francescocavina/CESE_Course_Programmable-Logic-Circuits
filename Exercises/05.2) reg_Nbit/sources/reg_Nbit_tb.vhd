-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of an N bit register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_Nbit_tb is
end entity reg_Nbit_tb;

architecture reg_Nbit_tb_arch of reg_Nbit_tb is
    -- Declaration
    component reg_Nbit is
        generic(
            N: natural := 4
        );
        port(
            d_i:   in  std_logic_vector(N-1 downto 0);
            ena_i: in  std_logic;
            rst_i: in  std_logic;
            clk_i: in  std_logic;
            q_o:   out std_logic_vector(N-1 downto 0)
        );
    end component reg_Nbit;

    constant N_tb:   natural := 4; 
    signal   d_tb:   std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(1, N_tb));
    signal   ena_tb: std_logic := '0';
    signal   rst_tb: std_logic := '0';
    signal   clk_tb: std_logic := '0';
    signal   q_tb:   std_logic_vector(N_tb-1 downto 0);

begin
    -- Description
    clk_tb <= not clk_tb after  10 ns;
    d_tb   <= not   d_tb after 100 ns;
    ena_tb <= not ena_tb after 200 ns;
    rst_tb <= not rst_tb after 800 ns;

    DUT: reg_Nbit
        generic map(
            N => N_tb
        )
        port map(
            d_i   => d_tb,
            ena_i => ena_tb,
            rst_i => rst_tb,
            clk_i => clk_tb,
            q_o   => q_tb
        );
end architecture reg_Nbit_tb_arch;
