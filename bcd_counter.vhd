LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Sechsstelliges Format: MM:SS:CC
-- MM = Minuten (00..59)
-- SS = Sekunden (00..59)
-- CC = Hundertstelsekunden (00..99), also 10-ms-Schritte.
-- Die letzten zwei Ziffern entsprechen 00, 10, ..., 990 Millisekunden.
ENTITY bcd_counter IS
    GENERIC (
        G_MAX    : INTEGER RANGE 0 TO 595999 := 595999;  -- Format MMSSCC
        G_CLK_HZ : POSITIVE := 50000000
    );
    PORT (
        strt_in     : IN  std_logic;
        rst_in      : IN  std_logic;  -- synchroner, aktiv-niedriger Reset
        clk_in      : IN  std_logic;
        plus_one    : IN  std_logic;
        cntrl_in    : IN  std_logic_vector(2 DOWNTO 0);
        bcd_digit_1 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX0: 1/100 s
        bcd_digit_2 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX1: 1/10 s
        bcd_digit_3 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX2: Sekunden Einer
        bcd_digit_4 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX3: Sekunden Zehner
        bcd_digit_5 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX4: Minuten Einer
        bcd_digit_6 : OUT std_logic_vector(3 DOWNTO 0);  -- HEX5: Minuten Zehner
        busy_out    : OUT std_logic_vector(2 DOWNTO 0)
    );
END ENTITY bcd_counter;

ARCHITECTURE behav OF bcd_counter IS
    -- Bei 50 MHz: 500000 Takte pro Hundertstelsekunde (10 ms).
    CONSTANT C_CS_TICKS     : POSITIVE := G_CLK_HZ / 100;
    CONSTANT C_MANUAL_TICKS : POSITIVE := G_CLK_HZ / 10;

    SIGNAL clk_divider     : INTEGER RANGE 0 TO C_CS_TICKS - 1 := 0;
    SIGNAL pls_one_divider : INTEGER RANGE 0 TO C_MANUAL_TICKS - 1 := 0;

    SIGNAL centi_ones   : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL centi_tens   : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL seconds_ones : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL seconds_tens : INTEGER RANGE 0 TO 5 := 0;
    SIGNAL minutes_ones : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL minutes_tens : INTEGER RANGE 0 TO 5 := 0;

    SIGNAL time_value : INTEGER RANGE 0 TO 595999 := 0;
    SIGNAL busy_state : std_logic_vector(2 DOWNTO 0) := "111";
BEGIN
    ASSERT G_CLK_HZ >= 100 AND (G_CLK_HZ MOD 100) = 0
        REPORT "G_CLK_HZ muss mindestens 100 und durch 100 teilbar sein."
        SEVERITY FAILURE;

    ASSERT (((G_MAX / 100) MOD 100) <= 59)
        REPORT "G_MAX muss eine gueltige Zeit im Format MMSSCC sein (Sekunden <= 59)."
        SEVERITY FAILURE;

    -- Numerische Darstellung MMSSCC fuer den einstellbaren Grenzwert.
    time_value <= minutes_tens * 100000 + minutes_ones * 10000 +
                  seconds_tens * 1000 + seconds_ones * 100 +
                  centi_tens * 10 + centi_ones;

    PROCESS (clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF rst_in = '0' THEN
                centi_ones     <= 0;
                centi_tens     <= 0;
                seconds_ones   <= 0;
                seconds_tens   <= 0;
                minutes_ones   <= 0;
                minutes_tens   <= 0;
                clk_divider     <= 0;
                pls_one_divider <= 0;
                busy_state      <= "111";

            ELSIF strt_in = '1' AND plus_one = '0' THEN
                -- Automatisches Hochzaehlen alle 10 ms.
                busy_state <= "100";
                pls_one_divider <= 0;

                IF clk_divider = C_CS_TICKS - 1 THEN
                    clk_divider <= 0;

                    IF time_value >= G_MAX THEN
                        -- Bei 59:59.99 (oder benutzerdefiniertem G_MAX) zu 00:00.00.
                        centi_ones   <= 0;
                        centi_tens   <= 0;
                        seconds_ones <= 0;
                        seconds_tens <= 0;
                        minutes_ones <= 0;
                        minutes_tens <= 0;
                    ELSIF centi_ones < 9 THEN
                        centi_ones <= centi_ones + 1;
                    ELSE
                        centi_ones <= 0;
                        IF centi_tens < 9 THEN
                            centi_tens <= centi_tens + 1;
                        ELSE
                            centi_tens <= 0;
                            IF seconds_ones < 9 THEN
                                seconds_ones <= seconds_ones + 1;
                            ELSE
                                seconds_ones <= 0;
                                IF seconds_tens < 5 THEN
                                    seconds_tens <= seconds_tens + 1;
                                ELSE
                                    seconds_tens <= 0;
                                    IF minutes_ones < 9 THEN
                                        minutes_ones <= minutes_ones + 1;
                                    ELSE
                                        minutes_ones <= 0;
                                        IF minutes_tens < 5 THEN
                                            minutes_tens <= minutes_tens + 1;
                                        ELSE
                                            minutes_tens <= 0;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                ELSE
                    clk_divider <= clk_divider + 1;
                END IF;

            ELSIF strt_in = '0' AND plus_one = '1' THEN
                -- Manuelle Zifferneinstellung: alle 0,1 s einen Schritt.
                busy_state  <= "010";
                clk_divider <= 0;

                IF pls_one_divider = C_MANUAL_TICKS - 1 THEN
                    pls_one_divider <= 0;
                    CASE cntrl_in IS
                        WHEN "001" => centi_ones   <= (centi_ones   + 1) MOD 10;
                        WHEN "010" => centi_tens   <= (centi_tens   + 1) MOD 10;
                        WHEN "011" => seconds_ones <= (seconds_ones + 1) MOD 10;
                        WHEN "100" => seconds_tens <= (seconds_tens + 1) MOD 6;
                        WHEN "101" => minutes_ones <= (minutes_ones + 1) MOD 10;
                        WHEN "110" => minutes_tens <= (minutes_tens + 1) MOD 6;
                        WHEN OTHERS => NULL;
                    END CASE;
                ELSE
                    pls_one_divider <= pls_one_divider + 1;
                END IF;

            ELSIF strt_in = '1' AND plus_one = '1' THEN
                -- Pause: Zeit einfrieren.
                busy_state      <= "001";
                clk_divider     <= 0;
                pls_one_divider <= 0;
            ELSE
                -- Kein Modus aktiv: Zeit einfrieren.
                busy_state      <= "000";
                clk_divider     <= 0;
                pls_one_divider <= 0;
            END IF;
        END IF;
    END PROCESS;

    -- BCD-Ziffern direkt an den vorhandenen 6x7-Segment-Top-Level ausgeben.
    bcd_digit_1 <= std_logic_vector(to_unsigned(centi_ones, 4));
    bcd_digit_2 <= std_logic_vector(to_unsigned(centi_tens, 4));
    bcd_digit_3 <= std_logic_vector(to_unsigned(seconds_ones, 4));
    bcd_digit_4 <= std_logic_vector(to_unsigned(seconds_tens, 4));
    bcd_digit_5 <= std_logic_vector(to_unsigned(minutes_ones, 4));
    bcd_digit_6 <= std_logic_vector(to_unsigned(minutes_tens, 4));
    busy_out    <= busy_state;
END ARCHITECTURE behav;
