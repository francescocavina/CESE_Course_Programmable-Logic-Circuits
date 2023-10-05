-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a floating point adder

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity floating_point_adder is
    generic(
        PRECISION_BITS: natural := 32; -- Single precision floating point IEEE 754
        EXPONENT_BITS:  natural := 8;  -- Single precision floating point IEEE 754
        MANTISSA_BITS:  natural := 23; -- Single precision floating point IEEE 754
        SIGN_BITS:      natural := 1   -- Single precision floating point IEEE 754
        -- PRECISION_BITS: natural := 64  -- Double precision floating point IEEE 754
        -- EXPONENT_BITS:  natural := 11; -- Double precision floating point IEEE 754
        -- MANTISSA_BITS:  natural := 52  -- Double precision floating point IEEE 754
        -- SIGN_BITS:      natural := 1   -- Double precision floating point IEEE 754
    );
    port(
        clk_in: in  std_logic;
        a_in:   in  std_logic_vector(PRECISION_BITS-1 downto 0);
        b_in:   in  std_logic_vector(PRECISION_BITS-1 downto 0);
        ci_in:  in  std_logic;
        rst_in: in  std_logic;
        c_out:  out std_logic_vector(PRECISION_BITS-1 downto 0);
        co_out: out std_logic
    );
end entity floating_point_adder;

architecture floating_point_adder_arch of floating_point_adder is
    -- Declaration
    signal exponent_a: std_logic_vector(EXPONENT_BITS-1 downto 0);
    signal exponent_b: std_logic_vector(EXPONENT_BITS-1 downto 0);
    signal mantissa_a: std_logic_vector(MANTISSA_BITS   downto 0);
    signal mantissa_b: std_logic_vector(MANTISSA_BITS   downto 0);

begin
    -- Description
    process(clk_in) is
        -- Declarations
        variable exponent_diff: natural := 0;

    begin
        -- Extract exponents
        exponent_a <= a_in(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS+1);
        exponent_b <= b_in(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS+1);
        
        -- Extract mantissas
        mantissa_a <= '1' & a_in(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0);
        mantissa_b <= '1' & b_in(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0);

        -- Check if exponents are equal
        if(exponent_a = exponent_b) then
            exponent_diff := 0;
        elsif(exponent_a > exponent_b) then
            exponent_diff := to_integer(unsigned(exponent_a)) - to_integer(unsigned(exponent_b));
        else
            exponent_diff := to_integer(unsigned(exponent_b)) - to_integer(unsigned(exponent_a));
        end if;
    end process;

end architecture floating_point_adder_arch;