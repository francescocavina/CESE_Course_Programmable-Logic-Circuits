-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a N bit shift register

library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg_Nbit is
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
end entity shift_reg_Nbit;

architecture shift_reg_Nbit_arch of shift_reg_Nbit is
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
    signal d: std_logic_vector(0 to N);

begin
    -- Description
    d(0)     <= input_i;
    shift_reg_i: for i in 0 to N-1 generate
        ffd_inst: ffd
            port map(
                d_i   => d(i),
                ena_i => ena_i,
                rst_i => rst_i,
                clk_i => clk_i,
                q_o   => d(i+1)
            );
    end generate;
    output_o <= d(N);
end architecture shift_reg_Nbit_arch;