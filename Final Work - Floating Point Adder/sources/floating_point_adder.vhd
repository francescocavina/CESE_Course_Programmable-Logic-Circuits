-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a floating point adder

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity floating_point_adder is
    generic(
        -- Default values for single precision floating point IEEE 754
        PRECISION_BITS: natural := 32; -- Single precision floating point IEEE 754
        EXPONENT_BITS:  natural := 8;  -- Single precision floating point IEEE 754
        MANTISSA_BITS:  natural := 23; -- Single precision floating point IEEE 754
        SIGN_BITS:      natural := 1   -- Single precision floating point IEEE 754

        -- Default values for double precision floating point IEEE 754
        -- PRECISION_BITS: natural := 64  -- Double precision floating point IEEE 754
        -- EXPONENT_BITS:  natural := 11; -- Double precision floating point IEEE 754
        -- MANTISSA_BITS:  natural := 52  -- Double precision floating point IEEE 754
        -- SIGN_BITS:      natural := 1   -- Double precision floating point IEEE 754
    );
    port(
        clk_i:  in  std_logic;
        numA_i: in  std_logic_vector(PRECISION_BITS-1 downto 0);
        numB_i: in  std_logic_vector(PRECISION_BITS-1 downto 0);
        init_i: in  std_logic;
        rst_i:  in  std_logic;
        c_o:    out std_logic_vector(PRECISION_BITS-1 downto 0);
        done_o: out std_logic
    );
end entity floating_point_adder;

architecture floating_point_adder_arch of floating_point_adder is
    -- States
    type STATE is (WAIT_STATE, ALIGNMENT_STATE, ADDITION_STATE, NORMALIZATION_STATE, ROUNDING_STATE, RENORMALIZATION_STATE, DONE_STATE);
    signal current_state, next_state: STATE;

    -- Constants
    constant MAX_EXPONENT: natural := 1023;

    -- Internal signals
    signal exponent_a:       std_logic_vector(EXPONENT_BITS   downto 0) := (others => '0');
    signal exponent_b:       std_logic_vector(EXPONENT_BITS   downto 0) := (others => '0');
    signal mantissa_a:       std_logic_vector(MANTISSA_BITS+1 downto 0) := (others => '0');
    signal mantissa_b:       std_logic_vector(MANTISSA_BITS+1 downto 0) := (others => '0');
    signal sign_a:           std_logic := '0';
    signal sign_b:           std_logic := '0';

    signal mantissa_a_aux:   std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    signal mantissa_b_aux:   std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    
    signal sum_exponent:     std_logic_vector(EXPONENT_BITS downto 0) := (others => '0');
    signal sum_mantissa:     std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    signal sum_mantissa_aux: std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    signal sum_sign:         std_logic := '0';

