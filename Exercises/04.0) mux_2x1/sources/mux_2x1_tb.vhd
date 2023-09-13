-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a 2x1 multiplexer

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1_tb is
end entity mux_2x1_tb;    

architecture mux_2x1_tb_arch of mux_2x1_tb is
    -- Declaration
    component mux_2x1 is
        port(
            a_i:   in  std_logic;
            b_i:   in  std_logic;
            sel_i: in  std_logic;
            c_o:   out std_logic
        );
    end component mux_2x1;

        signal a_tb:   std_logic := '0';
        signal b_tb:   std_logic := '0';
        signal sel_tb: std_logic := '0';
        signal c_tb:   std_logic;

    begin
        -- Description
        a_tb   <= not a_tb   after 200 ns;
        b_tb   <= not b_tb   after 100 ns;
        sel_tb <= not sel_tb after  50 ns;

        DUT: mux_2x1
            port map(
                a_i   => a_tb, 
                b_i   => b_tb,
                sel_i => sel_tb,
                c_o   => c_tb
            );
end architecture mux_2x1_tb_arch;