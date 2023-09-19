-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an N bit binary counter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cont_Nbit is
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
end entity cont_Nbit;

architecture cont_Nbit_arch of cont_Nbit is
    -- Declaration

    signal salOr:   std_logic;
    signal salAnd:  std_logic;
    signal salSum:  std_logic_vector(N-1 downto 0);
    signal salQ:    std_logic_vector(N-1 downto 0);
    signal salComp: std_logic;

begin
    -- Description
    reg_Nbit_ins: entity work.reg_Nbit
        generic map(
            N => N
        )
        port map(
            clk_i => clk_i,
            rst_i => salOr,
            ena_i => ena_i,
            d_i   => salSum,
            q_o   => salQ
        );

    salSum  <= std_logic_vector(unsigned(salQ) + 1);    
    salComp <= '1' when salQ = std_logic_vector(to_unsigned((2**N)-1, N)) else '0';
    salOr   <= rst_i or salAnd;
    salAnd  <= ena_i and salComp;
    max_o   <= salComp;
    q_o     <= salQ;
end architecture cont_Nbit_arch;