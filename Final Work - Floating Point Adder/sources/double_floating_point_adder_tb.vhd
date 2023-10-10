-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the testbench of a DOUBLE precision floating point adder


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity double_floating_point_adder_tb is
    -- Void entity
end entity double_floating_point_adder_tb;
    

architecture double_floating_point_adder_tb_arch of double_floating_point_adder_tb is
    -- DUT Component declaration
    component floating_point_adder is
        generic(
            -- Default values for double precision floating point IEEE 754
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
    constant PRECISION_BITS_tb: natural := 64; -- Double precision floating point IEEE 754
    constant EXPONENT_BITS_tb:  natural := 11; -- Double precision floating point IEEE 754
    constant MANTISSA_BITS_tb:  natural := 52; -- Double precision floating point IEEE 754
    constant SIGN_BITS_tb:      natural := 1;  -- Double precision floating point IEEE 754

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

    -- TEST CASE #01 / expected result = +3.845 (0x400EC28F5C28F400) (result is 0x400EC28F5C28F5C2)
    numA_tb <= "0011111111110101100001010001111010111000010100011110101110000101" after 0 ns; -- numA_tb = +1.345           (0x3FF5851EB851EC00)
    numB_tb <= "0100000000000100000000000000000000000000000000000000000000000000" after 0 ns; -- numB_tb = +2.5             (0x4004000000000000)
 
    -- TEST CASE #02 / expected result = +15.5434 (0x402F163886594C00) (result is 0x402F163886594AF4)
    -- numA_tb <= "0100000000001000101111110100100001111111110010111001001000111010" after 0 ns; -- numA_tb = +3.0934          (0x4008BF487FCB9400)
    -- numB_tb <= "0100000000101000111001100110011001100110011001100110011001100110" after 0 ns; -- numB_tb = +12.45           (0x4028E66666666800)

    -- TEST CASE #03 / expected result = 1,588.23359 (0x4098D0EF32378C00) (result is 0x4098D0EF32378AB0)
    -- numA_tb <= "0100000010010100111100001111000000111000010111000110011111100000" after 0 ns; -- numA_tb = +1,340.23459     (0x4094F0F0385C6800)
    -- numB_tb <= "0100000001101110111111111111011111001110110110010001011010000111" after 0 ns; -- numA_tb = +247.999         (0x406EFFF7CED91800)

    -- TEST CASE #04 / expected result = +5.577 (0x40164ED916872C00) (result is 0x40164ED916872B02)
    -- numA_tb <= "0100000000100001001000001100010010011011101001011110001101010100" after 0 ns; -- numA_tb = +8.564           (0x402120C49BA5E400)
    -- numB_tb <= "1100000000000111111001010110000001000001100010010011011101001100" after 0 ns; -- numA_tb = -2.987           (0xC007E56041893800)

    -- TEST CASE #05 / expected result = +5.577 (0x40164ED916872C00) (result is 0x40164ED916872B02)
    -- numA_tb <= "1100000000000111111001010110000001000001100010010011011101001100" after 0 ns; -- numA_tb = -2.987           (0xC007E56041893800)
    -- numB_tb <= "0100000000100001001000001100010010011011101001011110001101010100" after 0 ns; -- numA_tb = +8.564           (0x402120C49BA5E400)

    -- TEST CASE #06 / expected result = +316.110013 (0x4073C1C29CFDD400) (result is 0x4073C1C29CFDD228)
    -- numA_tb <= "0100000001110100100011111101001000011111111100101110010010001111" after 0 ns; -- numA_tb = +328.9888        (0x40748FD21FF2E400)
    -- numB_tb <= "1100000000101001110000011111000001011110101000100100110011000111" after 0 ns; -- numA_tb = -12.878787       (0xC029C1F05EA25000)

    -- TEST CASE #07 / expected result = +316.110013 (0x4073C1C29CFDD400) (result is 0x4073C1C29CFDD228)
    -- numA_tb <= "0100000001110100100011111101001000011111111100101110010010001111" after 0 ns; -- numA_tb = -12.878787       (0xC029C1F05EA25000)
    -- numB_tb <= "1100000000101001110000011111000001011110101000100100110011000111" after 0 ns; -- numA_tb = +328.9888        (0x40748FD21FF2E400)

    -- TEST CASE #08 / expected result = -2,140.8947 (0xC0A0B9CA161E5000) (result is 0xC0A0B9CA161E4F75)
    -- numA_tb <= "0100000001010110010000000101101111000000000110100011011011100011" after 0 ns; -- numA_tb = +89.0056         (0x4056405BC01A3800)
    -- numB_tb <= "1100000010100001011010111100110011110100000111110010000100101101" after 0 ns; -- numA_tb = -2,229.9003      (0xC0A16BCCF41F2000)

    -- TEST CASE #09 / expected result = -2,244.0003 (0xC0A1880027525800) (result is 0xC0A1880027525460)
    -- numA_tb <= "1100000010100001011010111100110011110100000111110010000100101101" after 0 ns; -- numA_tb = -2,229.9003      (0xC0A16BCCF41F2000)
    -- numB_tb <= "1100000000101100001100110011001100110011001100110011001100110011" after 0 ns; -- numA_tb = -14.1            (0xC02C333333333000)

    -- TEST CASE #10 / expected result = +104.356833617123 (0x405A16D65CAAEC00) (result is 0x405A16D65CAAEA07)
    -- numA_tb <= "0100000000111001100100010100011011100011101110101110000100100011" after 0 ns; -- numA_tb = +25.567487939    (0x40399146E3BAE000)
    -- numB_tb <= "0100000001010011101100101000010010100011101111000011000110111110" after 0 ns; -- numA_tb = +78.789345678123 (0x4053B284A3BC3000)
    
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
end architecture double_floating_point_adder_tb_arch;