-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a floating point adder

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity floating_point_adder_tb is
    -- Void entity
end entity floating_point_adder_tb;
    
architecture floating_point_adder_tb_arch of floating_point_adder_tb is
    -- Declaration
    component floating_point_adder is
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
    end component floating_point_adder;

    constant PRECISION_BITS_tb: natural := 32; -- Single precision floating point IEEE 754
    constant EXPONENT_BITS_tb:  natural := 8;  -- Single precision floating point IEEE 754
    constant MANTISSA_BITS_tb:  natural := 23; -- Single precision floating point IEEE 754
    constant SIGN_BITS_tb:      natural := 1;  -- Single precision floating point IEEE 754
    -- constant PRECISION_BITS_tb: natural := 64; -- Double precision floating point IEEE 754
    -- constant EXPONENT_BITS_tb:  natural := 11; -- Double precision floating point IEEE 754
    -- constant MANTISSA_BITS_tb:  natural := 52; -- Double precision floating point IEEE 754
    -- constant SIGN_BITS_tb:      natural := 1;  -- Double precision floating point IEEE 754

    signal clk_tb: std_logic := '0';
    signal a_tb:   std_logic_vector(PRECISION_BITS_tb-1 downto 0) := (others => '0');
    signal b_tb:   std_logic_vector(PRECISION_BITS_tb-1 downto 0) := (others => '0');
    signal ci_tb:  std_logic := '0';
    signal rst_tb: std_logic := '0';
    signal c_tb:   std_logic_vector(PRECISION_BITS_tb-1 downto 0);
    signal co_tb:  std_logic;

begin
    -- Description

    clk_tb <= not clk_tb after 50 ns;
    -- TEST CASE #1 / expected result = +3.845
    a_tb   <= "00111111101011000010100011110110" after 200 ns; -- a_tb = +1.345 (0x3FAC28F6)
    b_tb   <= "01000000001000000000000000000000" after 200 ns; -- b_tb = +2.5   (0x40200000)
    -- TEST CASE #2 / expected result = 
    -- a_tb   <= "01000000010001011111101001000100" after 200 ns; -- a_tb = +3.0934 (0x4045FA44)
    -- b_tb   <= "01000001010001110011001100110011" after 200 ns; -- b_tb = +12.45  (0x41473333)
    
    DUT: floating_point_adder
    generic map(
        PRECISION_BITS => PRECISION_BITS_tb,
        EXPONENT_BITS  => EXPONENT_BITS_tb,
        MANTISSA_BITS  => MANTISSA_BITS_tb,
        SIGN_BITS      => SIGN_BITS_tb
    )
    port map(
        clk_in => clk_tb,
        a_in   => a_tb,
        b_in   => b_tb,
        ci_in  => ci_tb,
        rst_in => rst_tb,
        c_out  => c_tb,
        co_out => co_tb
    );
end architecture floating_point_adder_tb_arch;