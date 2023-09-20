-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 bit binary counter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cont_4bit is
    port(
        clk_i: in  std_logic;
        rst_i: in  std_logic;
        ena_i: in  std_logic;
        q_o:   out std_logic_vector(3 downto 0);
        max_o: out std_logic
    );
end entity cont_4bit;

architecture cont_4bit_arch of cont_4bit is
    -- Declaration
    signal orOutput:   std_logic;
    signal andOutput:  std_logic;
    signal sumOutput:  std_logic_vector(3 downto 0);
    signal qOutput:    std_logic_vector(3 downto 0);
    signal compOutput: std_logic;

begin
    -- Description
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            qOutput <= (others => '0');
        elsif rising_edge(clk_i) then
            if ena_i = '1' then
                qOutput <= sumOutput; 
            end if;    
        end if;
    end process;    

    sumOutput  <= std_logic_vector(unsigned(qOutput) + 1);
    compOutput <= '1' when qOutput = std_logic_vector(to_unsigned(15, 4)) else '0';
    orOutput   <= rst_i or andOutput;
    andOutput  <= ena_i and compOutput;
    max_o   <= compOutput;
    q_o     <= qOutput;
end architecture cont_4bit_arch;