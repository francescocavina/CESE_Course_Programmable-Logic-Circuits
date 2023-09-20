-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of an N bit shift register

library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg_Nbit_tb is
end entity shift_reg_Nbit_tb;

architecture shift_reg_Nbit_tb_arch of shift_reg_Nbit_tb is
    -- Declaration
    component shift_reg_Nbit is
        generic(
            N: natural := 4
        );
        port(
            input_i:  in  std_logic;
            ena_i:    in  std_logic;
            rst_i:    in  std_logic;
            clk_i:    in  std_logic;
            output_o: out std_logic
        );
    end component shift_reg_Nbit;

    constant N_tb:      natural   := 4;
    signal   input_tb:  std_logic := '0';
    signal   ena_tb:    std_logic := '1';
    signal   rst_tb:    std_logic := '0';
    signal   clk_tb:    std_logic := '0';
    signal   output_tb: std_logic;

begin
    -- Description
    clk_tb   <= not(clk_tb) after 50 ns;
    input_tb <= '1' after 250 ns, '0' after 450 ns, '1' after 650 ns, '0' after 850 ns;

    DUT: shift_reg_Nbit 
        generic map(
            N => N_tb
        )
        port map(
            input_i  => input_tb,
            ena_i    => ena_tb,
            rst_i    => rst_tb,
            clk_i    => clk_tb,
            output_o => output_tb
        );
end architecture shift_reg_Nbit_tb_arch;