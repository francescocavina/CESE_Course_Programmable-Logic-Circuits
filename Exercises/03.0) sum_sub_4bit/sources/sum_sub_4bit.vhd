-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 bit full adder/substractor

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_sub_4bit is
    port(
        x_i:   in  std_logic_vector(3 downto 0);
        y_i:   in  std_logic_vector(3 downto 0);
        ci_i:  in  std_logic;
        sel_i: in  std_logic;
        z_o:   out std_logic_vector(3 downto 0);
        co_o:  out std_logic
    );
end entity sum_sub_4bit;

architecture sum_sub_4bit_arch of sum_sub_4bit is
    -- Declaration
    signal res_aux: unsigned(5 downto 0);

begin
    -- Description
    process(x_i, y_i, ci_i, sel_i)
    begin    
        if sel_i = '0' then
            res_aux <= unsigned('0' & x_i & ci_i) + unsigned('0' & y_i & '1');
        else
            res_aux <= unsigned('0' & x_i & '1') + unsigned('0' & (not y_i) & '1');
        end if;
    end process;    

    z_o <= std_logic_vector(res_aux(4 downto 1));
    co_o <= res_aux(5);    
end architecture sum_sub_4bit_arch;