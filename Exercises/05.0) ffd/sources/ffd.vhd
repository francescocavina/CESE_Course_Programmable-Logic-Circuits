-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a flip-flop D

library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
    port(
        d_i:   in  std_logic;
        ena_i: in  std_logic;
        rst_i: in  std_logic;
        clk_i: in  std_logic;
        q_o:   out std_logic
    );
end entity ffd;

architecture ffd_arch of ffd is
    -- Declaration

    begin
        -- Description
        process(clk_i) is
        begin
            if rising_edge(clk_i) then
                if rst_i = '1' then
                    q_o <= '0';
                elsif ena_i = '1' then
                    q_o <= d_i;
                end if;         
            end if;      
        end process;    
end architecture ffd_arch;


