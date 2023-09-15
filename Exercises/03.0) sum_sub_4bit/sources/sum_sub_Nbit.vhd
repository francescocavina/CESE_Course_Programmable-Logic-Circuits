-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an N bit full adder/substractor

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_sub_Nbit is
    generic(
        N: natural := 4
    );
    port(
        x_i:   in  std_logic_vector(N-1 downto 0);
        y_i:   in  std_logic_vector(N-1 downto 0);
        ci_i:  in  std_logic;
        sel_i: in  std_logic;
        z_o:   out std_logic_vector(N-1 downto 0);
        co_o:  out std_logic
    );
end entity sum_sub_Nbit;

architecture sum_sub_Nbit_arch of sum_sub_Nbit is
    -- Declaration
    signal res_aux: unsigned(N+1 downto 0);

    begin
        -- Description
        if sel_i = '0' then
            res_aux <= unsigned('0' & x_i & ci_i) + unsigned('0' & y_i & '1');
        else
            res_aux <= unsigned('0' & x_i & ci_i) - unsigned('0' & y_i & '1');
        end if;

        z_o <= std_logic_vector(res_aux(N downto 1));
        co_o <= res_aux(N+1);    

end architecture sum_sub_Nbit_arch;