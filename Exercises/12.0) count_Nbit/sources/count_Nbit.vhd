-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an N bit binary counter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity count_Nbit is
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
end entity count_Nbit;

architecture count_Nbit_arch of count_Nbit is
    -- Declaration
    signal orOutput:   std_logic;
    signal andOutput:  std_logic;
    signal sumOutput:  std_logic_vector(N-1 downto 0);
    signal qOutput:    std_logic_vector(N-1 downto 0);
    signal compOutput: std_logic;

begin
    -- Description
    reg_Nbit_ins: entity work.reg_Nbit
        generic map(
            N => N
        )
        port map(
            clk_i => clk_i,
            rst_i => orOutput,
            ena_i => ena_i,
            d_i   => sumOutput,
            q_o   => qOutput
        );

    sumOutput  <= std_logic_vector(unsigned(qOutput) + 1);    
    compOutput <= '1' when qOutput = std_logic_vector(to_unsigned((2**N)-1, N)) else '0';
    orOutput   <= rst_i or andOutput;
    andOutput  <= ena_i and compOutput;
    max_o   <= compOutput;
    q_o     <= qOutput;
end architecture count_Nbit_arch;