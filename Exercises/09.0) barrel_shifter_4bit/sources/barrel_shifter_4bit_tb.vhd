-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a 4 bit barrel shifter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter_4bit_tb is
end entity barrel_shifter_4bit_tb;

architecture barrel_shifter_4bit_tb_arch of barrel_shifter_4bit_tb is
    -- Declaration
    component barrel_shifter_4bit is
        port(
            x_i:     in  std_logic_vector(3 downto 0);
            shift_i: in  std_logic_vector(1 downto 0);
            y_o:     out std_logic_vector(3 downto 0)
        );
    end component barrel_shifter_4bit;

    signal x_tb:     std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(1, 4));
    signal shift_tb: std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(0, 2));
    signal y_tb:     std_logic_vector(3 downto 0);    

begin
    -- Description
    shift_tb <= "01" after 200 ns, "10" after 400 ns, "11" after 600 ns, "00" after 800 ns;

    DUT: barrel_shifter_4bit
        port map(
            x_i     => x_tb,
            shift_i => shift_tb,
            y_o     => y_tb
        );
end architecture barrel_shifter_4bit_tb_arch;