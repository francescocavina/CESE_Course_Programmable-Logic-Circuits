-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a N bit register

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_Nbit is
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
end entity reg_Nbit;

architecture reg_Nbit_arch of reg_Nbit is
    -- Declaration
    component ffd is
        port(
            d_i:   in  std_logic;
            ena_i: in  std_logic;
            rst_i: in  std_logic;
            clk_i: in  std_logic;
            q_o:   out std_logic
        );
    end component ffd;

begin
    -- Description
    reg_Nbit_i: for i in N-1 downto 0 generate
        ffd_inst: ffd
            port map(
                d_i => d_i(i),
                ena_i => ena_i,
                rst_i => rst_i,
                clk_i => clk_i,
                q_o   => q_o(i)
            );
    end generate;
end architecture reg_Nbit_arch;