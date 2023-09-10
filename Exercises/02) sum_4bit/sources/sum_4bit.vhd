entity sum_4bit is
    generic(
        N: natural := 4
    )
    port(
        a: in std_logic_vector(N-1 downto 0);
        b: in std_logic_vector(N-1 downto 0);
        ci: in std_logic;
        c: out std_logic_vector(N-1 downto 0);
        co: out std_logic_vector(N-1 downto 0)
    )
end entity sum_4bit;