-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of an N bit barrel shifter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter_Nbit_tb is
end entity barrel_shifter_Nbit_tb;

architecture barrel_shifter_Nbit_tb_arch of barrel_shifter_Nbit_tb is
    -- Declaration
    component barrel_shifter_Nbit is
        generic(
            -- N = 2 ^ M
            N: natural := 4;
            M: natural := 2
        );
        port(
            x_i:     in  std_logic_vector(N-1 downto 0);
            shift_i: in  std_logic_vector(M-1 downto 0);
            y_o:     out std_logic_vector(N-1 downto 0)
        );
    end component barrel_shifter_Nbit;

    constant N_tb:     natural := 4;
    constant M_tb:     natural := 2;
    signal   x_tb:     std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(1, N_tb));
    signal   shift_tb: std_logic_vector(M_tb-1 downto 0) := std_logic_vector(to_unsigned(0, M_tb));
    signal   y_tb:     std_logic_vector(N_tb-1 downto 0);    

begin
    -- Description
    shift_tb <= "01" after 200 ns, "10" after 400 ns, "11" after 600 ns, "00" after 800 ns;

    DUT: barrel_shifter_Nbit
        generic map(
            N => N_tb,
            M => M_tb
        )
        port map(
            x_i     => x_tb,
            shift_i => shift_tb,
            y_o     => y_tb
        );
end architecture barrel_shifter_Nbit_tb_arch;