begin
    -- Description
    process(clk_i, rst_i) is
        -- Declarations
        variable exponents_diff: unsigned(EXPONENT_BITS downto 0);
        variable guard_bit:      unsigned(0 downto 0);
        variable round_bit:      unsigned(0 downto 0);
        variable sticky_bit:     unsigned(0 downto 0);
        variable lsb_bit:        unsigned(0 downto 0);
        
    begin
        if(rst_i = '1') then
            -- If reset
            next_state <= WAIT_STATE;
            c_o        <= (others => '0');
            done_o     <= '0';
        elsif(rising_edge(clk_i)) then
            -- If clock rising edge
            current_state <= next_state;

            case current_state is
                when WAIT_STATE =>
                    if(init_i = '1') then
                        -- Extract exponents from numbers
                        exponent_a <= '0' & numA_i(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS+1);
                        exponent_b <= '0' & numB_i(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS+1);

                        -- Extract mantissas from numbers
                        mantissa_a <= "01" & numA_i(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0);
                        mantissa_b <= "01" & numB_i(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0);

                        -- Extract signs from numbers
                        sign_a <= numA_i(PRECISION_BITS-1);
                        sign_b <= numB_i(PRECISION_BITS-1);

                        -- Next state
                        next_state <= ALIGNMENT_STATE;
                    else
                        -- Next state
                        next_state <= WAIT_STATE;
                    end if;   
                    
                when ALIGNMENT_STATE =>
                    -- Check if exponents are equal
                    if(exponent_a = exponent_b) then
                        sum_exponent <= exponent_a;
                        
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= mantissa_a; 
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= mantissa_b; 
                    elsif(exponent_a > exponent_b) then
                        -- Calculate difference between exponents
                        exponents_diff := unsigned(exponent_a) - unsigned(exponent_b);

                        sum_exponent <= exponent_a;
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= mantissa_a; 
                        
                        -- Down-shift exponent B by exponents difference
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT-to_integer(exponents_diff) downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1-to_integer(exponents_diff)) <= mantissa_b; 
                    elsif(exponent_b > exponent_a) then
                        -- Calculate difference between exponents
                        exponents_diff := unsigned(exponent_b) - unsigned(exponent_a);

                        sum_exponent <= exponent_b;
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= mantissa_b; 

                        -- Down-shift exponent A by exponents difference
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-to_integer(exponents_diff) downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1-to_integer(exponents_diff)) <= mantissa_a;
                    end if;

                    -- Next state
                    next_state <= ADDITION_STATE;
                
                when ADDITION_STATE =>
                    if(sign_a = sign_b) then
                        -- If signs are equal
                        -- Add mantissas
                        sum_mantissa <= std_logic_vector(unsigned(mantissa_a_aux) + unsigned(mantissa_b_aux));
                        sum_sign     <= sign_a;
                    else
                        if(unsigned(mantissa_a_aux) >= unsigned(mantissa_b_aux)) then
                            -- If number A is greater than number B
                            sum_mantissa <= std_logic_vector(unsigned(mantissa_a_aux) - unsigned(mantissa_b_aux));
                            sum_sign     <= sign_a;
                        end if;

                        if(unsigned(mantissa_b_aux) > unsigned(mantissa_a_aux)) then
                            -- If number B is greater than number A
                            sum_mantissa <= std_logic_vector(unsigned(mantissa_b_aux) - unsigned(mantissa_a_aux));
                            sum_sign     <= sign_b;
                        end if;
                    end if;

                    -- Next state
                    next_state <= NORMALIZATION_STATE;

                when NORMALIZATION_STATE =>
                    if(unsigned(sum_mantissa) = to_unsigned(0, MANTISSA_BITS+1)) then
                        -- If sum is 0
                        sum_exponent <= (others => '0');
                        sum_mantissa <= (others => '0');
                        sum_sign     <= '0';

                        -- Next state
                        next_state <= ROUNDING_STATE;
                    elsif(sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT) = '1') then
                        -- If mantissas sum produces overflow
                        -- Down-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)+1);
                        sum_mantissa  <= '0' & sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT+1);

                        -- Next state
                        next_state <= ROUNDING_STATE;
                    elsif(sum_mantissa(MANTISSA_BITS+MAX_EXPONENT) = '0') then
                        -- If mantissas sum most significant bit is not '0'
                        -- Up-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)-1);
                        sum_mantissa  <= sum_mantissa(MANTISSA_BITS+MAX_EXPONENT downto MAX_EXPONENT) & '0';

                        -- Next state
                        next_state <= NORMALIZATION_STATE;
                    else
                        -- If mantissas sum is already normalized
                        -- Next state
                        next_state <= ROUNDING_STATE;
                    end if;

                when ROUNDING_STATE =>

                    -- Get Guard, Round and Sticky bits
                    if(mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2 downto 0) = std_logic_vector(to_unsigned(0, MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2))) then
                        -- If mantissa B was shifted
                        guard_bit  := unsigned(mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2));
                        round_bit  := unsigned(mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-3 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-3));

                        if(to_integer(unsigned(mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-4 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-to_integer(exponents_diff)))) >= 1) then
                            sticky_bit := to_unsigned(1, 1);
                        else 
                            sticky_bit := to_unsigned(0, 1);
                        end if;    
                    else
                        -- If mantissa A was shifted
                        guard_bit  := unsigned(mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-2));
                        round_bit  := unsigned(mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-3 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-3));

                        if(to_integer(unsigned(mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-4 downto MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-to_integer(exponents_diff)))) >= 1) then
                            sticky_bit := to_unsigned(1, 1);
                        else 
                            sticky_bit := to_unsigned(0, 1);
                        end if; 
                    end if;

                    -- Round up or down based on Guard, Round and Sticky bits
                    if(to_integer(guard_bit) = 0) then
                        -- Round down = do nothing

                    elsif(to_integer(round_bit or sticky_bit) = 0) then
                        if(sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) = '0') then
                            -- Round down = do nothing

                        else
                            -- Round up
                            sum_mantissa_aux <= (others => '0');
                            sum_mantissa_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= '1';
                            sum_mantissa <= std_logic_vector(unsigned(sum_mantissa) + unsigned(sum_mantissa_aux));
                        end if;    
                    else
                        -- Round up
                        sum_mantissa_aux <= (others => '0');
                        sum_mantissa_aux(MANTISSA_BITS+1+MAX_EXPONENT-MANTISSA_BITS-1) <= '1';
                        sum_mantissa <= std_logic_vector(unsigned(sum_mantissa) + unsigned(sum_mantissa_aux));
                    end if;    

                    -- Next state
                    next_state <= RENORMALIZATION_STATE;

                when RENORMALIZATION_STATE =>
                    if(sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT) = '1') then
                        -- If mantissas sum produces overflow
                        -- Down-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)+1);
                        sum_mantissa  <= '0' & sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT+1);
                    end if;
                    
                -- Next state
                next_state <= DONE_STATE;
                
                when DONE_STATE =>
                    -- Compound addition result 
                    c_o(PRECISION_BITS-1) <= sum_sign;
                    c_o(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS+1) <= sum_exponent(EXPONENT_BITS-1 downto 0);
                    c_o(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0) <= sum_mantissa(MANTISSA_BITS-1+MAX_EXPONENT downto MAX_EXPONENT);

                    -- Flag that addition is done
                    done_o <= '1';
                    if(init_i = '0') then 
                        done_o <= '0';

                        -- Next state
                        next_state <= WAIT_STATE;
                    end if;
                    
                when others =>
                    -- Next state    
                    next_state <= WAIT_STATE;
            end case;
        end if;    
    end process;
end architecture floating_point_adder_arch;