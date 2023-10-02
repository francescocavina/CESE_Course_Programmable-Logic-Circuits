-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an Nx1 multiplexer of 1 bit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_Nx1_1bit is
    generic(
        -- N = 2 ^ M
        N: natural := 4;
        M: natural := 2
    );
    port(
        x_i  : in  std_logic_vector(N-1 downto 0);
        sel_i: in  std_logic_vector(M-1 downto 0);
        y_o:   out std_logic
    );
end entity mux_Nx1_1bit;   

architecture mux_Nx1_1bit_arch of mux_Nx1_1bit is
    -- Declaration

begin
    -- Description
    y_o <= x_i(to_integer(unsigned(sel_i)));

end architecture mux_Nx1_1bit_arch;