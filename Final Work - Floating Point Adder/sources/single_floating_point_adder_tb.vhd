-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a SINGLE floating point adder


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity single_floating_point_adder_tb is
    -- Void entity
end entity single_floating_point_adder_tb;
    

architecture single_floating_point_adder_tb_arch of single_floating_point_adder_tb is
    -- DUT Component declaration
    component floating_point_adder is
        generic(
            -- Default values for single precision floating point IEEE 754
            PRECISION_BITS: natural := 32;
            EXPONENT_BITS:  natural := 8;
            MANTISSA_BITS:  natural := 23;
            SIGN_BITS:      natural := 1
        );
        port(
            clk_i:  in  std_logic;                                   -- System clock                                                       / input
            numA_i: in  std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point number A (single or double precision)               / input
            numB_i: in  std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point number B (single or double precision)               / input
            init_i: in  std_logic;                                   -- Set to '1' to begin addition process (then se it back to '0')      / input
            rst_i:  in  std_logic;                                   -- Set to '1' to reset addition process (then set it back to '0')     / input
            c_o:    out std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point result of the addition (single or double precision) / output
            done_o: out std_logic                                    -- Flag outputs '1' when addition process has finished                / output
        );
    end component floating_point_adder;

    -- Constants declaration
    constant PRECISION_BITS_tb: natural := 32; -- Single precision floating point IEEE 754
    constant EXPONENT_BITS_tb:  natural := 8;  -- Single precision floating point IEEE 754
    constant MANTISSA_BITS_tb:  natural := 23; -- Single precision floating point IEEE 754
    constant SIGN_BITS_tb:      natural := 1;  -- Single precision floating point IEEE 754

    -- Testbench signals declaration
    signal clk_tb:  std_logic := '0';
    signal numA_tb: std_logic_vector(PRECISION_BITS_tb-1 downto 0) := (others => '0');
    signal numB_tb: std_logic_vector(PRECISION_BITS_tb-1 downto 0) := (others => '0');
    signal init_tb: std_logic := '0';
    signal rst_tb:  std_logic := '0';
    signal c_tb:    std_logic_vector(PRECISION_BITS_tb-1 downto 0);
    signal done_tb: std_logic;

begin
    -- Description

    clk_tb  <= not clk_tb after 50 ns;
    rst_tb  <= '1' after 20 ns, '0' after 40 ns;
    init_tb <= '1' after 75 ns;

    -- TEST CASE #01 / expected result = +3.845 (0x4076147B)
    -- numA_tb <= "00111111101011000010100011110110" after 0 ns; -- numA_tb = +1.345           (0x3FAC28F6)
    -- numB_tb <= "01000000001000000000000000000000" after 0 ns; -- numB_tb = +2.5             (0x40200000)

    -- TEST CASE #02 / expected result = +15.5434 (0x4178B1C4)
    -- numA_tb <= "01000000010001011111101001000100" after 0 ns; -- numA_tb = +3.0934          (0x4045FA44)
    -- numB_tb <= "01000001010001110011001100110011" after 0 ns; -- numB_tb = +12.45           (0x41473333)

    -- TEST CASE #03 / expected result = 1,588.2336119 (0x44C6877A) (result is 0x44C68779)
    -- numA_tb <= "01000100101001111000011110000010" after 0 ns; -- numA_tb = +1,340.234619    (0x44A78782)
    -- numB_tb <= "01000011011101111111111110111110" after 0 ns; -- numA_tb = +247.9989929     (0x4377FFBE)

    -- TEST CASE #04 / expected result = +5.577 (0x40B276C9)
    -- numA_tb <= "01000001000010010000011000100101" after 0 ns; -- numA_tb = +8.564           (0x41090625)
    -- numB_tb <= "11000000001111110010101100000010" after 0 ns; -- numA_tb = -2.987           (0xC03F2B02)

    -- TEST CASE #05 / expected result = +5.577 (0x40B276C9) (result is 0x40B276CA)
    -- numA_tb <= "11000000001111110010101100000010" after 0 ns; -- numA_tb = -2.987           (0xC03F2B02)
    -- numB_tb <= "01000001000010010000011000100101" after 0 ns; -- numA_tb = +8.564           (0x41090625)

    -- TEST CASE #06 / expected result = +316.110013 (0x439E0E14)
    -- numA_tb <= "01000011101001000111111010010001" after 0 ns; -- numA_tb = +328.9888        (0x43A47E91)
    -- numB_tb <= "11000001010011100000111110000011" after 0 ns; -- numA_tb = -12.878787       (0xC14E0F83)

    -- TEST CASE #07 / expected result = +316.110013 (0x439E0E14)
    -- numA_tb <= "11000001010011100000111110000011" after 0 ns; -- numA_tb = -12.878787       (0xC14E0F83)
    -- numB_tb <= "01000011101001000111111010010001" after 0 ns; -- numA_tb = +328.9888        (0x43A47E91)

    -- TEST CASE #08 / expected result = -2,140.8947 (0xC505CE51) (result is 0xC505CE52)
    -- numA_tb <= "01000010101100100000001011011110" after 0 ns; -- numA_tb = +89.0056         (0x42B202DE)
    -- numB_tb <= "11000101000010110101111001101000" after 0 ns; -- numA_tb = -2,229.9003      (0xC50B5E68)

    -- TEST CASE #09 / expected result = -2,244.0003 (0xC50C4001)
    -- numA_tb <= "11000101000010110101111001101000" after 0 ns; -- numA_tb = -2,229.9003      (0xC50B5E68)
    -- numB_tb <= "11000001011000011001100110011010" after 0 ns; -- numA_tb = -14.1            (0xC161999A)

    -- TEST CASE #10 / expected result = +104.356833617123 (0x42D0B6B3)
    -- numA_tb <= "01000001110011001000101000110111" after 0 ns; -- numA_tb = +25.567487939    (0x41CC8A37)
    -- numB_tb <= "01000010100111011001010000100101" after 0 ns; -- numA_tb = +78.789345678123 (0x429D9425)
    
    DUT: floating_point_adder
        generic map(
            PRECISION_BITS => PRECISION_BITS_tb,
            EXPONENT_BITS  => EXPONENT_BITS_tb,
            MANTISSA_BITS  => MANTISSA_BITS_tb,
            SIGN_BITS      => SIGN_BITS_tb
        )
        port map(
            clk_i  => clk_tb,
            numA_i => numA_tb,
            numB_i => numB_tb,
            init_i => init_tb,
            rst_i  => rst_tb,
            c_o    => c_tb,
            done_o => done_tb
        );
end architecture single_floating_point_adder_tb_arch;