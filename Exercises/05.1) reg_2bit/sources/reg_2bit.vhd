-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 2 bit register

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_2bit is
    port(
        d_i:   in  std_logic_vector(1 downto 0);
        ena_i: in  std_logic;
        rst_i: in  std_logic;
        clk_i: in  std_logic;
        q_o:   out std_logic_vector(1 downto 0)
    );
end entity reg_2bit;

architecture reg_2bit_arch of reg_2bit is
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
        ffd0_inst: ffd
            port map(
                d_i   => d_i(0),
                ena_i => ena_i,
                rst_i => rst_i,
                clk_i => clk_i,
                q_o   => q_o(0)
            );

        ffd1_inst: ffd
            port map(
                d_i   => d_i(1),
                ena_i => ena_i,
                rst_i => rst_i,
                clk_i => clk_i,
                q_o   => q_o(1)
            );
end architecture reg_2bit_arch;