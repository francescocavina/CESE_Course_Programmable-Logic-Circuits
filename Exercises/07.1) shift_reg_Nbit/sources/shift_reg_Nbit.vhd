-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 bit shift register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
    signal d: std_logic_vector(0 to N-1);

begin
    -- Description
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            d <= (others => '0');
        elsif rising_edge(clk_i) then
            if ena_i = '1' then
                output_o <= d(N-1);
                d(1 to N-1) <= d(0 to N-2);
                d(0) <= input_i;
            end if;    
        end if;
    end process;
end architecture shift_reg_Nbit_arch;