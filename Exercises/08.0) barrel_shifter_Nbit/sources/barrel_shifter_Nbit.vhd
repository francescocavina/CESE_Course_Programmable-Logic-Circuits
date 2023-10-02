-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for an N bit barrel shifter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter_Nbit is
    generic(
        -- N = 2 ^ M
        N: natural := 4;
        M: natural := 2
    );
    port(
        x_i:     in  std_logic_vector(N-1 downto 0);
        shift_i: in  std_logic_vector(M-1 downto 0);
        y_o:     out std_logic_vector(N-1 downto 0)
    );
end entity barrel_shifter_Nbit;

architecture barrel_shifter_Nbit_arch of barrel_shifter_Nbit is
    -- Declaration

begin
    -- Description
    process(x_i, shift_i)
    begin
        if(to_integer(unsigned(shift_i)) = 0) then
            y_o <= x_i;
        else
            y_o <= x_i(to_integer(unsigned(shift_i))-1 downto 0) & x_i(N-1 downto to_integer(unsigned(shift_i)));
        end if;    
    end process;
end architecture barrel_shifter_Nbit_arch;

