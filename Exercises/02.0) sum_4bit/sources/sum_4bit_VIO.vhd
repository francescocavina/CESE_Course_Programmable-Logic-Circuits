library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_4bit_VIO is
    port( 
        clk_i: in std_logic
    );
end entity sum_4bit_VIO;

architecture sum_4bit_VIO_arch of sum_4bit_VIO is
    -- Declaration
    signal   probe_x:  std_logic_vector(3 downto 0);
    signal   probe_y:  std_logic_vector(3 downto 0);
    signal   probe_ci: std_logic;
    signal   probe_z:  std_logic_vector(3 downto 0);
    signal   probe_co: std_logi;

begin
    -- Description
    sum_Nb_inst: entity work.sum_4bit_VIO
        port map(
            x_i  => probe_x,
            y_i  => probe_y,
            ci_i => probe_ci,
            z_o  => probe_z,
            co_o => probe_co
        ); 
end sum_4bit_VIO_arch;

