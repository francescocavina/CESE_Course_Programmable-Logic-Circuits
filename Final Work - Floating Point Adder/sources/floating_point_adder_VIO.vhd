library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity floating_point_adder_VIO is
    port( 
        clk_i: in std_logic
    );
end entity floating_point_adder_VIO;


architecture floating_point_adder_VIO_arch of floating_point_adder_VIO is

    -- Constants declaration
    constant PRECISION_BITS_VIO: natural := 32; -- Single precision floating point IEEE 754
    constant EXPONENT_BITS_VIO:  natural := 8;  -- Single precision floating point IEEE 754
    constant MANTISSA_BITS_VIO:  natural := 23; -- Single precision floating point IEEE 754
    constant SIGN_BITS_VIO:      natural := 1;  -- Single precision floating point IEEE 754

    -- Signals declaration
    signal   probe_numA: std_logic_vector(PRECISION_BITS_VIO-1 downto 0);
    signal   probe_numB: std_logic_vector(PRECISION_BITS_VIO-1 downto 0);
    signal   probe_init: std_logic;
    signal   probe_rst:  std_logic;
    signal   probe_c:    std_logic_vector(PRECISION_BITS_VIO-1 downto 0);
    signal   probe_done: std_logic;
    
    -- VIO component declaration
    COMPONENT vio_0 IS
        PORT (
            clk:        IN STD_LOGIC;
            probe_in0:  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            probe_in1:  IN STD_LOGIC_VECTOR( 0 DOWNTO 0);
            probe_out0: OUT STD_LOGIC_VECTOR( 0 DOWNTO 0) := "0";
            probe_out1: OUT STD_LOGIC_VECTOR( 0 DOWNTO 0) := "0" ;
            probe_out2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := "00111111101011000010100011110110";
            probe_out3: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := "01000000001000000000000000000000" 
        );
    END COMPONENT vio_0;
    
begin
    -- Description
    floating_point_adder_inst: entity work.floating_point_adder
        generic map(
          PRECISION_BITS => PRECISION_BITS_VIO, 
          EXPONENT_BITS  => EXPONENT_BITS_VIO, 
          MANTISSA_BITS  => MANTISSA_BITS_VIO,
          SIGN_BITS      => SIGN_BITS_VIO
        )
        port map(
          clk_i  => clk_i,
          numA_i => probe_numA,
          numB_i => probe_numB,
          init_i => probe_init,
          rst_i  => probe_rst,
          c_o    => probe_c,
          done_o => probe_done
        ); 
        
    VIO_inst: vio_0
        port map(
            clk           => clk_i,
            probe_in0     => probe_c, 
            probe_in1(0)  => probe_done,
            probe_out0(0) => probe_rst,
            probe_out1(0) => probe_init,
            probe_out2 => probe_numA,
            probe_out3 => probe_numB
        );    
end floating_point_adder_VIO_arch;