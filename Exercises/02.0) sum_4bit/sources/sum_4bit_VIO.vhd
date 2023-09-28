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
    signal   probe_co: std_logic;
    
    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;

begin
    -- Description
    sum_Nb_inst: entity work.sum_4bit
        port map(
            x_i  => probe_x,
            y_i  => probe_y,
            ci_i => probe_ci,
            z_o  => probe_z,
            co_o => probe_co
        ); 
        
        VIO_inst : vio_0
          PORT MAP (
            clk           => clk_i,
            probe_in0     => probe_z,
            probe_in1(0)  => probe_co,
            probe_out0    => probe_x,
            probe_out1    => probe_y,
            probe_out2(0) => probe_ci
            );
end sum_4bit_VIO_arch;

