-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a 4 bit full adder 

library IEEE;
use IEEE.std_logic_1164.all;

entity sum_4bit_tb is
end entity sum_4bit_tb;

architecture sum_4bit_tb_arch of sum_4bit_tb is
    -- Declaration
    component sum_Nbit is
        generic(
            N: natural := 4
        );
        port(    
            x_i:  in  std_logic_vector(N-1 downto 0);
            y_i:  in  std_logic_vector(N-1 downto 0);
            ci_i: in  std_logic;
            z_o:  out std_logic_vector(N-1 downto 0);
            co_o: out std_logic_vector(N-1 downto 0)
        );
    end component sum_Nbit;  
    
    signal x_tb:  std_logic_vector(N-1 downto 0) := (others => '0');
    signal y_tb:  std_logic_vector(N-1 downto 0) := (others => '0');
    signal ci_tb: std_logic := '0';
    signal z_tb:  std_logic_vector(N-1 downto 0);
    signal co_tb: std_logic;

    begin
        -- Description

        x_tb  <= '1001' after 100 ns, '0011' after 200 ns;
        y_tb  <= '0011' after 100 ns, '1000' after 200 ns;
        ci_tb <=    '1' after 100 ns,    '0' after 200 ns;

        DUT: sum_Nbit
            generic map(
                N => M
            );
            port map(
                x_i  <= x_tb,
                y_i  <= y_tb,
                ci_i <= ci_tb,
                z_o  <= z_tb,
                co_o <= co_tb
            );
end architecture sum_4bit_tb_arch;