-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an N bit full adder

library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity sum_Nbit is
    generic(
        N: natural := 4
    );
    port(
        x_i:  in  std_logic_vector(N-1 downto 0);
        y_i:  in  std_logic_vector(N-1 downto 0);
        ci_i: in  std_logic;
        z_o:  out std_logic_vector(N-1 downto 0);
        co_o: out std_logic
    );
end entity sum_Nbit;

architecture sum_Nbit_arch of sum_Nbit is
    -- Declaration
    signal sum_aux: unsigned(N+1 downto 0);

    begin
        -- Description
        sum_aux <= unsigned('0' & x_i & ci_i) + unsigned('0' & y_i & '1');
        z_o <= std_logic_vector(sum_aux(N downto 1));
        co_o <= sum_aux(N+1);

end architecture sum_Nbit_arch;