-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 bit barrel shifter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter_4bit is
    port(
        x_i:     in  std_logic_vector(3 downto 0);
        shift_i: in  std_logic_vector(1 downto 0);
        y_o:     out std_logic_vector(3 downto 0)
    );
end entity barrel_shifter_4bit;

architecture barrel_shifter_4bit_arch of barrel_shifter_4bit is
    -- Declaration
    component mux_Nx1_1bit is
        generic(
            -- N = 2 ^ M
            N: natural := 4;
            M: natural := 2
        );
        port(
            x_i  : in  std_logic_vector(3 downto 0);
            sel_i: in  std_logic_vector(1 downto 0);
            y_o:   out std_logic
        );
    end component mux_Nx1_1bit;

    constant N: natural := 4;
    constant M: natural := 2;    

begin
    -- Description
        mux_inst3: mux_Nx1_1bit
            generic map(
                N => N,
                M => M
            )
            port map(
                x_i(0) => x_i(3),
                x_i(1) => x_i(0),
                x_i(2) => x_i(1),
                x_i(3) => x_i(2),
                sel_i  => shift_i,
                y_o    => y_o(3)
            );
            
        mux_inst2: mux_Nx1_1bit
            generic map(
                N => N,
                M => M
            )
            port map(
                x_i(0) => x_i(2),
                x_i(1) => x_i(3),
                x_i(2) => x_i(0),
                x_i(3) => x_i(1),
                sel_i  => shift_i,
                y_o    => y_o(2)
            );  
            
        mux_inst1: mux_Nx1_1bit
            generic map(
                N => N,
                M => M
            )
            port map(
                x_i(0) => x_i(1),
                x_i(1) => x_i(2),
                x_i(2) => x_i(3),
                x_i(3) => x_i(0),
                sel_i  => shift_i,
                y_o    => y_o(1)
            );  

        mux_inst0: mux_Nx1_1bit
            generic map(
                N => N,
                M => M
            )
            port map(
                x_i(0) => x_i(0),
                x_i(1) => x_i(1),
                x_i(2) => x_i(2),
                x_i(3) => x_i(3),
                sel_i  => shift_i,
                y_o    => y_o(0)
            );  
end architecture barrel_shifter_4bit_arch;