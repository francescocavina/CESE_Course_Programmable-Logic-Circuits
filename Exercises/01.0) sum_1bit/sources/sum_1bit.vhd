-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 1 bit full adder

library IEEE;
use IEEE.std_logic_1164.all;

entity sum_1bit is
    port(
        x_i:  in  std_logic; 
        y_i:  in  std_logic;
        ci_i: in  std_logic;
        z_o:  out std_logic;
        co_o: out std_logic
    );
end entity sum_1bit;

architecture sum_1bit_arch of sum_1bit is
    -- Declaration

begin
    -- Description
    z_o  <= x_i xor y_i xor ci_i;
    co_o <= (y_i and ci_i) or (x_i and y_i) or (x_i and ci_i);
end architecture sum_1bit_arch;       