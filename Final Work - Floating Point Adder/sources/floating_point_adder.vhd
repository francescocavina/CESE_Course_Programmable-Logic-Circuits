-- Author: Francesco Cavina <francescocavina98@gmail.com>
-- Brief:  This is the HW description for a floating point adder (single and double precision)


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
        clk_i:  in  std_logic;                                   -- System clock                                                       / input
        numA_i: in  std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point number A (single or double precision)               / input
        numB_i: in  std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point number B (single or double precision)               / input
        init_i: in  std_logic;                                   -- Set to '1' to begin addition process (then se it back to '0')      / input
        rst_i:  in  std_logic;                                   -- Set to '1' to reset addition process (then set it back to '0')     / input
        c_o:    out std_logic_vector(PRECISION_BITS-1 downto 0); -- Floating point result of the addition (single or double precision) / output
        done_o: out std_logic                                    -- Flag outputs '1' when addition process has finished                / output
    );
end entity floating_point_adder;


architecture floating_point_adder_arch of floating_point_adder is
    -- States declaration for Finite State Machine
    type STATE is (WAIT_STATE,              -- Initial state waiting for init_i input. Signs, exponents and mantissas are extracted from input numbers 
                   ALIGNMENT_STATE,         -- Mantissas are aligned and exponents are updated
                   ADDITION_STATE,          -- Mantissas are added
                   NORMALIZATION_STATE,     -- Mantissas are normalized to comply with IEEE standard
                   ROUNDING_STATE,          -- Rounding is carried out, if needed
                   RENORMALIZATION_STATE,   -- Renormalization is carried out, if need after rounding up
                   DONE_STATE);             -- Addition process is finished

    signal current_state, next_state: STATE;

    -- Constants declaration
    -- Constant to increase sum_mantissa signal length, when mantissa has to be shifted
    -- to match exponents. Maximum exponent in double precision floating point is 1023.
    -- So in the worst case, sum_mantissa should be shiftes 1023 bits to the right.
    constant MAX_EXPONENT: natural := 1023; 

    -- Internal signals declaration for calculations
    signal exponent_a:       std_logic_vector(EXPONENT_BITS   downto 0) := (others => '0');
    signal exponent_b:       std_logic_vector(EXPONENT_BITS   downto 0) := (others => '0');
    signal mantissa_a:       std_logic_vector(MANTISSA_BITS+1 downto 0) := (others => '0');
    signal mantissa_b:       std_logic_vector(MANTISSA_BITS+1 downto 0) := (others => '0');
    signal sign_a:           std_logic := '0';
    signal sign_b:           std_logic := '0';

    signal mantissa_a_aux:   std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    signal mantissa_b_aux:   std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    signal sum_mantissa_aux: std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
    
    -- Internal signals declaration for output result
    signal sum_exponent:     std_logic_vector(EXPONENT_BITS downto 0) := (others => '0');
    signal sum_mantissa:     std_logic_vector(MANTISSA_BITS+1+MAX_EXPONENT downto 0) := (others => '0');
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

            -- Update state
            current_state <= next_state;

            case current_state is
                --=================================================== BEGIN WAIT STATE ===================================================--
                when WAIT_STATE =>
                    if(init_i = '1') then
                        -- Extract exponents from numbers
                        exponent_a <= '0' & numA_i(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-SIGN_BITS-EXPONENT_BITS);
                        exponent_b <= '0' & numB_i(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-SIGN_BITS-EXPONENT_BITS);

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
                --=================================================== END WAIT STATE =====================================================--
                
                --=================================================== BEGIN ALIGNMENT STATE ==============================================-- 
                when ALIGNMENT_STATE =>
                    -- Check if exponents are equal
                    if(exponent_a = exponent_b) then
                        sum_exponent <= exponent_a;
                        
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT) <= mantissa_a; 
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT) <= mantissa_b; 
                    elsif(exponent_a > exponent_b) then
                        -- Calculate difference between exponents
                        exponents_diff := unsigned(exponent_a) - unsigned(exponent_b);

                        sum_exponent <= exponent_a;
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT) <= mantissa_a; 
                        
                        -- Down-shift mantissa B by exponents difference
                        mantissa_b_aux <= (others => '0');
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT-to_integer(exponents_diff) downto MAX_EXPONENT-to_integer(exponents_diff)) <= mantissa_b; 
                    elsif(exponent_b > exponent_a) then
                        -- Calculate difference between exponents
                        exponents_diff := unsigned(exponent_b) - unsigned(exponent_a);

                        sum_exponent <= exponent_b;
                        mantissa_b_aux(MANTISSA_BITS+1+MAX_EXPONENT downto MAX_EXPONENT) <= mantissa_b; 

                        -- Down-shift mantissa A by exponents difference
                        mantissa_a_aux <= (others => '0');
                        mantissa_a_aux(MANTISSA_BITS+1+MAX_EXPONENT-to_integer(exponents_diff) downto MAX_EXPONENT-to_integer(exponents_diff)) <= mantissa_a;
                    end if;

                    -- Next state
                    next_state <= ADDITION_STATE;
                --=================================================== END ALIGNMENT STATE ================================================--
                
                --=================================================== BEGIN ADDITION STATE ===============================================--     
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
                --=================================================== END ADDITION STATE =================================================--             

                --=================================================== BEGIN NORMALIZATION STATE ==========================================--     
                when NORMALIZATION_STATE =>
                    if(unsigned(sum_mantissa) = to_unsigned(0, MANTISSA_BITS+1)) then
                        -- If sum is 0
                        sum_exponent <= (others => '0');
                        sum_mantissa <= (others => '0');
                        sum_sign     <= '0';

                        -- Next state
                        next_state <= DONE_STATE;
                    elsif(sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT) = '1') then
                        -- If mantissas sum produces overflow
                        -- Down-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)+1);
                        sum_mantissa  <= '0' & sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT downto 1);

                        -- Next state
                        next_state <= ROUNDING_STATE;
                    elsif(sum_mantissa(MANTISSA_BITS+MAX_EXPONENT) = '0') then
                        -- If mantissas sum most significant bit is not '0'
                        -- Up-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)-1);
                        sum_mantissa  <= sum_mantissa(MANTISSA_BITS+MAX_EXPONENT downto 0) & '0';

                        -- Next state
                        next_state <= NORMALIZATION_STATE;
                    else
                        -- If mantissas sum is already normalized
                        -- Next state
                        next_state <= ROUNDING_STATE;
                    end if;
                --=================================================== END NORMALIZATION STATE ============================================--

                --=================================================== BEGIN ROUNDING STATE ===============================================--     
                when ROUNDING_STATE =>
                    -- The rounding rule used here is "round to the nearest, ties to even". Namely, round to the nearest value and if the
                    -- number fails midway, it is rounded to the nearest value with an even least significant bit (LSB).

                    -- Get Guard, Round and Sticky bits
                    if(mantissa_a_aux(MAX_EXPONENT-1 downto 0) = std_logic_vector(to_unsigned(0, MAX_EXPONENT-1))) then
                        -- If mantissa B was shifted
                        guard_bit  := unsigned(mantissa_b_aux(MAX_EXPONENT-1 downto MAX_EXPONENT-1));
                        round_bit  := unsigned(mantissa_b_aux(MAX_EXPONENT-2 downto MAX_EXPONENT-2));

                        if(to_integer(unsigned(mantissa_b_aux(MAX_EXPONENT-3 downto 1+MAX_EXPONENT-to_integer(exponents_diff)))) >= 1) then
                            sticky_bit := to_unsigned(1, 1);
                        else 
                            sticky_bit := to_unsigned(0, 1);
                        end if;    
                    else
                        -- If mantissa A was shifted
                        guard_bit  := unsigned(mantissa_a_aux(MAX_EXPONENT-1 downto MAX_EXPONENT-1));
                        round_bit  := unsigned(mantissa_a_aux(MAX_EXPONENT-2 downto MAX_EXPONENT-2));

                        if(to_integer(unsigned(mantissa_a_aux(MAX_EXPONENT-3 downto 1+MAX_EXPONENT-to_integer(exponents_diff)))) >= 1) then
                            sticky_bit := to_unsigned(1, 1);
                        else 
                            sticky_bit := to_unsigned(0, 1);
                        end if; 
                    end if;

                    -- Round up or down based on Guard, Round and Sticky bits
                    if(to_integer(guard_bit) = 0) then
                        -- If Guard bit is 0
                        -- Round down = do nothing

                    elsif(to_integer(round_bit or sticky_bit) = 0) then
                        -- If Guard bit is 1 and (Round bit or Stikcy bit) is 0
                        -- It is a tie, so rounding up or down depends whether the
                        -- mantissa is even or odd
                        if(sum_mantissa(MAX_EXPONENT) = '0') then
                            -- If mantissa is even
                            -- Round down = do nothing

                        else
                            -- If mantissa is odd
                            -- Round up
                            sum_mantissa_aux <= (others => '0');
                            sum_mantissa_aux(MAX_EXPONENT) <= '1';
                            sum_mantissa <= std_logic_vector(unsigned(sum_mantissa) + unsigned(sum_mantissa_aux));
                        end if;    
                    else
                        -- If Guard bit is 1 and (Round bit or Stikcy bit) is 1
                        -- Round up
                        sum_mantissa_aux <= (others => '0');
                        sum_mantissa_aux(MAX_EXPONENT) <= '1';
                        sum_mantissa <= std_logic_vector(unsigned(sum_mantissa) + unsigned(sum_mantissa_aux));
                    end if;    

                    -- Next state
                    next_state <= RENORMALIZATION_STATE;
                --=================================================== END ROUNDING STATE =================================================--
                
                --=================================================== BEGIN RENORMALIZATION STATE ========================================--    
                when RENORMALIZATION_STATE =>
                    if(sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT) = '1') then
                        -- If due to the rounding up, overflow was produced
                        -- Down-shift mantissas sum by one
                        sum_exponent  <= std_logic_vector(unsigned(sum_exponent)+1);
                        sum_mantissa  <= '0' & sum_mantissa(MANTISSA_BITS+1+MAX_EXPONENT downto 1);
                    end if;
                    
                -- Next state
                next_state <= DONE_STATE;
                --=================================================== END RENORMALIZATION STATE ==========================================--

                --=================================================== BEGIN DONE STATE ===================================================--
                when DONE_STATE =>
                    -- Compound addition result 
                    c_o(PRECISION_BITS-1) <= sum_sign;
                    c_o(PRECISION_BITS-1-SIGN_BITS downto PRECISION_BITS-SIGN_BITS-EXPONENT_BITS) <= sum_exponent(EXPONENT_BITS-1 downto 0);
                    c_o(PRECISION_BITS-1-SIGN_BITS-EXPONENT_BITS downto 0) <= sum_mantissa(MANTISSA_BITS-1+MAX_EXPONENT downto MAX_EXPONENT);

                    -- Flag that addition is done
                    done_o <= '1';
                    if(init_i = '0') then 
                        done_o <= '0';

                        -- Next state
                        next_state <= WAIT_STATE;
                    end if;
                --=================================================== END DONE STATE =====================================================--    

                --=================================================== BEGIN DEFAULT STATE ================================================--    
                when others =>
                    -- Next state    
                    next_state <= WAIT_STATE;
                --=================================================== END DEFAULT STATE ==================================================--        

            end case;
        end if;    
    end process;
end architecture floating_point_adder_arch;