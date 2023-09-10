-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 2x1 multiplexer

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1 is
    port(
        a_i:   in  std_logic;
        b_i:   in  std_logic;
        sel_i: in  std_logic;
        c_o:   out std_logic
    );
end entity mux_2x1;   

architecture mux_2x1_arch of mux_2x1 is
    -- Declaration

    begin
        -- Description
        c_o <= (a_i and (not sel_i)) or (b_i and sel_i); 

end architecture mux_2x1_arch;