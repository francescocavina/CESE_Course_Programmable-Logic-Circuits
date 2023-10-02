-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of an Nx1 multiplexer of 1 bit

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_Nx1_1bit_tb is
end entity mux_Nx1_1bit_tb;    

architecture mux_Nx1_1bit_tb_arch of mux_Nx1_1bit_tb is
    -- Declaration
    component mux_Nx1_1bit is
        generic(
            -- N = 2 ^ M
            N: natural := 4;
            M: natural := 2
        );
        port(
            x_i  : in  std_logic_vector(N-1 downto 0);
            sel_i: in  std_logic_vector(M-1 downto 0);
            y_o:   out std_logic
        );
    end component mux_Nx1_1bit;   

        constant N_tb:   natural := 4;
        constant M_tb:   natural := 2;
        signal   x_tb:   std_logic_vector(N_tb-1 downto 0) := "0101";
        signal   sel_tb: std_logic_vector(M_tb-1 downto 0) := "00";
        signal   y_tb:   std_logic;

begin
    -- Description
    sel_tb <= "01" after  200 ns, "10" after 400 ns, "11" after 600  ns, "00" after 800 ns;

    DUT: mux_Nx1_1bit
        generic map(
            N => N_tb,
            M => M_tb
        )
        port map(
            x_i   => x_tb,
            sel_i => sel_tb,
            y_o   => y_tb
        );
end architecture mux_Nx1_1bit_tb_arch;