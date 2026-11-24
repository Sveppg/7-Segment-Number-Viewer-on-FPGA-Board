LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Anzeige auf sechs 7-Segment-Anzeigen: MM:SS:CC (10-ms-Aufloesung).
ENTITY twenty_four_hour_clock IS
    GENERIC (
        G_MAX    : INTEGER RANGE 0 TO 595999 := 595999;  -- MMSSCC
        G_CLK_HZ : POSITIVE := 50000000
    );
    PORT (
        strt_in  : IN  std_logic;
        rst_in   : IN  std_logic;
        clk_in   : IN  std_logic;
        plus_one : IN  std_logic;
        ltn_in   : IN  std_logic;
        bln_in   : IN  std_logic;
        cntrl_in : IN  std_logic_vector(2 DOWNTO 0);
        busy_out : OUT std_logic_vector(2 DOWNTO 0);
        seg_out  : OUT std_logic_vector(41 DOWNTO 0)
    );
END ENTITY twenty_four_hour_clock;

ARCHITECTURE struct OF twenty_four_hour_clock IS
    SIGNAL s_bcd_connect : std_logic_vector(23 DOWNTO 0);
BEGIN
    u_bcd_counter : ENTITY work.bcd_counter(behav)
        GENERIC MAP (
            G_MAX    => G_MAX,
            G_CLK_HZ => G_CLK_HZ
        )
        PORT MAP (
            strt_in     => strt_in,
            rst_in      => rst_in,
            clk_in      => clk_in,
            plus_one    => plus_one,
            cntrl_in    => cntrl_in,
            bcd_digit_1 => s_bcd_connect(3 DOWNTO 0),    -- HEX0: 1/100 s
            bcd_digit_2 => s_bcd_connect(7 DOWNTO 4),    -- HEX1: 1/10 s
            bcd_digit_3 => s_bcd_connect(11 DOWNTO 8),   -- HEX2: Sekunden Einer
            bcd_digit_4 => s_bcd_connect(15 DOWNTO 12),  -- HEX3: Sekunden Zehner
            bcd_digit_5 => s_bcd_connect(19 DOWNTO 16),  -- HEX4: Minuten Einer
            bcd_digit_6 => s_bcd_connect(23 DOWNTO 20),  -- HEX5: Minuten Zehner
            busy_out    => busy_out
        );

    gen_bcd_to_segment_encoder : FOR i IN 0 TO 5 GENERATE
        u_bcd_to_segment_encoder : ENTITY work.bcd_to_segment_encoder
            PORT MAP (
                bln_in => bln_in,
                ltn_in => ltn_in,
                bcd_in => s_bcd_connect(4*i + 3 DOWNTO 4*i),
                a_out  => seg_out(i*7),
                b_out  => seg_out(i*7 + 1),
                c_out  => seg_out(i*7 + 2),
                d_out  => seg_out(i*7 + 3),
                e_out  => seg_out(i*7 + 4),
                f_out  => seg_out(i*7 + 5),
                g_out  => seg_out(i*7 + 6)
            );
    END GENERATE gen_bcd_to_segment_encoder;
END ARCHITECTURE struct;
