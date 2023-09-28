-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 bit full adder

library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity sum_4bit is
    port(
        x_i:  in  std_logic_vector(3 downto 0);
        y_i:  in  std_logic_vector(3 downto 0);
        ci_i: in  std_logic;
        z_o:  out std_logic_vector(3 downto 0); 
        co_o: out std_logic
    );
end entity sum_4bit;

architecture sum_4bit_arch of sum_4bit is
    -- Declaration
    signal sum_aux: unsigned(5 downto 0);

begin
    -- Description
    sum_aux <= unsigned('0' & x_i & ci_i) + unsigned('0' & y_i & '1');
    z_o <= std_logic_vector(sum_aux(4 downto 1));
    co_o <= sum_aux(5);
end architecture sum_4bit_arch;