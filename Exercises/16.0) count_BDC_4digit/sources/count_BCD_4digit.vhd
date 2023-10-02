-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a 4 digit BCD counter

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity count_BCD_4digit is
    port(
        clk_i:  in  std_logic;
        rst_i:  in  std_logic;
        ena_i:  in  std_logic;
        bcd0_o: out std_logic_vector(3 downto 0);
        bcd1_o: out std_logic_vector(3 downto 0);
        bcd2_o: out std_logic_vector(3 downto 0);
        bcd3_o: out std_logic_vector(3 downto 0);
        co_o:   out std_logic
    );
end entity count_BCD_4digit;

architecture count_BCD_4digit_arch of count_BCD_4digit is
    -- Declaration
    component count_BCD is
        port(
            clk_i: in  std_logic;
            rst_i: in  std_logic;
            ena_i: in  std_logic;
            q_o:   out std_logic_vector(3 downto 0);
            max_o: out std_logic
        );
    end component count_BCD;

    --signal ena_sig: std_logic_vector(3 downto 0)  := (others => '0');
    --signal bcd_sig: std_logic_vector(15 downto 0) := (others => '0');
    --signal co_sig:  std_logic_vector(3 downto 0)  := (others => '0');

begin
    -- Description
    --count_BCD_i: for i in 0 downto 0 generate
        count_BCD_inst: count_BCD
            port map(
                clk_i => clk_i,
                rst_i => rst_i,
                --ena_i => ena_sig(i),
                ena_i => ena_i,
                q_o   => bcd0_o,
                --max_o => co_sig(i)
                max_o => co_o
            );
    --end generate;

    bcd1_o <= "0000";
    bcd2_o <= "0000";
    bcd3_o <= "0000";

    --bcd0_o     <= bcd_sig(3 downto 0);
    --bcd1_o     <= bcd_sig(7 downto 4);
    --bcd2_o     <= bcd_sig(11 downto 8);
    --bcd3_o     <= bcd_sig(15 downto 12);
    --co_o       <= co_sig(3);
    --ena_sig(3) <= ena_sig(2) and co_sig(2);
    --ena_sig(2) <= ena_sig(1) and co_sig(1);
    --ena_sig(1) <= ena_sig(0) and co_sig(0);
    --ena_sig(0) <= ena_i;
end count_BCD_4digit_arch;